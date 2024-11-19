package Controllers;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import Common.NaverLoginAPI;
import DAOs.MemberDAO;
import Services.MemberService;
import VOs.MemberVO;
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
            case "/joinProGo.me": processMemberJoin(request, response); break; 
            case "/joinPro.me": processJoinMain(request,response); break;  				
            case "/joinIdCheck.me": checkMemberId(request, response); return;                
            case "/naverjoin.me": handleNaverJoin(request, response); return;
            case "/kakaojoin.me":handleKakaoJoin(request, response); return;	
            case "/getUserProfile.me":NaverLoginAPI.handleNaverLogin(request, response); return;          
            case "/login.me": openLoginView(request, response); break;
            case "/naverlogin.me": processNaverLogin(request, response); return;
            case "/kakaologin.me": processKakaoLogin(request, response); return;
            case "/loginProGo.me": processMemberLogin(request, response); break;
            case "/loginPro.me": nextPage = "/main.jsp"; break;
            case "/viewWishList.me": nextPage = handleWishlist(request); break;
            
            
            case "/profileupdate.me": //정보수정 페이지 요청
        	   //center = memberService.profileupdate(request);
				//"members/profileupdate.jsp"
				
				//request객체에 "members/join.jsp" 중앙화면 뷰 주소 바인딩
				//request.setAttribute("center", center);
				
				nextPage = "/main.jsp";
				 
				break;
				
				
            case "/viewprofile.me": //프로필 사진 요청
            //	center = memberService.view
            	break;
                
            case "/mypagemain.me":
                // 정보 수정 페이지 요청
                String center = memberService.profileupdate(request);
                request.setAttribute("center", "members/mypagemain.jsp");
                nextPage = "/main.jsp";
                break;

           
                
            case "/updatePro.me" : updateProfile(request, response); break; 

     
            
                
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
        dispatcher.forward(request, response);
    }
    


	private void processJoinMain(HttpServletRequest request, HttpServletResponse response) {
		//request객체에 "members/join.jsp" 중앙화면 뷰 주소 바인딩
		request.setAttribute("center", "members/join.jsp");		
		nextPage = "/main.jsp";
	}
	
	private void handleNaverJoin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
	    String naverId = processNaverJoin(request, response);
	    if (naverId != null) {
	        request.getSession().setAttribute("userId", naverId);
	        response.sendRedirect(request.getContextPath() + "/Member/joinPro.me");
	    }
	}
	
	private void handleKakaoJoin(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
	    String kakaoId = processKakaoJoin(request, response);
	    if (kakaoId != null) {
	        request.getSession().setAttribute("userId", kakaoId);
	        response.sendRedirect(request.getContextPath() + "/Member/joinPro.me");
	    }
	}

	private void updateProfile(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		
		String pwd = request.getParameter("pwd");
		String id =request.getParameter("id");

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
    
    private String processNaverJoin(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException  {

    	
    	
        // 네이버 인증 후 콜백 처리
        // 네이버 아이디가 존재하면 추가 정보 입력 페이지로 리다이렉트
        // 네이버 아이디를 DB에 저장
       String naverId  = memberService.insertNaverMember(request,response);
        
       

        // 네이버 아이디가 세션에 저장되지 않았거나 빈 값일 경우 처리
        if (naverId == null || naverId.trim().isEmpty()) {
            // 네이버 로그인 실패 시, 다시 네이버 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/Member/join.me");
            return null;
        }

       return naverId;

    }
    
    private String processKakaoJoin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("processKakaoJoin 호출됨");

        // 요청 파라미터에서 카카오 인가 코드 받아오기
        String code = request.getParameter("code");
        if (code == null || code.trim().isEmpty()) {
            System.out.println("인가 코드 없음");
            response.sendRedirect(request.getContextPath() + "/Member/join.me"); // 로그인 페이지로 리디렉트
            return null;
        }

        try {
            // 카카오 로그인 API를 통해 사용자 정보 가져오기
            String kakaoId = memberService.insertKakaoMember(code);

            if (kakaoId == null || kakaoId.trim().isEmpty()) {
                // 카카오 로그인 실패 시, 로그인 페이지로 리다이렉트
                response.sendRedirect(request.getContextPath() + "/Member/join.me");
                return null;
            }

            // 카카오 ID를 request에 담기 (세션이 아닌 request로 전달)
            request.setAttribute("userId", kakaoId);

            
            return kakaoId;  

        } catch (Exception e) {
            System.out.println("에러 발생: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp"); // 에러 페이지로 리디렉트
            return null;
        }
    }
    
    
 
    
    private void processMemberJoin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("processMemberJoin 호출됨");

        // 회원 가입 처리
        memberService.insertMember(request);

        // 리다이렉트 처리
        response.setCharacterEncoding("UTF-8");
        
        nextPage = "/main.jsp";
    }

    
    private void openLoginView(HttpServletRequest request, HttpServletResponse response)
    		throws ServletException, IOException {
    	
        request.setAttribute("center", "members/login.jsp");
        
        nextPage = "/main.jsp";
    }
    

    private void handleLogin(String userId, HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        try {
            if (userId != null) {
                // 사용자 ID로 DB 조회 (회원 존재 여부 확인)
                boolean isUserExists = memberService.isUserExists(userId);

                if (isUserExists) {
                    // 회원 존재 시 메인 페이지로 리다이렉트
                    System.out.println("회원 존재 확인: " + userId);
                    response.sendRedirect(request.getContextPath() + "/Member/loginPro.me"); // 메인 페이지로 리다이렉트
                    return; // 리다이렉트 후 더 이상 코드를 실행하지 않도록 return
                } else {
                    // 회원이 존재하지 않으면 회원가입 페이지로 이동
                    System.out.println("회원 존재하지 않음: " + userId);
                    response.setContentType("text/html; charset=UTF-8");
                    PrintWriter out = response.getWriter();
                    out.println("<script>");
                    out.println("alert('회원가입이 필요합니다. 회원가입 페이지로 이동합니다.');");
                    out.println("location.href='" + request.getContextPath() + "/Member/join.me';");
                    out.println("</script>");
                    out.close();
                    return; // 더 이상 코드를 실행하지 않도록 return
                }
            } else {
                // userId가 null이면 에러 처리
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "아이디를 가져오는 데 실패했습니다.");
            }
        } catch (Exception e) {
            // 예외 처리
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "로그인 처리 중 오류가 발생했습니다.");
        }
    }



    // 네이버 로그인 처리 메소드
    private void processNaverLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String userId = memberService.getNaverId(request, response); // 네이버 ID 가져오기
            handleLogin(userId, request, response); // 공통 로직 호출
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "네이버 로그인 중 오류가 발생했습니다.");
        }
    }

    // 카카오 로그인 처리 메소드
    private void processKakaoLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String code = request.getParameter("code"); // 카카오 인증 후 전달된 코드
            String userId = memberService.getKakaoId(code); // 카카오 ID 가져오기
            handleLogin(userId, request, response); // 공통 로직 호출
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "카카오 로그인 중 오류가 발생했습니다.");
        }
    }
    
    // 요청에 따라 메소드 호출
    private void processMemberLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI(); // 요청된 URI

        if (uri.endsWith("/naverlogin.me")) {
            processNaverLogin(request, response); // 네이버 로그인 처리
        } else if (uri.endsWith("/kakaologin.me")) {
            processKakaoLogin(request, response); // 카카오 로그인 처리
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "잘못된 요청입니다.");
        }
    }
    
    private String handleWishlist(HttpServletRequest request) {
        request.setAttribute("center", "members/wishlist.jsp");
        return "/main.jsp";
    }
    
    
    
    
    
    
    
    }
    
   
