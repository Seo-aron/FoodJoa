package Services;

import java.util.ArrayList;

import DAOs.RecipeDAO;
import VOs.RecipeVO;

public class RecipeService {

	private RecipeDAO recipeDAO;
	
	public RecipeService() {
		
		recipeDAO = new RecipeDAO();
	}
	
	public ArrayList<RecipeVO> getRecipesList() {
		
		return recipeDAO.selectRecipes();
	}
}
