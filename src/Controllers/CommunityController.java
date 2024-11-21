package Controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.eclipse.jdt.internal.compiler.ast.ThrowStatement;

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
		
		switch (action) {
			case "/list": openCommunityList(request,response);break;
			case "/write": openCommunityWriteView(request,response);break;
			case "/write.pro": processCommunityWrite(request,response);break;
			case "/read": openCommunityRead(request,response);break;
			case "/update": openCommunityUpdateView(request,response);break;
			case "/updatePro": processCommunityUpdate(request, response);return;
			case "/deletePro": processCommunityDelete(request, response);return;	
			
			default:
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
		
	}

	private void openCommunityList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		HttpSession session = request.getSession();
		String loginid = (String)session.getAttribute("id");
	
		ArrayList<CommunityVO> communities = communityService.getCommunityList();
		
		// String nowPage = request.getParameter("nowPage");
		// String nowBlock = request.getParameter("nowBlock");

		request.setAttribute("communities", communities);
		request.setAttribute("center", "communities/list.jsp");
		request.setAttribute("admin", loginid);
		
		nextPage = "/main.jsp";
		
	}

	private void openCommunityWriteView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
	
		request.setAttribute("center", "communities/write.jsp");
		
		nextPage = "/main.jsp";
	}
	
	private void processCommunityWrite(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{

		communityService.insertCommunity(request);
		
		nextPage = "/Community/list";
	}
	
	private void openCommunityRead(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		
		String no = request.getParameter("no");
		CommunityVO vo = communityService.openCommunityRead(no);

		request.setAttribute("vo", vo);
		request.setAttribute("center", "communities/read.jsp");
		
		nextPage = "/main.jsp";
		
	}
	
	private void openCommunityUpdateView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
	
		CommunityVO vo = new CommunityVO(
				Integer.parseInt(request.getParameter("no")),
				request.getParameter("id"),
				request.getParameter("title"),
				request.getParameter("contents"),
				Integer.parseInt(request.getParameter("views")));
		
		request.setAttribute("vo", vo);
		request.setAttribute("center", "communities/update.jsp");
		
		nextPage = "/main.jsp";
	}

	private void processCommunityUpdate(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		int result = communityService.updateCommunity(request);
		
		PrintWriter out = response.getWriter();
		
		out.print(result);
		
		out.close();
	}
	
	private void processCommunityDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		int result = communityService.deleteCommunity(request);
		
		PrintWriter out = response.getWriter();
		
		out.print(result == 1 ? "삭제 완료" : "삭제 실패");
		
		out.close();
		
	}	
}
