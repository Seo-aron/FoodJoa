package Services;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

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
	
	public RecipeVO getRecipe(HttpServletRequest request) {
		
		String no = request.getParameter("no");
		
		return recipeDAO.selectRecipe(no);
	}
}
