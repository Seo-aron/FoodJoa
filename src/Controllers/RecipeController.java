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
		case "/update": openRecipeUpdateView(request, response); break;
		case "/updatePro": processRecipeUpdate(request, response); break;
		case "/deletePro": processRecipeDelete(request, response); break;
		case "/wishlist": processRecipeWishlist(request, response); return;
		case "/reviewWrite": if (openRecipeReviewView(request, response)) return; break;
		case "/reviewWritePro": processReviewWrite(request, response); return;
		case "/reviewUpdate": openRecipeReviewUpdateView(request, response); break;
		case "/reviewUpdatePro": processRecipeReviewUpdate(request, response); return;
		case "/reviewDeletePro": processRecipeReviewDelete(request, response); return;
		case "/search": processRecipeSearch(request, response); break;

		case "/myRecipes": openMyRecipeView(request, response); break;

		default:
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
	}

	private void openRecipeListView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String category = request.getParameter("category");

		ArrayList<HashMap<String, Object>> recipes = recipeService.getRecipesListWithAvgRating(category);

		request.setAttribute("recipes", recipes);
		request.setAttribute("category", category);
		request.setAttribute("currentPage", request.getParameter("currentPage"));
		request.setAttribute("currentBlock", request.getParameter("currentBlock"));

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

		HashMap<String, Object> recipeInfos = recipeService.getRecipeInfo(request);

		request.setAttribute("recipeInfos", recipeInfos);
		request.setAttribute("category", request.getParameter("category"));
		request.setAttribute("currentPage", request.getParameter("currentPage"));
		request.setAttribute("currentBlock", request.getParameter("currentBlock"));

		request.setAttribute("pageTitle", ((RecipeVO) recipeInfos.get("recipe")).getTitle());
		request.setAttribute("center", "recipes/read.jsp");

		nextPage = "/main.jsp";
	}

	private void processRecipeWrite(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int recipeNo = recipeService.processRecipeWrite(request);

		nextPage = "/Recipe/read?no=" + recipeNo;
	}

	private void openRecipeUpdateView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		RecipeVO recipe = recipeService.getRecipe(request);

		request.setAttribute("recipe", recipe);
		request.setAttribute("pageTitle", "게시글 수정하기");
		request.setAttribute("center", "recipes/update.jsp");

		nextPage = "/main.jsp";
	}

	private void processRecipeUpdate(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int recipeNo = recipeService.processRecipeUpdate(request);

		nextPage = "/Recipe/read?no=" + recipeNo;
	}

	private void processRecipeDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int result = recipeService.processRecipeDelete(request);

		nextPage = "/Recipe/list?category=0";
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
			printWriter.print("history.go(-1);");
			printWriter.print("</script>");

			printWriter.close();
			printWriter = null;
		}
		else {
			RecipeVO recipe = recipeService.getRecipe(request.getParameter("recipe_no"));

			request.setAttribute("recipe", recipe);
			request.setAttribute("pageTitle", "리뷰 작성 - " + recipe.getTitle());
			request.setAttribute("center", "recipes/review.jsp");

			nextPage = "/main.jsp";
		}

		return result;
	}

	private void processReviewWrite(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int result = recipeService.processReviewWrite(request);
		
		printWriter = response.getWriter();

		printWriter.print(result);

		printWriter.close();
		printWriter = null;
	}
	
	private void openRecipeReviewUpdateView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HashMap<String, Object> review = recipeService.getRecipeReview(request);

		request.setAttribute("review", review);
		request.setAttribute("pageTitle", "내 리뷰 수정");
		request.setAttribute("center", "recipes/reviewUpdate.jsp");

		nextPage = "/main.jsp";
	}
	
	private void processRecipeReviewUpdate(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		int result = recipeService.processReviewUpdate(request);

		printWriter = response.getWriter();

		printWriter.print(result);

		printWriter.close();
		printWriter = null;
	}
	
	private void processRecipeReviewDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		int result = recipeService.processReviewDelete(request);

		printWriter = response.getWriter();

		printWriter.print(result);

		printWriter.close();
		printWriter = null;
	}

	private void openMyRecipeView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		ArrayList<HashMap<String, Object>> recipes = recipeService.getRecipesListById(request);

		request.setAttribute("recipes", recipes);
		request.setAttribute("pageTitle", "나의 레시피");
		request.setAttribute("center", "recipes/myrecipes.jsp");

		nextPage = "/main.jsp";
	}

	private void processRecipeSearch(HttpServletRequest request, HttpServletResponse response) {

		ArrayList<HashMap<String, Object>> recipes = recipeService.getSearchedRecipeList(request);

		request.setAttribute("recipes", recipes);
		request.setAttribute("category", request.getParameter("category"));

		request.setAttribute("pageTitle", "나만의 레시피");
		request.setAttribute("center", "recipes/list.jsp");

		nextPage = "/main.jsp";
	}
}
