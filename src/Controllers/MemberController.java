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
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import Common.NaverLoginAPI;
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
		case "/join.me":
			openMemberJoinView(request, response);
			break;
		case "/joinProGo.me":
			processMemberJoin(request, response);
			break;
		case "/joinPro.me":

			// request객체에 "members/join.jsp" 중앙화면 뷰 주소 바인딩
			request.setAttribute("center", "members/join.jsp");
			nextPage = "/main.jsp";
			break;
		case "/joinIdCheck.me":
			checkMemberId(request, response);
			return;
		case "/naverlogin.me":
			String naverId = processNaverLogin(request, response);
			if (naverId != null) {
				request.getSession().setAttribute("userId", naverId);
				// 추가 정보 입력 페이지로 리다이렉트
				response.sendRedirect(request.getContextPath() + "/Member/joinPro.me");
			}
			return;

		case "/kakaologin.me":
			processKakaoLogin(request, response);
			Object kakaoId = null;
			if (kakaoId != null) {
				request.getSession().setAttribute("userId", kakaoId);
				// 추가 정보 입력 페이지로 리다이렉트
				response.sendRedirect(request.getContextPath() + "/Member/joinPro.me");

			}
			return;

		case "/login.me":
			openLoginView(request, response);
			break;
		case "/loginPro.me":
			processMemberLogin(request, response);
			break;
		case "/mypagemain.me":
			
			// HttpSession session = request.getSession();
			// String id = (String) session.getAttribute("id");
			String id = "admin";
			
			request.setAttribute("center", "members/mypagemain.jsp");
			nextPage = "/main.jsp";
			break;

		case "/getUserProfile.me":
			NaverLoginAPI.handleNaverLogin(request, response);
			return;
		case "/update.me":
			openMemberUpdateView(request, response);
			break;
			
		case "/updatePro.me":
			processMemberUpdate(request, response);
			break;

		case "/wishlist.me":
			request.setAttribute("center", "members/wishlist.jsp");
			nextPage = "/main.jsp";
			break;

		default:
			nextPage = "/main.jsp";

		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
	}
	
	private void openMemberUpdateView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		MemberVO vo =  memberService.getMember(request);
		
		request.setAttribute("vo", vo);
		request.setAttribute("center", "members/profileupdate.jsp");
		
		nextPage = "/main.jsp";
	}

	private void processMemberUpdate(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int result = memberService.updateProfile(request);

		request.setAttribute("center", "members/mypagemain.jsp");
		nextPage = "/main.jsp";
	}

	private void openMemberJoinView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setAttribute("center", "members/snsjoin.jsp");
		nextPage = "/main.jsp";

	}

	// 아이디 중복 체크 처리
	private void checkMemberId(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		boolean result = memberService.checkMemberId(request);

		PrintWriter out = response.getWriter();

		out.write(result ? "not_usable" : "usable");

		out.close();
	}

	private String processNaverLogin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 네이버 인증 후 콜백 처리
		// 네이버 아이디가 존재하면 추가 정보 입력 페이지로 리다이렉트
		// 네이버 아이디를 DB에 저장
		String naverId = memberService.insertNaverMember(request, response);

		// 네이버 아이디가 세션에 저장되지 않았거나 빈 값일 경우 처리
		if (naverId == null || naverId.trim().isEmpty()) {
			// 네이버 로그인 실패 시, 다시 네이버 로그인 페이지로 리다이렉트
			response.sendRedirect(request.getContextPath() + "/Member/join.me");
			return null;
		}

		return naverId;

	}

	private void processKakaoLogin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 카카오 로그인 처리 이후 로직 작성

		String kakaoId = memberService.insertkakaoMember(request, response);

		// 카카오 아이디가 세션에 저장되지 않았거나 빈 값일 경우 처리
		if (kakaoId == null || kakaoId.trim().isEmpty()) {
			// 카카오 로그인 실패 시, 다시 로그인 페이지로 리다이렉트
			response.sendRedirect(request.getContextPath() + "/Member/join.me");
			return;
		}

		return;
	}

	private void processMemberJoin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("processMemberJoin 호출됨");

		// 회원 가입 처리
		memberService.insertMember(request);

		request.setAttribute("center", "includes/center.jsp");

		// 가입 후 메인 페이지로 리다이렉트
		response.sendRedirect(request.getContextPath() + "/main.jsp");
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
