package DAOs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import Common.DBConnector;
import VOs.RecipeVO;

public class RecipeDAO {

	private DBConnector dbConnector;
	
	public RecipeDAO() {
		dbConnector = new DBConnector();
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
						resultSet.getFloat("rating"),
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

	public RecipeVO selectRecipe(String id) {
		
		String sql = "SELECT * FROM recipe WHERE no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, Integer.parseInt(id));
		
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
						resultSet.getFloat("rating"),
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
				+ "contents, category, views, rating, "
				+ "ingredient, ingredient_amount, orders, empathy, post_date) "
				+ "values(?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, 0, CURRENT_TIMESTAMP)";
		
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
				+ "contents, category, views, rating, "
				+ "ingredient, ingredient_amount, orders, empathy, post_date) "
				+ "values(?, ?, ?, ?, ?, ?, 0, 0, ?, ?, ?, 0, CURRENT_TIMESTAMP)";
		
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
} 





































