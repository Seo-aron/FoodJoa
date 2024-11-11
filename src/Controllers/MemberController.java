package Controllers;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Services.MemberService;
import VOs.MemberVO;

@WebServlet("/Member/*")
@MultipartConfig(location = "/tmp") // 업로드 파일 저장 위치 설정 (로컬 디렉토리)
public class MemberController extends HttpServlet {

    private MemberService memberService;
    private String nextPage;

    @Override
    public void init() throws ServletException {
        memberService = new MemberService();
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

        String action = request.getPathInfo(); // 요청 경로 정보 가져오기
        String contextPath = request.getContextPath(); // contextPath 가져오기
        System.out.println("action : " + action);      
      
         //웹브라우저로 출력할 출력 스트림 생성
   		PrintWriter out = response.getWriter();
   	
   		
   		//조건에 따라서 포워딩 또는 보여줄 VIEW주소 경로를 저장할 변수
   		String nextPage = null;
   		
   		//요청한 중앙화면 뷰 주소를 저장할 변수
   		String center = null;

        switch (action) {
            case "/join.me":
                // 회원 가입 페이지 처리
                nextPage = memberService.serviceJoinName(request); // 회원 가입 처리 로직
                request.setAttribute("center", nextPage);
                nextPage = "/members/join.jsp"; // 경로 설정
                break;

            case "/joinIdCheck.me":
                // 아이디 중복 체크 처리
                handleIdCheck(request, response);
                return; // 이 경우에는 바로 리턴해서 다른 처리를 막는다.

            case "/joinPro.me":
                // 회원 가입 처리
                memberService.serviceInsertMember(request);
                nextPage = "/main.jsp"; // 가입 후 리다이렉트할 페이지
                break;

            case "/login.me":
                // 로그인 페이지 처리
                nextPage = memberService.serviceLoginMember(); // 로그인 서비스 처리
                request.setAttribute("center", nextPage);
                nextPage = "/members/login.jsp"; // 경로 설정
                break;

            case "/loginPro.me":
                // 로그인 처리
                handleLoginPro(request, response);
                return; // 로그인 처리 후 바로 리턴해서 다른 처리가 진행되지 않게 한다.
            
            case "/mypagemain.me": //정보수정 페이지 요청
        	   center = memberService.profileupdate(request);
				//"members/profileupdate.jsp"
				
				//request객체에 "members/join.jsp" 중앙화면 뷰 주소 바인딩
				request.setAttribute("center", center);
				
				nextPage = "/CarMain.jsp";
				
				break;

            default:
                // 잘못된 요청에 대한 기본 처리
                nextPage = "/main.jsp"; // 기본 페이지로 이동
        }

        // 페이지 포워딩
        if (nextPage != null) {
            RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
            dispatcher.forward(request, response);
        }
    }

    // 아이디 중복 체크를 위한 메소드
    private void handleIdCheck(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();
        boolean result = memberService.serviceOverLappedId(request);
        if (result) {
            out.write("not_usable");
        } else {
            out.write("usable");
        }
    }

    // 로그인 처리를 위한 메소드
    private void handleLoginPro(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();
        int check = memberService.serviceUserCheck(request);
        if (check == 0) {
            out.println("<script>");
            out.println(" window.alert('이름 틀림'); ");
            out.println(" history.go(-1);");
            out.println("</script>");
        } else if (check == -1) {
            out.println("<script>");
            out.println(" window.alert('아이디 틀림'); ");
            out.println(" history.go(-1);");
            out.println("</script>");
        } else {
            nextPage = "/main.jsp"; // 로그인 성공 후 이동할 페이지
        }
    }
}
