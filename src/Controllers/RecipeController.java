package Controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Services.RecipeService;
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
		case "/list": openRecipeView(request, response); break;

		default:
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
	}
	
	private void openRecipeView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		ArrayList<RecipeVO> recipes = recipeService.getRecipesList();
		
		for(RecipeVO recipe : recipes) {
			
			System.out.println(recipe.getNo());
		}
		
		request.setAttribute("center", "recipes/list.jsp");
		
		nextPage = "/main.jsp";
	}
}
