package Controllers;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import Common.NaverLoginAPI;
import Services.MemberService;
@WebServlet("/Member/*")
@MultipartConfig(location = "/tmp")
public class MemberController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private MemberService memberService;
    private String nextPage;

    private String header;

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

        String action = request.getPathInfo();
        System.out.println("action : " + action);      
      
        switch (action) {
            case "/join.me": openMemberJoinView(request, response); break;
            case "/joinPro.me": processMemberJoin(request, response); break; 
            case "/joinIdCheck.me": checkMemberId(request, response); return;                
            case "/naverlogin.me" : processNaverLogin(request, response); return;
            case "/kakaologin.me" : return;
            case "/login.me": openLoginView(request, response); break;
            case "/loginPro.me": processMemberLogin(request, response); break;
            
            case "/profileupdate.me": //정보수정 페이지 요청
        	   //center = memberService.profileupdate(request);
				//"members/profileupdate.jsp"
				
				//request객체에 "members/join.jsp" 중앙화면 뷰 주소 바인딩
				//request.setAttribute("center", center);
				
				nextPage = "/Main.jsp";
				 
				break;
				
				
            case "/viewprofile.me": //프로필 사진 요청
            //	center = memberService.view
            	break;
                
            case "/mypagemain.me":
                // 정보 수정 페이지 요청
                String center = memberService.profileupdate(request);
                request.setAttribute("center", center);
                nextPage = "/CarMain.jsp";
                break;

            case "/getUserProfile.me":
                // 사용자 프로필 정보 요청
            	NaverLoginAPI.handleNaverLogin(request, response);
                return;
                
            default:
                nextPage = "/main.jsp";
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
        dispatcher.forward(request, response);
    }
    
    private void openMemberJoinView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
    	
        request.setAttribute("center", "members/snsjoin.jsp");
        
        nextPage = "/main.jsp";
    }

    // 아이디 중복 체크 처리
    private void checkMemberId(HttpServletRequest request, HttpServletResponse response) 
    		throws ServletException, IOException  {
    	
        boolean result = memberService.checkMemberId(request);

        PrintWriter out = response.getWriter();
        
		out.write(result ? "not_usable" : "usable");
        
        out.close();
    }
    
    private void processNaverLogin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException  {

        // 네이버 인증 후 콜백 처리
        NaverLoginAPI.handleNaverLogin(request, response);
        
        // 네이버 로그인 후, 세션에 저장된 네이버 아이디를 가져옴
        String naverId = (String) request.getSession().getAttribute("naverId");
        
        // 네이버 아이디가 존재하면 추가 정보 입력 페이지로 리다이렉트
        if (naverId != null) {
            // 추가 정보 입력 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/Member/joinPom.me");
        } else {
            // 네이버 로그인 실패 시, 다시 네이버 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/Member/join.me");
        }
    }
    
    private void processKakaoLogin(HttpServletRequest request, HttpServletResponse response) 
    		throws ServletException, IOException {
    	
    	// 카카오 로그인 처리 이후 로직 작성
    }
    
    private void processMemberJoin(HttpServletRequest request, HttpServletResponse response)
    		throws ServletException, IOException {
    	
    	 // 회원 가입 처리
        memberService.insertMember(request);
        
        request.setAttribute("center", "join.jsp");
        
        // 회원 가입 처리
        memberService.insertMember(request);
        
        nextPage = "/main.jsp";
    }
    
    private void openLoginView(HttpServletRequest request, HttpServletResponse response)
    		throws ServletException, IOException {
    	
        request.setAttribute("center", "members/login.jsp");
        
        nextPage = "/login.jsp";
    }
    
    private void processMemberLogin(HttpServletRequest request, HttpServletResponse response)
    		throws ServletException, IOException {

        request.setAttribute("center", "includes/center.jsp");
        
        nextPage = "/login.jsp";
    }
}
