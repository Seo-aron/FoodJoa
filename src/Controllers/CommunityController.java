package Controllers;

import java.io.IOException;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Services.CommunityService;
import VOs.CommunityVO;

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

		String action = request.getPathInfo();
		System.out.println("action : " + action);
		
		ArrayList list = null;
		CommunityVO vo = null;
		
		switch (action) {
			case "/list.jsp": openCommunityList(request,response);
			
				HttpSession session = request.getSession();
				String loginid = (String)session.getAttribute("id");
			
				list = communityService.getCommunityList();
				
				// String nowPage = request.getParameter("nowPage");
				// String nowBlock = request.getParameter("nowBlock");

				request.setAttribute("list", list);
				request.setAttribute("center", "communities/list.jsp");
				
				nextPage = "/main.jsp";
				
				break;
				
			case "/write.jsp":	
				
			default:
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
		
	}

	private void openCommunityList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		
		
	}

}
