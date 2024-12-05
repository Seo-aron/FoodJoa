package DAOs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import Common.DBConnector;
import VOs.MemberVO;
import VOs.RecipeReviewVO;
import VOs.RecipeVO;
import VOs.RecipeWishListVO;

public class RecipeDAO {

	private DBConnector dbConnector;
	
	public RecipeDAO() {
		dbConnector = new DBConnector();
	}
	
	public ArrayList<HashMap<String, Object>> selectRecipesWithAvgRating(String category) {
		
		int _category = Integer.parseInt(category);
		
		ArrayList<HashMap<String, Object>> recipes = new ArrayList<HashMap<String,Object>>();
		
		String sql = "SELECT "
				+ "    r.*, "
				+ "    COALESCE(rr.average_rating, 0) AS average_rating, "
				+ "    COALESCE(rr.review_count, 0) AS review_count, "
				+ "    m.nickname AS nickname "
				+ "FROM recipe r "
				+ "LEFT JOIN ( "
				+ "	   SELECT recipe_no, AVG(rating) AS average_rating, COUNT(rating) AS review_count "
				+ "    FROM recipe_review "
				+ "    GROUP BY recipe_no "
				+ ")rr ON r.no = rr.recipe_no "
				+ "LEFT JOIN member m ON r.id=m.id ";
		
		if (_category != 0) sql += "WHERE r.category=? ";
		
		sql += "ORDER BY r.post_date DESC";
		
		ResultSet resultSet = _category != 0 ?
				dbConnector.executeQuery(sql, _category) : dbConnector.executeQuery(sql);
		
		try {
			while (resultSet.next()) {
				
				RecipeVO recipe = new RecipeVO(
						resultSet.getInt("no"),
						resultSet.getString("id"),
						resultSet.getString("title"),
						resultSet.getString("thumbnail"),
						resultSet.getString("description"),
						resultSet.getString("contents"),
						resultSet.getInt("category"),
						resultSet.getInt("views"),
						resultSet.getString("ingredient"),
						resultSet.getString("ingredient_amount"),
						resultSet.getString("orders"),
						resultSet.getTimestamp("post_date"));
				
				float avgReview = resultSet.getFloat("average_rating");
				int reviewCount = resultSet.getInt("review_count");
				String nickname = resultSet.getString("nickname");
				
				HashMap<String, Object> recipeHashMap = new HashMap<String, Object>();
				recipeHashMap.put("recipe", recipe);
				recipeHashMap.put("average", avgReview);
				recipeHashMap.put("reviewCount", reviewCount);
				recipeHashMap.put("nickname", nickname);
				
				recipes.add(recipeHashMap);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectRecipes() SQLException 발생");
		}
		
		dbConnector.release();
		
		return recipes;
	}

	public RecipeVO selectRecipe(String no) {
		
		String sql = "SELECT * FROM recipe WHERE no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, Integer.parseInt(no));
		
		RecipeVO recipe = null;
		
		try {
			if (resultSet.next()) {
				recipe = new RecipeVO(
						resultSet.getInt("no"),
						resultSet.getString("id"),
						resultSet.getString("title"),
						resultSet.getString("thumbnail"),
						resultSet.getString("description"),
						resultSet.getString("contents"),
						resultSet.getInt("category"),
						resultSet.getInt("views"),
						resultSet.getString("ingredient"),
						resultSet.getString("ingredient_amount"),
						resultSet.getString("orders"),
						resultSet.getTimestamp("post_date"));
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectRecipe() SQLException 발생");
		}		
		
		dbConnector.release();
		
		return recipe;
	}
	
	public HashMap<String, Object> selectRecipeInfo(String no, String id) {
		
		boolean flag = false;
		
		String sql = "UPDATE recipe SET views=views+1 where no=?";
		
		dbConnector.executeUpdate(sql, Integer.parseInt(no));
		
		dbConnector.release();
		
		HashMap<String, Object> recipeHashMap = new HashMap<String, Object>();
		
		sql = "SELECT r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating, "
				+ "m.nickname AS nickname, m.profile AS profile "
				+ "FROM recipe r "
				+ "LEFT JOIN ( "
				+ "SELECT recipe_no, AVG(rating) AS average_rating "
				+ "FROM recipe_review "
				+ "GROUP BY recipe_no "
				+ ") avg_rating ON r.no = avg_rating.recipe_no "
				+ "LEFT JOIN member m ON r.id=m.id "
				+ "WHERE r.no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, Integer.parseInt(no));
		
		try {
			if (resultSet.next()) {
				recipeHashMap.put("recipe", new RecipeVO(
						resultSet.getInt("no"),
						resultSet.getString("id"),
						resultSet.getString("title"),
						resultSet.getString("thumbnail"),
						resultSet.getString("description"),
						resultSet.getString("contents"),
						resultSet.getInt("category"),
						resultSet.getInt("views"),
						resultSet.getString("ingredient"),
						resultSet.getString("ingredient_amount"),
						resultSet.getString("orders"),
						resultSet.getTimestamp("post_date")));
				
				flag = true;
				
				recipeHashMap.put("averageRating", resultSet.getDouble("average_rating"));
				recipeHashMap.put("nickname", resultSet.getString("nickname"));
				recipeHashMap.put("profile", resultSet.getString("profile"));
			}
		}
		catch (Exception e) {
			e.printStackTrace();
			System.out.println("selectRecipeInfo() SQLException 발생");
		}
		
		dbConnector.release();
		
		recipeHashMap.put("reviews", selectRecipeReviews(no));
		
		if (flag && id != null && !id.equals("") && id.length() != 0) {
			
			sql = "SELECT COUNT(*) AS result FROM recent_view WHERE id=? AND item_no=? AND type=?";
			
			resultSet = dbConnector.executeQuery(sql, id, no, 0);
			
			boolean isExistRecent = false;
			try {
				if (resultSet.next()) {
					int result = resultSet.getInt("result");
					
					isExistRecent = result > 0;
				}
			}
			catch (SQLException e) {
				e.printStackTrace();
			}
			
			dbConnector.release();
			
			if (!isExistRecent) {				
				sql = "INSERT INTO recent_view(id, item_no, type, view_date) "
						+ "VALUES(?, ?, ?, CURRENT_TIMESTAMP)";
				
				int result = dbConnector.executeUpdate(sql, id, no, 0);
				
				dbConnector.release();
			}
		}
		
		return recipeHashMap;
	}
	
	public int insertRecipe(RecipeVO recipe) {
		
		String sql = "INSERT INTO recipe(id, title, thumbnail, description, "
				+ "contents, category, views, "
				+ "ingredient, ingredient_amount, orders, empathy, post_date) "
				+ "values(?, ?, ?, ?, ?, ?, 0, ?, ?, ?, 0, CURRENT_TIMESTAMP)";
		
		return dbConnector.executeUpdate(sql,
				recipe.getId(),
				recipe.getTitle(),
				recipe.getThumbnail(),
				recipe.getDescription(),
				recipe.getContents(),
				recipe.getCategory(),
				recipe.getIngredient(),
				recipe.getIngredientAmount(),
				recipe.getOrders());
	}

	public int selectInsertedRecipeNo(RecipeVO recipe) {
		
		String updateSql = "INSERT INTO recipe(id, title, thumbnail, description, "
				+ "contents, category, views, "
				+ "ingredient, ingredient_amount, orders, post_date) "
				+ "values(?, ?, ?, ?, ?, ?, 0, ?, ?, ?, CURRENT_TIMESTAMP)";
		
		String selectSql = "SELECT no FROM recipe ORDER BY no DESC LIMIT 1"; 
		
		ResultSet resultSet = dbConnector.executeUpdateQuery(updateSql, selectSql,
				recipe.getId(),
				recipe.getTitle(),
				recipe.getThumbnail(),
				recipe.getDescription(),
				recipe.getContents(),
				recipe.getCategory(),
				recipe.getIngredient(),
				recipe.getIngredientAmount(),
				recipe.getOrders());
		
		int result = -1;
		
		try {
			if (resultSet.next()) {
				result = resultSet.getInt("no");
			}
		} 
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectInsertedRecipeNo() SQLException 발생");
		}
		
		dbConnector.release();
		
		return result;
	}
	
	public int updateRecipe(RecipeVO recipe) {

		String sql = "update recipe set title=?, thumbnail=?, description=?, contents=?, category=?, "
				+ "views=?, ingredient=?, ingredient_amount=?, orders=? where no=? and id=?";
		
		return dbConnector.executeUpdate(sql,
				recipe.getTitle(),
				recipe.getThumbnail(),
				recipe.getDescription(),
				recipe.getContents(),
				recipe.getCategory(),
				recipe.getViews(),
				recipe.getIngredient(),
				recipe.getIngredientAmount(),
				recipe.getOrders(),
				recipe.getNo(),
				recipe.getId());
	}
	
	public int deleteRecipe(String id, String no) {
		
		String sql = "delete from recipe where id=? and no=?";
		
		return dbConnector.executeUpdate(sql, id, Integer.parseInt(no));
	}
	
	// 0 : DB 통신 실패, 1 : insert 성공, 2 : 이미 값이 있음
	public int insertRecipeWishlist(String id, String recipeNo) {		
		
		String sql = "SELECT * FROM recipe_wishlist WHERE id=? AND recipe_no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, id, Integer.parseInt(recipeNo));
		
		try {
			if (resultSet.next()) {
				return 2;
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		dbConnector.release();

		int result = 0;
		
		sql = "INSERT INTO recipe_wishlist(id, recipe_no, choice_date) values(?, ?, CURRENT_TIMESTAMP)";
		
		result = dbConnector.executeUpdate(sql, id, recipeNo);
		
		dbConnector.release();
		
		return result;
	}
	
	public double selectRecipeRatingAvg(int recipeNo) {
		
		String sql = "SELECT recipe_no, AVG(rating) as avg_rating FROM recipe_review "
				+ "GROUP BY recipe_no HAVING recipe_no=?;";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, recipeNo);
		
		double result = -1;
		
		try {
			if (resultSet.next()) {
				result = resultSet.getDouble("avg_rating");
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return result;
	}
	
	public ArrayList<HashMap<String, Object>> selectRecipeReviews(String recipeNo) {
		
		ArrayList<HashMap<String, Object>> reviews = new ArrayList<HashMap<String, Object>>();
		
		String sql = "SELECT r.*, m.nickname, m.profile "
				+ "FROM recipe_review r "
				+ "LEFT JOIN member m ON r.id=m.id "
				+ "WHERE recipe_no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, Integer.parseInt(recipeNo));
		
		try {
			while (resultSet.next()) {
				
				HashMap<String, Object> reviewMap = new HashMap<String, Object>();
				
				RecipeReviewVO review = new RecipeReviewVO(
						resultSet.getInt("no"),
						resultSet.getString("id"),
						resultSet.getInt("recipe_no"),
						resultSet.getString("pictures"),
						resultSet.getString("contents"),
						resultSet.getInt("rating"),
						resultSet.getTimestamp("post_date"));
				
				String nickname = resultSet.getString("nickname");
				String profile = resultSet.getString("profile");
				
				reviewMap.put("review", review);
				reviewMap.put("nickname", nickname);
				reviewMap.put("profile", profile);
				
				reviews.add(reviewMap);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectRecipeReviewes() SQLException 발생");
		}
		
		dbConnector.release();
		
		return reviews;
	}
	
	public ArrayList<HashMap<String, Object>> selectRecipeReviewsById(String id) {
		
		ArrayList<HashMap<String, Object>> reviews = new ArrayList<HashMap<String,Object>>();
		
		String sql = "SELECT "
				+ "r.no AS r_no, r.title, r.category, "
				+ "rv.no AS rv_no, rv.recipe_no, rv.pictures, rv.contents, rv.rating, rv.post_date, "
				+ "m.nickname "
				+ "FROM recipe_review rv "
				+ "JOIN recipe r "
				+ "ON rv.recipe_no=r.no "
				+ "JOIN member m "
				+ "ON r.id=m.id "
				+ "WHERE rv.id=? "
				+ "ORDER BY rv.post_date DESC";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, id);
		
		try {
			while (resultSet.next()) {
				HashMap<String, Object> review = new HashMap<String, Object>();
				
				RecipeVO recipeVO = new RecipeVO();
				recipeVO.setNo(resultSet.getInt("r_no"));
				recipeVO.setTitle(resultSet.getString("title"));
				recipeVO.setCategory(resultSet.getInt("category"));
				
				RecipeReviewVO reviewVO = new RecipeReviewVO();
				reviewVO.setNo(resultSet.getInt("rv_no"));
				reviewVO.setRecipeNo(resultSet.getInt("recipe_no"));
				reviewVO.setPictures(resultSet.getString("pictures"));
				reviewVO.setContents(resultSet.getString("contents"));
				reviewVO.setRating(resultSet.getInt("rating"));
				reviewVO.setPostDate(resultSet.getTimestamp("post_date"));
				
				MemberVO memberVO = new MemberVO();
				memberVO.setNickname(resultSet.getString("nickname"));
				
				review.put("recipe", recipeVO);
				review.put("review", reviewVO);
				review.put("member", memberVO);
				
				reviews.add(review);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return reviews;
	}
	
	public HashMap<String, Object> selectRecipeReview(String reviewNo) {
		
		HashMap<String, Object> review = new HashMap<String, Object>();
		
		String sql = "SELECT "
				+ "r.title, r.thumbnail, "
				+ "rv.* "
				+ "FROM recipe_review rv "
				+ "LEFT JOIN recipe r "
				+ "ON rv.recipe_no=r.no "
				+ "WHERE rv.no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, Integer.parseInt(reviewNo));
		
		try {
			if (resultSet.next()) {
				RecipeVO recipeVO = new RecipeVO();
				recipeVO.setTitle(resultSet.getString("title"));
				recipeVO.setThumbnail(resultSet.getString("thumbnail"));
				
				RecipeReviewVO reviewVO = new RecipeReviewVO(
						resultSet.getInt("no"), 
						resultSet.getString("id"), 
						resultSet.getInt("recipe_no"), 
						resultSet.getString("pictures"), 
						resultSet.getString("contents"), 
						resultSet.getInt("rating"), 
						resultSet.getTimestamp("post_date"));
				
				review.put("recipeVO", recipeVO);
				review.put("reviewVO", reviewVO);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return review;
	}
	
	public boolean isExistRecipeReview(String id, String recipeNo) {
		
		String sql = "SELECT * FROM recipe_review WHERE id=? and recipe_no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, id, Integer.parseInt(recipeNo));
		
		boolean result = false;
		
		try {
			result = resultSet.next();
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("isExistRecipeReview SQLException 예외 발생");
		}
		
		dbConnector.release();
		
		return result;
	}
	
	public int insertRecipeReivew(RecipeReviewVO review) {
		
		int result = 0;
		
		String sql = "INSERT INTO recipe_review(id, recipe_no, pictures, contents, rating, post_date) "
				+ "VALUES(?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
		
		result = dbConnector.executeUpdate(sql,
				review.getId(),
				review.getRecipeNo(),
				review.getPictures(),
				review.getContents(),
				review.getRating());
		
		dbConnector.release();
		
		return result;
	}
	
	public int updateRecipeReview(RecipeReviewVO review) {
		
		int result = 0;
		
		String sql = "UPDATE recipe_review SET pictures=?, contents=?, rating=? WHERE no=? AND id=? AND recipe_no=?";
		
		result = dbConnector.executeUpdate(sql,
				review.getPictures(),
				review.getContents(),
				review.getRating(),
				review.getNo(),
				review.getId(),
				review.getRecipeNo());
		
		dbConnector.release();
		
		return result;
	}
	
	public int deleteRecipeReview(String no, String id) {
		
		int result = 0;
		
		String sql = "DELETE FROM recipe_review WHERE no=? AND id=?";
		
		result = dbConnector.executeUpdate(sql, Integer.parseInt(no), id);
		
		dbConnector.release();
		
		return result;
	}
	
	public ArrayList<HashMap<String, Object>> selectRecipeInfos(String userId) {

	    ArrayList<HashMap<String, Object>> recipeInfos = new ArrayList<HashMap<String, Object>>();
	    
	    // 수정된 SQL 쿼리
	    String sql = "SELECT "
	            + "recipeWithAvg.*, "
	            + "m.nickname AS author_nickname " // 레시피 작성자의 닉네임을 가져옴
	            + "FROM recipe_wishlist wish "
	            + "LEFT JOIN ( "
	            + "SELECT r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating "
	            + "FROM recipe r "
	            + "LEFT JOIN ( "
	            + "SELECT review.recipe_no, AVG(rating) AS average_rating "
	            + "FROM recipe_review review "
	            + "GROUP BY recipe_no "
	            + ") avg_rating ON r.no = avg_rating.recipe_no "
	            + ") recipeWithAvg ON wish.recipe_no = recipeWithAvg.no "
	            + "LEFT JOIN member m ON recipeWithAvg.id = m.id " // 수정된 부분: recipe의 작성자 id와 member를 연결
	            + "WHERE wish.id=?"
	            + "ORDER BY wish.choice_date DESC;";
	    
	    ResultSet resultSet = dbConnector.executeQuery(sql, userId);
	    
	    try {
	        while (resultSet.next()) {
	            HashMap<String, Object> recipeInfo = new HashMap<String, Object>();
	            
	            RecipeVO recipeVO = new RecipeVO(
	                    resultSet.getInt("no"),
	                    resultSet.getString("id"),
	                    resultSet.getString("title"),
	                    resultSet.getString("thumbnail"),
	                    resultSet.getString("description"),
	                    resultSet.getString("contents"),
	                    resultSet.getInt("category"),
	                    resultSet.getInt("views"),
	                    resultSet.getString("ingredient"),
	                    resultSet.getString("ingredient_amount"),
	                    resultSet.getString("orders"),
	                    resultSet.getTimestamp("post_date"));
	            
	            double averageRating = resultSet.getDouble("average_rating");
	            String authorNickname = resultSet.getString("author_nickname"); // 작성자의 닉네임 가져오기
	            
	            recipeInfo.put("recipeVO", recipeVO);
	            recipeInfo.put("averageRating", averageRating);
	            recipeInfo.put("nickname", authorNickname); // 위시리스트에 작성자 닉네임 추가
	            
	            recipeInfos.add(recipeInfo);
	        }
	    }
	    catch (SQLException e) {
	        e.printStackTrace();
	    }
	    
	    dbConnector.release();
	    
	    return recipeInfos;
	}

	public ArrayList<HashMap<String, Object>> selectRecipesById(String id) {
		
		ArrayList<HashMap<String, Object>> recipes = new ArrayList<HashMap<String,Object>>();
		
		String sql = "SELECT r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating "
				+ "FROM recipe r "
				+ "LEFT JOIN ( "
				+ "SELECT recipe_no, AVG(rating) AS average_rating "
				+ "FROM recipe_review "
				+ "GROUP BY recipe_no "
				+ ") avg_rating ON r.no = avg_rating.recipe_no "
				+ "WHERE r.id=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, id);
		
		try {
			while(resultSet.next()) {
				
				HashMap<String, Object> recipe = new HashMap<String, Object>();
				
				RecipeVO recipeVO = new RecipeVO(
						resultSet.getInt("no"),
						resultSet.getString("id"),
						resultSet.getString("title"),
						resultSet.getString("thumbnail"),
						resultSet.getString("description"),
						resultSet.getString("contents"),
						resultSet.getInt("category"),
						resultSet.getInt("views"),
						resultSet.getString("ingredient"),
						resultSet.getString("ingredient_amount"),
						resultSet.getString("orders"),
						resultSet.getTimestamp("post_date"));
				
				float averageRating = resultSet.getFloat("average_rating");
				
				recipe.put("recipeVO", recipeVO);
				recipe.put("averageRating", averageRating);
				
				recipes.add(recipe);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return recipes;
	}

	public ArrayList<HashMap<String, Object>> selectSearchedRecipeList(String category, String key, String word) {
		
		ArrayList<HashMap<String, Object>> recipes = new ArrayList<HashMap<String,Object>>(); 
		
		String sql = "SELECT "
				+ "r.*, "
				+ "COALESCE(avg_rating.average_rating, 0) AS average_rating, "
				+ "COALESCE(avg_rating.review_count, 0) AS review_count, "
				+ "m.nickname AS nickname "
				+ "FROM recipe r "
				+ "LEFT JOIN ( "
				+ "SELECT recipe_no, AVG(rating) AS average_rating, COUNT(recipe_no) AS review_count "
				+ "FROM recipe_review "
				+ "GROUP BY recipe_no "
				+ ") avg_rating ON r.no = avg_rating.recipe_no "
				+ "LEFT JOIN member m ON r.id=m.id ";
		
		sql += (key.equals("recipe")) ? "WHERE r.title LIKE ? " : "WHERE nickname LIKE ? ";
		if (!category.equals("0")) sql += "AND category=? ";
		sql += "ORDER BY r.post_date DESC";
		
		word = "%" + word + "%";
		
		ResultSet resultSet = (category.equals("0")) ?
				dbConnector.executeQuery(sql, word) :
				dbConnector.executeQuery(sql, word, category);
		try {
			while (resultSet.next()) {
				
				RecipeVO recipe = new RecipeVO(
						resultSet.getInt("no"),
						resultSet.getString("id"),
						resultSet.getString("title"),
						resultSet.getString("thumbnail"),
						resultSet.getString("description"),
						resultSet.getString("contents"),
						resultSet.getInt("category"),
						resultSet.getInt("views"),
						resultSet.getString("ingredient"),
						resultSet.getString("ingredient_amount"),
						resultSet.getString("orders"),
						resultSet.getTimestamp("post_date"));
				
				float avgReview = resultSet.getFloat("average_rating");
				int reviewCount = resultSet.getInt("review_count");
				String nickname = resultSet.getString("nickname");
				
				HashMap<String, Object> recipeHashMap = new HashMap<String, Object>();
				recipeHashMap.put("recipe", recipe);
				recipeHashMap.put("average", avgReview);
				recipeHashMap.put("reviewCount", reviewCount);
				recipeHashMap.put("nickname", nickname);
				
				recipes.add(recipeHashMap);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectRecipes() SQLException 발생");
		}
		
		dbConnector.release();
				
		return recipes;
	}
	
	public int deleteWishRecipe(String id, String recipeNo) {
	    String sql = "SELECT * FROM recipe_wishlist WHERE id=? AND recipe_no=?";
	    
	    // 위시리스트에서 해당 레시피가 있는지 확인
	    ResultSet resultSet = dbConnector.executeQuery(sql, id, Integer.parseInt(recipeNo));

	    try {
	        // 레시피가 존재하지 않으면 삭제할 필요 없음
	        if (!resultSet.next()) {
	            return 0;  // 레시피가 위시리스트에 없으므로 삭제 실패
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return 0;  // 예외 발생 시 삭제 실패 처리
	    }
	    
	    // 레시피가 있으면 삭제 작업 수행
	    sql = "DELETE FROM recipe_wishlist WHERE id=? AND recipe_no=?";
	    
	    int result = dbConnector.executeUpdate(sql, id, recipeNo);
	    
	    dbConnector.release();
	    
	    return result;  // 삭제 성공 시 1 반환, 실패 시 0 반환
	}
}


