package Controllers;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Services.MemberService;

//import Services.MemberService;

@WebServlet("/member/*")
public class MemberController extends HttpServlet {

	// private MemberService memberService;
	private String nextPage;

	public void init(ServletConfig config) throws ServletException {
		// memberService = new MemberService();
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
      
           request.setCharacterEncoding("utf-8");
           response.setContentType("text/html; charset=utf-8");
           
           String action = request.getPathInfo();
           System.out.println("action: " + action);
           
         //웹브라우저로 출력할 출력 스트림 생성
   		PrintWriter out = response.getWriter();
   	
   		
   		//조건에 따라서 포워딩 또는 보여줄 VIEW주소 경로를 저장할 변수
   		String nextPage = null;
   		
   		//요청한 중앙화면 뷰 주소를 저장할 변수
   		String center = null;
           
           
           
           //switch문 작성할곳
           switch(action) {
           
           case "/mypagemain.me": //정보수정 페이지 요청
        	   center = MemberService.profileupdate(request);
				//"members/profileupdate.jsp"
				
				//request객체에 "members/join.jsp" 중앙화면 뷰 주소 바인딩
				request.setAttribute("center", center);
				
				nextPage = "/CarMain.jsp";
				
				break;
           
           
           }
           
           
           
           
           
           
           
           
           // 포워드 방식으로 nextPage로 이동
           RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
           dispatcher.forward(request, response);
      
   }

}
