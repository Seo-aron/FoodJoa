package Controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Services.MealkitService;
import VOs.MealkitVO;
import VOs.RecipeVO;

@WebServlet("/Mealkit/*")
public class MealkitController extends HttpServlet{
	
	private MealkitService mealkitService;
	private PrintWriter printWriter;
	private String nextPage;
	
	@Override
	public void init() throws ServletException {
		mealkitService = new MealkitService();
	}
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		doHandle(request, response);
	}
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		doHandle(request, response);
	}
	
	protected void doHandle(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");
		
		String action = request.getPathInfo();
		
		switch(action) {
			case "/list": openMealkitView(request, response); break;
			case "/info": openMealkitInfoView(request, response); break;
				
			default: break;
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
	}
	
	private void openMealkitInfoView(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException{

		MealkitVO mealkitvo = mealkitService.getMealkitInfo(request);
		
		request.setAttribute("mealkitvo", mealkitvo);
		request.setAttribute("center", "mealkits/info.jsp");
		
		nextPage = "/main.jsp";
	}
	private void openMealkitView(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException{
		
		ArrayList<MealkitVO> mealkits = mealkitService.getMealkitsList();
		
		request.setAttribute("mealkitList", mealkits);
		request.setAttribute("center", "mealkits/list.jsp");
		
		nextPage = "/main.jsp";
	}
}
