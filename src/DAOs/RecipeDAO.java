package DAOs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import Common.DBConnector;
import VOs.RecipeReviewVO;
import VOs.RecipeVO;

public class RecipeDAO {

	private DBConnector dbConnector;
	
	public RecipeDAO() {
		dbConnector = new DBConnector();
	}
	
	public ArrayList<HashMap<String, Object>> selectRecipesWithRating(String category) {
		
		int _category = Integer.parseInt(category);
		
		ArrayList<HashMap<String, Object>> recipes = new ArrayList<HashMap<String,Object>>();
		
		String sql = "SELECT "
				+ "r.*, COALESCE(avg_rating.average_rating, 0) AS average_rating, m.nickname AS nickname "
				+ "FROM recipe r "
				+ "LEFT JOIN ( "
				+ "SELECT "
				+ "recipe_no, AVG(rating) AS average_rating "
				+ "FROM recipe_review "
				+ "GROUP BY recipe_no "
				+ ") avg_rating ON r.no = avg_rating.recipe_no "
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
				
				double avgReview = resultSet.getDouble("average_rating");
				String nickname = resultSet.getString("nickname");
				
				HashMap<String, Object> recipeHashMap = new HashMap<String, Object>();
				recipeHashMap.put("recipe", recipe);
				recipeHashMap.put("average", avgReview);
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
	
	public ArrayList<RecipeVO> selectRecipes() {
		
		ArrayList<RecipeVO> recipes = new ArrayList<RecipeVO>();
		
		String sql = "SELECT * FROM recipe";
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
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
				
				recipes.add(recipe);
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
	
	public HashMap<String, Object> selectRecipeInfo(String no) {
		
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
		
		ArrayList<RecipeReviewVO> reviews = selectRecipeReviews(no);

		recipeHashMap.put("reviews", reviews);
		
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
		
		sql = "INSERT INTO recipe_wishlist(id, recipe_no) values(?, ?)";
		
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
	
	public ArrayList<RecipeReviewVO> selectRecipeReviews(String recipeNo) {
		
		ArrayList<RecipeReviewVO> reviews = new ArrayList<RecipeReviewVO>();
		
		String sql = "SELECT * FROM recipe_review WHERE recipe_no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, Integer.parseInt(recipeNo));
		
		try {
			while (resultSet.next()) {
				
				RecipeReviewVO review = new RecipeReviewVO(
						resultSet.getInt("no"),
						resultSet.getString("id"),
						resultSet.getInt("recipe_no"),
						resultSet.getString("pictures"),
						resultSet.getString("contents"),
						resultSet.getInt("rating"),
						resultSet.getTimestamp("post_date"));
				
				reviews.add(review);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectRecipeReviewes() SQLException 발생");
		}
		
		dbConnector.release();
		
		return reviews;
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
} 





































