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
	
	public ArrayList<HashMap<String, Object>> selectRecipesWithRating() {
		
		ArrayList<HashMap<String, Object>> recipes = new ArrayList<HashMap<String,Object>>();
		
		String sql = "SELECT "
				+ "r.*, "
				+ "COALESCE(avg_rating.average_rating, 0) AS average_rating "
				+ "FROM "
				+ "recipe r "
				+ "LEFT JOIN ( "
				+ "SELECT "
				+ "recipe_no, "
				+ "AVG(rating) AS average_rating "
				+ "FROM "
				+ "recipe_review "
				+ "GROUP BY "
				+ "recipe_no "
				+ ") avg_rating ON r.no = avg_rating.recipe_no";
		
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
						resultSet.getInt("empathy"),
						resultSet.getTimestamp("post_date"));
				
				double avgReview = resultSet.getDouble("average_rating");
				
				HashMap<String, Object> recipeWithAvg = new HashMap<String, Object>();
				recipeWithAvg.put("recipe", recipe);
				recipeWithAvg.put("average", avgReview);
				
				recipes.add(recipeWithAvg);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectRecipes() SQLException 발생");
		}
		
		dbConnector.Release();
		
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
						resultSet.getInt("empathy"),
						resultSet.getTimestamp("post_date"));
				
				recipes.add(recipe);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectRecipes() SQLException 발생");
		}
				
		dbConnector.Release();
		
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
						resultSet.getInt("empathy"),
						resultSet.getTimestamp("post_date"));
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectRecipe() SQLException 발생");
		}		
		
		dbConnector.Release();
		
		return recipe;
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
				+ "ingredient, ingredient_amount, orders, empathy, post_date) "
				+ "values(?, ?, ?, ?, ?, ?, 0, ?, ?, ?, 0, CURRENT_TIMESTAMP)";
		
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
				result = resultSet.getInt(1);
			}
		} 
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectInsertedRecipeNo() SQLException 발생");
		}
		
		dbConnector.Release();
		
		return result;
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
		
		dbConnector.Release();

		int result = 0;
		
		sql = "INSERT INTO recipe_wishlist(id, recipe_no) values(?, ?)";
		
		result = dbConnector.executeUpdate(sql, id, recipeNo);
		
		dbConnector.Release();
		
		return result;
	}
	
	public ArrayList<RecipeReviewVO> selectRecipeReviewes(String recipeNo) {
		
		ArrayList<RecipeReviewVO> reviewes = new ArrayList<RecipeReviewVO>();
		
		String sql = "SELECT * FROM recipe_review WHERE recipe_no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, recipeNo);
		
		try {
			while (resultSet.next()) {
				RecipeReviewVO review = new RecipeReviewVO(
						resultSet.getInt("no"),
						resultSet.getString("id"),
						resultSet.getInt("recipe_no"),
						resultSet.getString("pictures"),
						resultSet.getString("contents"),
						resultSet.getInt("rating"),
						resultSet.getInt("empathy"),
						resultSet.getTimestamp("post_date"));
				
				reviewes.add(review);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectRecipeReviewes() SQLException 발생");
		}
		
		return reviewes;
	}
} 





































