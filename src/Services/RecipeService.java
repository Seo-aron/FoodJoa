package Services;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import com.oreilly.servlet.multipart.Part;

import Common.StringParser;
import DAOs.RecipeDAO;
import VOs.RecipeReviewVO;
import VOs.RecipeVO;

public class RecipeService {

	private RecipeDAO recipeDAO;
	
	public RecipeService() {
		
		recipeDAO = new RecipeDAO();
	}
	
	private synchronized void moveProfile(String srcPath, String destinationPath, String fileName) throws IOException {
		
	    if (fileName == null || fileName.isEmpty()) return;

	    synchronized (this) {
	        File srcFile = new File(srcPath + "\\" + fileName);
	        File destDir = new File(destinationPath);

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
	
	public ArrayList<HashMap<String, Object>> getRecipesWithAvgList() {
		
		return recipeDAO.selectRecipesWithRating();
	}
  
	public ArrayList<RecipeVO> getRecipesList() {
		
		return recipeDAO.selectRecipes();
	}
	
	public RecipeVO getRecipe(HttpServletRequest request) {
		
		String no = request.getParameter("no");
		
		return recipeDAO.selectRecipe(no);
	}
	
	public RecipeVO getRecipe(int no) { return recipeDAO.selectRecipe(String.valueOf(no)); }
	public RecipeVO getRecipe(String no) { return recipeDAO.selectRecipe(no); }
	
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
		
		String srcPath = path + "\\temp\\";
		String destinationPath = path + "\\recipe\\thumbnails\\" + String.valueOf(recipeNo);
		
		moveProfile(srcPath, destinationPath, fileName);
		
		return recipeNo;
	}
	
	public int processRecipeWishlist(HttpServletRequest request) {
		
		return recipeDAO.insertRecipeWishlist(
				request.getParameter("id"),
				request.getParameter("recipeNo"));
	}
	
	public ArrayList<RecipeReviewVO> getRecipeReviewes(String recipeNo) {
		
		return getRecipeReviewes(Integer.parseInt(recipeNo));
	}
	
	public ArrayList<RecipeReviewVO> getRecipeReviewes(int recipeNo) {
		
		return recipeDAO.selectRecipeReviews(recipeNo);
	}
	
	public boolean checkRecipeReview(HttpServletRequest request) {
		
		/* 로그인 완성 되면 구현
			HttpSession session = request.getSession();
			String id = session.getAttribute("id");
		*/
		String id = "admin";
	
		return recipeDAO.isExistRecipeReview(id, request.getParameter("recipe_no"));
	}
	
	public int processReviewWrite(HttpServletRequest request) throws ServletException, IOException {
		
		String id = "admin";
		
		ServletContext application = request.getServletContext();
		
		String path = application.getRealPath("/images/");
		int maxSize = 1024 * 1024 * 1024;
		
		MultipartRequest multipartRequest = new MultipartRequest(request, path + "temp/", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());

		String recipeNo = multipartRequest.getParameter("recipe_no");
        String pictures = multipartRequest.getParameter("pictures");
        String contents = multipartRequest.getParameter("contents");
        String rating = multipartRequest.getParameter("rating");
        
        System.out.println("pictures : " + pictures);
        
        List<String> fileNames = StringParser.splitString(pictures);
        
        for(String fileName : fileNames) {
    		
    		String srcPath = path + "\\temp\\";
    		String destinationPath = path + "\\recipe\\reviews\\" + String.valueOf(recipeNo) + "\\" + id;
    		
    		moveProfile(srcPath, destinationPath, fileName);
        }
        
        RecipeReviewVO review = new RecipeReviewVO();
        review.setId(id);
        review.setRecipeNo(Integer.parseInt(recipeNo));
        review.setPictures(pictures);
        review.setContents(contents);
        review.setRating(Integer.parseInt(rating));
        
		return recipeDAO.insertRecipeReivew(review);
	}
}
