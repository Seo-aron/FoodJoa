package Services;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

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
	
	public boolean processRecipeWrite(HttpServletRequest request) throws ServletException, IOException {
		
		ServletContext application = request.getServletContext();
		
		String path = application.getRealPath("/images/");
		int maxSize = 1024 * 1024 * 1024;
		
		MultipartRequest multipartRequest = new MultipartRequest(request, path + "temp/", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());
		/*
		String id = multipartRequest.getParameter("id");
		String fileName = multipartRequest.getParameter("profile");
		*/
		System.out.println(multipartRequest.getFilesystemName("thumbnail"));
		System.out.println(multipartRequest.getParameter("title"));
		System.out.println(multipartRequest.getParameter("description"));
		System.out.println(multipartRequest.getParameter("contents").length());
		System.out.println(multipartRequest.getParameter("ingredient"));
		System.out.println(multipartRequest.getParameter("ingredient_amount"));
		System.out.println(multipartRequest.getParameter("orders"));
		
		return false;
	}
}
