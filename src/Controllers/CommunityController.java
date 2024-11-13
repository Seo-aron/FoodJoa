package Controllers;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Services.CommunityService;

@WebServlet("/Community/*")
public class CommunityController extends HttpServlet {

	private CommunityService communityService;
	private String nextPage;
	private String printWriter;
	
	
	public void init(ServletConfig config) throws ServletException {
		
		communityService = new CommunityService();
		
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
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8");

		HttpSession session = request.getSession();
		
		String action = request.getPathInfo();
		System.out.println("action : " + action);
		
		switch (action) {
		case "/list": openCommunityList(request,response); break;

		
		default:
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
		
	}

	private void openCommunityList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		
		
	}

}
