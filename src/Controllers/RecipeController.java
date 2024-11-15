package Controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Services.RecipeService;
import VOs.RecipeReviewVO;
import VOs.RecipeVO;

enum RecipeType {
	None, Korean, japanese, Chinese, Western, Homecooking, RecipeTypeEnd
}

@WebServlet("/Recipe/*")
public class RecipeController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private RecipeService recipeService;	
	private PrintWriter printWriter;
	private String nextPage;	

	public void init(ServletConfig config) throws ServletException {
		
		recipeService = new RecipeService();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doHandle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");
		
		HttpSession session = request.getSession();
		
		
		
		String action = request.getPathInfo();
		System.out.println("action : " + action);

		switch (action) {
		case "/list": openRecipeListView(request, response); break;
		case "/write": openRecipeWriteView(request, response); break;
		case "/read": openRecipeReadView(request, response); break;
		case "/writePro": processRecipeWrite(request, response); break;
		case "/wishlist": processRecipeWishlist(request, response); return;
		case "/review": if (openRecipeReviewView(request, response)) return ; break;
		case "/reviewWrite": processReviewWrite(request, response); return;

		default:
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
	}
	
	private void openRecipeListView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		ArrayList<HashMap<String, Object>> recipes = recipeService.getRecipesWithAvgList();
		
		request.setAttribute("recipes", recipes);
		request.setAttribute("pageTitle", "나만의 레시피");
		request.setAttribute("center", "recipes/list.jsp");
		
		nextPage = "/main.jsp";
	}
	
	private void openRecipeWriteView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setAttribute("pageTitle", "나만의 레시피 작성하기");
		request.setAttribute("center", "recipes/write.jsp");
		
		nextPage = "/main.jsp";
	}
	
	private void openRecipeReadView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		RecipeVO recipe = recipeService.getRecipe(request);
		String ratingAvg = request.getParameter("ratingAvg");

		request.setAttribute("recipe", recipe);
		request.setAttribute("pageTitle", recipe.getTitle());
		request.setAttribute("ratingAvg", ratingAvg);
		request.setAttribute("center", "recipes/read.jsp");
		
		nextPage = "/main.jsp";
	}
	
	private void processRecipeWrite(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int recipeNo = recipeService.processRecipeWrite(request);
		
		RecipeVO recipe = recipeService.getRecipe(recipeNo);
		ArrayList<RecipeReviewVO> reviews = recipeService.getRecipeReviewes(recipeNo);
		
		request.setAttribute("recipe", recipe);
		request.setAttribute("reviews", reviews);
		request.setAttribute("pageTitle", recipe.getTitle());
		request.setAttribute("center", "recipes/read.jsp");
		
		nextPage = "/main.jsp";
	}
	
	private void processRecipeWishlist(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		int result = recipeService.processRecipeWishlist(request);
		
		printWriter = response.getWriter();
		
		printWriter.print(result);
		
		printWriter.close();
		printWriter = null;
	}
	
	private boolean openRecipeReviewView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		boolean result = recipeService.checkRecipeReview(request);

		if (result) {
			printWriter = response.getWriter();
			
			printWriter.print("<script>");
			printWriter.print("alert('이미 리뷰를 작성 하셨습니다.');");
			printWriter.print("</script>");
			
			printWriter.close();
			printWriter = null;
		}
		else {
			RecipeVO recipe = recipeService.getRecipe(request.getParameter("recipe_no"));
			
			request.setAttribute("recipe", recipe);
			request.setAttribute("center", "recipes/review.jsp");
			
			nextPage = "/main.jsp";
		}
		
		return result;
	}
	
	private void processReviewWrite(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		recipeService.processReviewWrite(request);	
		
		openRecipeReadView(request, response);
	}
}
