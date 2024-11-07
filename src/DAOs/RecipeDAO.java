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

} 