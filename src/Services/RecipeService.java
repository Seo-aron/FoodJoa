package Services;

import java.io.File;
import java.io.IOException;
import java.nio.file.FileSystems;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import Common.FileIOController;
import Common.StringParser;
import DAOs.RecipeDAO;
import VOs.RecipeReviewVO;
import VOs.RecipeVO;

public class RecipeService {

	private RecipeDAO recipeDAO;
	
	public RecipeService() {
		
		recipeDAO = new RecipeDAO();
	}
	
	public ArrayList<HashMap<String, Object>> getRecipesListWithAvgRating(String category) {
		
		return recipeDAO.selectRecipesWithAvgRating(category);
	}
  
	public ArrayList<HashMap<String, Object>> getRecipesListById(HttpServletRequest request) {
		
		return recipeDAO.selectRecipesById((String) request.getSession().getAttribute("userId"));
	}
	
	public RecipeVO getRecipe(HttpServletRequest request) {
		
		String no = request.getParameter("no");
		
		return recipeDAO.selectRecipe(no);
	}
	
	public RecipeVO getRecipe(int no) { return recipeDAO.selectRecipe(String.valueOf(no)); }
	public RecipeVO getRecipe(String no) { return recipeDAO.selectRecipe(no); }
	
	public HashMap<String, Object> getRecipeInfo(HttpServletRequest request) {
		
		return recipeDAO.selectRecipeInfo(
				request.getParameter("no"),
				(String) request.getSession().getAttribute("userId"));
	}
	
	public int processRecipeWrite(HttpServletRequest request) throws ServletException, IOException {
		
		ServletContext application = request.getServletContext();

		String path = application.getRealPath(File.separator + "images");
		int maxSize = 1024 * 1024 * 1024;

		MultipartRequest multipartRequest = new MultipartRequest(request, path + File.separator + "temp", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());
		
		String fileName = multipartRequest.getOriginalFileName("file");
		
		HttpSession session = request.getSession();
		String id = (String) session.getAttribute("userId");
		
		System.out.println("id : " + id);
		
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
		
		String srcPath = path + File.separator + "temp";
		String destinationPath = path + File.separator + "recipe" + File.separator +
				"thumbnails" + File.separator + String.valueOf(recipeNo);
		
		FileIOController.moveFile(srcPath, destinationPath, fileName);
		
		return recipeNo;
	}
	
	public int processRecipeUpdate(HttpServletRequest request) throws ServletException, IOException  {

		ServletContext application = request.getServletContext();

		String path = application.getRealPath(File.separator + "images");
		int maxSize = 1024 * 1024 * 1024;

		MultipartRequest multipartRequest = new MultipartRequest(request, path + File.separator + "temp", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());
		
		String originFileName = multipartRequest.getParameter("thumbnail-origin");
		String fileName = multipartRequest.getOriginalFileName("file");
		
		HttpSession session = request.getSession();
		String id = (String) session.getAttribute("userId");
		
		int recipeNo = Integer.parseInt(multipartRequest.getParameter("no"));
		
		RecipeVO recipe = new RecipeVO();
		recipe.setNo(recipeNo);
		recipe.setId(id);
		recipe.setTitle(multipartRequest.getParameter("title"));
		recipe.setThumbnail((fileName == null || fileName.equals("")) ? originFileName : fileName);
		recipe.setDescription(multipartRequest.getParameter("description"));
		recipe.setContents(multipartRequest.getParameter("contents"));
		recipe.setCategory(Integer.parseInt(multipartRequest.getParameter("category")));
		recipe.setViews(Integer.parseInt(multipartRequest.getParameter("views")));
		recipe.setIngredient(multipartRequest.getParameter("ingredient"));
		recipe.setIngredientAmount(multipartRequest.getParameter("ingredient_amount"));
		recipe.setOrders(multipartRequest.getParameter("orders"));
		
		int result = recipeDAO.updateRecipe(recipe);
		
		if (fileName != null && !fileName.equals("")) {
			String srcPath = path + File.separator + "temp";
			String destinationPath = path + File.separator + "recipe" + File.separator + "thumbnails" +
					File.separator + String.valueOf(recipeNo);
			
			FileIOController.deleteFile(destinationPath, originFileName);
			FileIOController.moveFile(srcPath, destinationPath, fileName);	
		}
		
		return recipeNo;
	}
	
	public int processRecipeDelete(HttpServletRequest request) {

		String id = (String) request.getSession().getAttribute("userId");
		String no = request.getParameter("no");
		
		int result = recipeDAO.deleteRecipe(id, no);
		
		if (result == 1) {
			String path = request.getServletContext().getRealPath(File.separator + "images") +
					File.separator + "recipe" + File.separator + "thumbnails" + File.separator + no;
			FileIOController.deleteDirectory(path);
		}
		
		return result;
	}
	
	public int processRecipeWishlist(HttpServletRequest request) {
		
		return recipeDAO.insertRecipeWishlist(
				request.getParameter("id"),
				request.getParameter("recipeNo"));
	}
	
	public double getRecipeRatingAvg(String recipeNo) { return recipeDAO.selectRecipeRatingAvg(Integer.parseInt(recipeNo)); }
	public double getRecipeRatingAvg(int recipeNo) { return recipeDAO.selectRecipeRatingAvg(recipeNo); }
	
	public boolean checkRecipeReview(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		String id = (String) session.getAttribute("userId");
	
		return recipeDAO.isExistRecipeReview(id, request.getParameter("recipe_no"));
	}
	
	public int processReviewWrite(HttpServletRequest request) throws ServletException, IOException {

		String id = (String) request.getSession().getAttribute("userId");
		
		ServletContext application = request.getServletContext();

		String path = application.getRealPath(File.separator + "images");
		int maxSize = 1024 * 1024 * 1024;

		MultipartRequest multipartRequest = new MultipartRequest(request, path + File.separator + "temp", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());

		String recipeNo = multipartRequest.getParameter("recipe_no");
        String pictures = multipartRequest.getParameter("pictures");
        String contents = multipartRequest.getParameter("contents");
        String rating = multipartRequest.getParameter("rating");
        
        List<String> fileNames = StringParser.splitString(pictures);

		String srcPath = path + File.separator + "temp";
		String destinationPath = path + File.separator + "recipe" + File.separator +
				"reviews" + File.separator + String.valueOf(recipeNo) + File.separator + id;
		
        for (String fileName : fileNames) {
    		FileIOController.moveFile(srcPath, destinationPath, fileName);
        }
        
        RecipeReviewVO review = new RecipeReviewVO();
        review.setId(id);
        review.setRecipeNo(Integer.parseInt(recipeNo));
        review.setPictures(pictures);
        review.setContents(contents);
        review.setRating(Integer.parseInt(rating));
        
		return recipeDAO.insertRecipeReivew(review);
	}

	public ArrayList<HashMap<String, Object>> getSearchedRecipeList(HttpServletRequest request) {
		
		return recipeDAO.selectSearchedRecipeList(
				request.getParameter("category"),
				request.getParameter("key"),
				request.getParameter("word"));
	}
	
	public HashMap<String, Object> getRecipeReview(HttpServletRequest request) {
		return recipeDAO.selectRecipeReview((String) request.getParameter("no"));
	}
	
	public int processReviewUpdate(HttpServletRequest request) throws ServletException, IOException {

		String id = (String) request.getSession().getAttribute("userId");
		
		ServletContext application = request.getServletContext();

		String path = application.getRealPath(File.separator + "images");
		int maxSize = 1024 * 1024 * 1024;

		MultipartRequest multipartRequest = new MultipartRequest(request, path + File.separator + "temp", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());

		String recipeNo = multipartRequest.getParameter("recipe_no");
		String originPictures = multipartRequest.getParameter("origin_pictures");
		String originSelectedPictures = multipartRequest.getParameter("origin_selected_pictures");
        String pictures = multipartRequest.getParameter("pictures");
		
		RecipeReviewVO review = new RecipeReviewVO(
				Integer.parseInt(multipartRequest.getParameter("no")),
				id,
				Integer.parseInt(recipeNo),
				originSelectedPictures + pictures,
				multipartRequest.getParameter("contents"),
				Integer.parseInt(multipartRequest.getParameter("rating"))
				);
		
		int result = recipeDAO.updateRecipeReview(review);
		
		if (result == 1) {
			String srcPath = path + File.separator + "temp";
			String destinationPath = path + File.separator + "recipe" + File.separator +
					"reviews" + File.separator + String.valueOf(recipeNo) + File.separator + id;
			
			List<String> originFileNames = StringParser.splitString(originPictures);
			List<String> originSelectedFileNames = StringParser.splitString(originSelectedPictures);
			
			for (String fileName : originFileNames) {
				if (!originSelectedFileNames.contains(fileName)) {
					FileIOController.deleteFile(destinationPath, fileName);
				}
			}
			
			List<String> fileNames = StringParser.splitString(pictures);
	
	        for (String fileName : fileNames) {
	    		FileIOController.moveFile(srcPath, destinationPath, fileName);
	        }
		}
		
		return result;
	}
	
	public int processReviewDelete(HttpServletRequest request) {
		
		int result = 0;
		
		result = recipeDAO.deleteRecipeReview(
				request.getParameter("no"),
				(String) request.getSession().getAttribute("userId"));
		
		if (result == 1) {
			String path = request.getServletContext().getRealPath(File.separator + "images");			
			String destinationPath = path + File.separator + "recipe" + File.separator +
					"reviews" + File.separator + String.valueOf(recipeNo) + File.separator + id;
		}
		
		return result;
	}
}