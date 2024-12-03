package Controllers;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/Main/*")
public class MainController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private String nextPage;

	public void init(ServletConfig config) throws ServletException {
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

		System.out.println("Request URI: " + request.getRequestURI());
		System.out.println("Context Path: " + request.getContextPath());
		System.out.println("Servlet Path: " + request.getServletPath());
		System.out.println("Path Info: " + request.getPathInfo());
		
		String action = request.getPathInfo();
		System.out.println("action : " + action);

		switch (action) {
		case "/home": openMainCenterView(request, response); break;

		default:
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
	}

	public void openMainCenterView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setAttribute("pageTitle", "세상의 모든 레시피 - Food Joa");
		request.setAttribute("center", "includes/center.jsp");

		nextPage = "/main.jsp";
	}
}
