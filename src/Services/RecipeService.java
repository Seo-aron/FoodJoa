package Services;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import Common.StringParser;
import DAOs.RecipeDAO;
import VOs.RecipeVO;

public class RecipeService {

	private RecipeDAO recipeDAO;
	
	public RecipeService() {
		
		recipeDAO = new RecipeDAO();
	}
	
	private synchronized void moveProfile(String path, String no, String fileName) throws IOException {
		
	    if (fileName == null || fileName.isEmpty()) return;

	    synchronized (this) {
	        File srcFile = new File(path + "\\temp\\" + fileName);
	        File destDir = new File(path + "\\recipe\\thumbnails\\" + no);

	        if (!destDir.exists()) {
	            destDir.mkdirs();
	        }

	        File destFile = new File(destDir, fileName);
	        if (destFile.exists()) {
	            System.out.println("File already exists: " + destFile.getAbsolutePath());
	        } 
	        else {
	            FileUtils.moveToDirectory(srcFile, destDir, true);
	        }
	    }
	}
  
	public ArrayList<RecipeVO> getRecipesList() {
		
		return recipeDAO.selectRecipes();
	}
	
	public RecipeVO getRecipe(HttpServletRequest request) {
		
		String no = request.getParameter("no");
		
		return recipeDAO.selectRecipe(no);
	}
	
	public RecipeVO getRecipe(int no) {
		
		return recipeDAO.selectRecipe(String.valueOf(no));
	}
	
	public int processRecipeWrite(HttpServletRequest request) throws ServletException, IOException {
		
		ServletContext application = request.getServletContext();
		
		String path = application.getRealPath("/images/");
		int maxSize = 1024 * 1024 * 1024;
		
		MultipartRequest multipartRequest = new MultipartRequest(request, path + "temp/", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());
		
		String fileName = multipartRequest.getOriginalFileName("file");
		/* 로그인 완성 되면 구현
		HttpSession session = request.getSession();
		String id = session.getAttribute("id");
		*/
		String id = "admin";
		
		RecipeVO recipe = new RecipeVO();
		recipe.setId(id);
		recipe.setTitle(multipartRequest.getParameter("title"));
		recipe.setThumbnail(fileName);
		recipe.setDescription(multipartRequest.getParameter("description"));
		recipe.setContents(multipartRequest.getParameter("contents"));
		recipe.setCategory(Integer.parseInt(multipartRequest.getParameter("category")));
		recipe.setIngredient(multipartRequest.getParameter("ingredient"));
		recipe.setIngredientAmount(multipartRequest.getParameter("ingredient_amount"));
		recipe.setOrders(multipartRequest.getParameter("orders"));
		
		int recipeNo = recipeDAO.selectInsertedRecipeNo(recipe);
		
		System.out.println("result : " + recipeNo);
		
		moveProfile(path, String.valueOf(recipeNo), fileName);
		
		return recipeNo;
	}
}
