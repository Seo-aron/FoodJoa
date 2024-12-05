package Controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;


import Common.NaverLoginAPI;
import Services.MealkitService;
import Services.MemberService;
import VOs.MealkitVO;
import VOs.MemberVO;
import DAOs.MealkitDAO;


@WebServlet("/Member/*")
@MultipartConfig(location = "/tmp")
public class MemberController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private MemberService memberService;
	private MealkitService mealkitService;
	private String nextPage;

	@Override
	public void init() throws ServletException {
		memberService = new MemberService();
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

		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");

		String action = request.getPathInfo();
		System.out.println("action : " + action);

		switch (action) {
		case "/snsjoin.me": openMemberJoinView(request, response); break; // sns회원가입화면
		case "/joinPro.me": processMemberJoin(request, response); break; // 정보 다 받고 찐 가입완료
		case "/join.me": openJoinMain(request, response); break; // 추가정보화면
		case "/naverjoin.me": handleNaverJoin(request, response); return;
		case "/kakaojoin.me": handleKakaoJoin(request, response); return;
		case "/getUserProfile.me": NaverLoginAPI.handleNaverLogin(request, response); return;
		case "/login.me": openLoginView(request, response); break;
		case "/naverlogin.me": processNaverLogin(request, response); return;
		case "/kakaologin.me": processKakaoLogin(request, response); return;
		case "/loginPro.me": processMemberLogin(request, response); break;
		case "/logout.me": processMemberLogOut(request, response); return;
		case "/deleteMember.me": openDeleteMember(request, response); break;
		case "/deleteMemberPro.me": processDeleteMember(request, response); return;
		case "/wishList.me": openWishList(request, response); break;
		case "/deleteWishRecipe.me": deleteWishRecipe(request, response); return;
		case "/deleteWishMealkit.me": deleteWishMealkit(request, response); return;
		case "/recentList.me": if (!openRecentList(request, response)) return; break;
		case "/cartList.me": openCartList(request, response); break;
		case "/deleteCartList.me": deleteCartList(request, response); return;
		case "/updateCartList.me": updateCartList(request, response); return;
		case "/mypagemain.me": if (!openMypagemainView(request, response)) return; break; 
		case "/update.me": openMemberUpdateView(request, response); break;
		case "/updatePro.me": processMemberUpdate(request, response); break;
		case "/orderUpdate.me": processUpdateOrder(request, response); break;
		case "/viewMyDelivery.me": openMyDeliveryView(request, response); break;
		case "/viewMySend.me": openMySendView(request, response); break;
		case "/viewMyRecipe.me": openMyRecipeView(request, response); break;
		case "/viewImpormation.me": openImpormation(request, response); break;
		case "/myReviews": openMyReviewsView(request, response); break;
		case "/getOrder.me":processGetOrderedMealkitList(request,response); return;
		
//		case "/sendPayMent.me": sendPayMent(request, response); return;
//		case "/openPayMent.me": openPayMent(request, response); return;
//		case "/updateOrderList.me": updateOrderList(request, response); return;	
		
		case "/payment.me": openPaymentView(request,response); break;
		
		default:
			nextPage = "/main.jsp";
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
	}

	private void processUpdateOrder(HttpServletRequest request, HttpServletResponse response) {
		 int orderNo = Integer.parseInt(request.getParameter("orderNo"));
		    int deliveredStatus = Integer.parseInt(request.getParameter("deliveredStatus"));
		    int refundStatus = Integer.parseInt(request.getParameter("refundStatus"));

		    int result = memberService.updateOrder(orderNo, deliveredStatus, refundStatus);

		    try {
		        response.setContentType("application/json; charset=UTF-8");
		        PrintWriter out = response.getWriter();

		        if (result > 0) {
		            out.print("{\"status\":\"success\"}");
		        } else {
		            out.print("{\"status\":\"fail\"}");
		        }
		        out.close();
		    } catch (Exception e) {
		        e.printStackTrace();
		    } 
		    
			
	}

	private void openImpormation(HttpServletRequest request, HttpServletResponse response) {
		request.setAttribute("center", "members/impormation.jsp");
		nextPage = "/main.jsp";
	}

	private void openMemberJoinView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setAttribute("center", "members/snsjoin.jsp");
		nextPage = "/main.jsp";
	}

	private void processMemberJoin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("processMemberJoin 호출됨");

		// 회원 가입 처리
		// 사용자가 입력한 추가 정보를 처리해서 DB에 저장
		if (memberService.insertMember(request)) {
			// 네이버나 카카오 로그인 후 받은 아이디를 세션에서 가져옴
			HttpSession session = request.getSession(true); // 세션이 없으면 새로 생성
			String userId = (String) session.getAttribute("userId"); // 네이버나 카카오에서 받은 아이디

			// 세션에 아이디가 없으면 예외 처리 (아이디가 없을 경우 탈퇴나 다른 처리 불가)
			if (userId == null) {
				throw new ServletException("로그인 정보가 없습니다. 로그인 후 다시 시도해주세요.");
			}

			// 회원 가입 후 아이디를 세션에 저장
			session.setAttribute("userId", userId); // 로그인한 사용자의 아이디를 세션에 저장
		}

		nextPage = "/Main/home";
	}

	private void openJoinMain(HttpServletRequest request, HttpServletResponse response) {
		// request객체에 "members/join.jsp" 중앙화면 뷰 주소 바인딩
		request.setAttribute("center", "members/join.jsp");
		request.setAttribute("userId", request.getParameter("userId"));

		nextPage = "/main.jsp";
	}

	private void handleNaverJoin(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		String naverId = processNaverJoin(request, response);
		if (naverId != null) {
			request.getSession().setAttribute("userId", naverId);
			response.sendRedirect(request.getContextPath() + "/Member/join.me");
		}
	}

	private String processNaverJoin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 네이버 인증 후 콜백 처리
		// 네이버 아이디가 존재하면 추가 정보 입력 페이지로 리다이렉트
		// 네이버 아이디를 DB에 저장
		String naverId = memberService.insertNaverMember(request, response);

		// 네이버 아이디가 세션에 저장되지 않았거나 빈 값일 경우 처리
		if (naverId == null || naverId.trim().isEmpty()) {
			// 네이버 로그인 실패 시, 다시 네이버 로그인 페이지로 리다이렉트
			response.sendRedirect(request.getContextPath() + "/Member/snsjoin.me");
			return null;
		}

		return naverId;
	}

	private void handleKakaoJoin(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		String kakaoId = processKakaoJoin(request, response);
		if (kakaoId != null) {
			request.getSession().setAttribute("userId", kakaoId);
			response.sendRedirect(request.getContextPath() + "/Member/join.me");
		}

		nextPage = "/main.jsp"; // 회원가입 후 메인 페이지로 이동
	}

	private String processKakaoJoin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		System.out.println("processKakaoJoin 호출됨");

		// 요청 파라미터에서 카카오 인가 코드 받아오기
		String code = request.getParameter("code");
		if (code == null || code.trim().isEmpty()) {
			System.out.println("인가 코드 없음");
			response.sendRedirect(request.getContextPath() + "/Member/snsjoin.me"); // 로그인 페이지로 리디렉트
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

	private void openLoginView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setAttribute("center", "members/login.jsp");

		nextPage = "/main.jsp";
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

	private void handleLogin(String userId, HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		try {
			if (userId != null) {
				// 사용자 ID로 DB 조회 (회원 존재 여부 확인)
				boolean isUserExists = memberService.isUserExists(userId);

				if (isUserExists) {

					HttpSession session = request.getSession();
					session.setAttribute("userId", userId); // 로그인한 사용자의 아이디를 세션에 저장
					// 회원 존재 시 메인 페이지로 리다이렉트
					System.out.println("회원 존재 확인: " + userId);
					response.sendRedirect(request.getContextPath() + "/Main/home"); // 메인 페이지로 리다이렉트

					return; // 리다이렉트 후 더 이상 코드를 실행하지 않도록 return
				} else {
					// 회원이 존재하지 않으면 회원가입 페이지로 이동
					System.out.println("회원 존재하지 않음: " + userId);
					response.setContentType("text/html; charset=UTF-8");
					PrintWriter out = response.getWriter();
					out.println("<script>");
					out.println("alert('회원가입이 필요합니다. 회원가입 페이지로 이동합니다.');");
					out.println(
							"location.href='" + request.getContextPath() + "/Member/join.me?userId=" + userId + "';");
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

	private void processMemberLogOut(HttpServletRequest request, HttpServletResponse response) throws IOException {
		// 세션 무효화
		HttpSession session = request.getSession(false); // 기존 세션 가져오기
		if (session != null) {
			session.invalidate(); // 세션 무효화
		}

		// 리다이렉트: 로그아웃 후 메인 페이지로 이동
		response.sendRedirect(request.getContextPath() + "/Main/home");
	}

	private void openDeleteMember(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setAttribute("center", "members/deletemember.jsp");
		request.setAttribute("pageTitle", "탈퇴 페이지");
		nextPage = "/main.jsp";
	}

	private void processDeleteMember(HttpServletRequest request, HttpServletResponse response) throws IOException {
		// 세션에서 로그인된 사용자 아이디를 가져옵니다.
		HttpSession session = request.getSession();
		String readonlyId = (String) session.getAttribute("userId");

		// 사용자가 입력한 아이디를 가져옵니다.
		String inputId = request.getParameter("inputId");

		// 아이디가 일치하지 않을 경우
		if (readonlyId == null || !readonlyId.equals(inputId)) {
			session.setAttribute("message", "입력한 아이디가 일치하지 않습니다.");
			response.sendRedirect(request.getContextPath() + "/Member/deleteMember.me"); // 탈퇴 페이지로 리다이렉트
			return;
		}

		// 서비스 레이어를 호출하여 탈퇴 처리
		boolean isDeleted = memberService.deleteMember(readonlyId);

		if (isDeleted) {
			// 탈퇴 성공 시 세션 무효화 및 메인 페이지로 이동
			session.invalidate();
			response.sendRedirect(request.getContextPath() + "/main.jsp");
		} else {
			// 탈퇴 실패 시 메시지 설정 후 탈퇴 페이지로 리다이렉트
			session.setAttribute("message", "탈퇴 처리 중 문제가 발생했습니다. 다시 시도해주세요.");
			response.sendRedirect(request.getContextPath() + "/Member/deleteMember.me");
		}

	}

	private void openWishList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// 세션에서 사용자 ID를 가져옴
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute("userId");

		if (userId == null) {
			// 사용자 ID가 없을 경우 로그인 페이지로 리다이렉트
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}

		// MemberService 인스턴스 생성 및 위시리스트 정보 가져오기
		memberService.getWishListInfos(request, userId); // 서비스에서 레시피 및 밀키트 위시리스트 정보를 가져옴

		// 포워딩할 페이지 설정
		request.setAttribute("center", "members/wishlist.jsp");
		
		nextPage = "/main.jsp"; // 메인 페이지로 이동하도록 설정
	}

	private void deleteWishRecipe(HttpServletRequest request, HttpServletResponse response) throws IOException {

		String userId = request.getParameter("userId");
		String recipeNo = request.getParameter("recipeNo");

		// 값이 제대로 넘어오는지 확인
		System.out.println("userId: " + userId);
		System.out.println("recipeNo: " + recipeNo);

		int result = memberService.deleteWishRecipe(userId, recipeNo);

		if (!response.isCommitted()) { // 응답이 커밋되지 않았다면 리다이렉트 처리
			if (result == 1) {
				// 삭제 성공
				System.out.println("삭제 성공!");
				response.sendRedirect(request.getContextPath() + "/Member/wishList.me");
				return; // sendRedirect 후 메소드 종료
			} else if (result == 0) {
				// 삭제 실패: 해당 레시피는 위시리스트에 없음
				System.out.println("삭제 실패: 해당 레시피는 위시리스트에 없습니다.");
			} else {
				// DB 통신 오류
				System.out.println("DB 통신 오류가 발생했습니다.");
			}
		}
	}

	private void deleteWishMealkit(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String userId = request.getParameter("userId");
		String mealkitNo = request.getParameter("mealkitNo");

		// 값이 제대로 넘어오는지 확인
		System.out.println("userId: " + userId);
		System.out.println("mealkitNo: " + mealkitNo);

		int result = memberService.deleteWishMealkit(userId, mealkitNo);

		if (!response.isCommitted()) { // 응답이 커밋되지 않았다면 리다이렉트 처리
			if (result == 1) {
				// 삭제 성공
				System.out.println("삭제 성공!");
				response.sendRedirect(request.getContextPath() + "/Member/wishList.me");
				return; // sendRedirect 후 메소드 종료
			} else if (result == 0) {
				// 삭제 실패: 해당 레시피는 위시리스트에 없음
				System.out.println("삭제 실패: 해당 레시피는 위시리스트에 없습니다.");
			} else {
				// DB 통신 오류
				System.out.println("DB 통신 오류가 발생했습니다.");
			}
		}

	}

	private boolean openRecentList(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {
		
		String userId = (String) request.getSession().getAttribute("userId"); // 세션에서 userId 가져오기
		
		if (userId == null) {
			response.sendRedirect("/login.jsp"); // 로그인하지 않은 경우 로그인 페이지로 리디렉션
			return false;
		}

		// 최근 본 글 목록 가져오기 (type에 맞게 필터링)
		//ArrayList<HashMap<String, Object>> recentViewInfos = memberService.getRecentViews(userId, type);		
		HashMap<String, Object> recentViewInfos = memberService.getRecentViews(userId);

		// 최근 본 글 목록을 request에 추가
		request.setAttribute("recentViewInfos", recentViewInfos);

		// center 부분에 해당하는 JSP 파일 설정
		request.setAttribute("center", "members/recent.jsp");

		// 메인 페이지로 이동
		nextPage = "/main.jsp";
		
		return true;
	}

	private void openCartList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String userId = (String) request.getSession().getAttribute("userId");

		// userId가 없는 경우 처리
		if (userId == null || userId.isEmpty()) {
			response.sendRedirect("/login"); // 로그인 페이지로 리디렉션
			return;
		}

		try {
			// 서비스에서 데이터 가져오기
			ArrayList<HashMap<String, Object>> cartListInfos = memberService.getCartListInfos(userId);

			// 데이터가 없으면 빈 리스트를 전달
			if (cartListInfos == null) {
				cartListInfos = new ArrayList<>();
			}

			request.setAttribute("cart", cartListInfos); // cart로 전달
			request.setAttribute("center", "members/cartlist.jsp");

			nextPage = "/main.jsp";
		} catch (Exception e) {
			// 예외 처리 (예: 로그 출력)
			e.printStackTrace();
			request.setAttribute("errorMessage", "장바구니 정보를 가져오는 데 문제가 발생했습니다.");
			nextPage = "/error.jsp"; // 에러 페이지로 이동
		}
	}

	private void deleteCartList(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String userId = request.getParameter("userId");
		String mealkitNo = request.getParameter("mealkitNo");

		// 값이 제대로 넘어오는지 확인
		System.out.println("userId: " + userId);
		System.out.println("mealkitNo: " + mealkitNo);

		int result = memberService.deleteCartList(userId, mealkitNo);

		if (!response.isCommitted()) { // 응답이 커밋되지 않았다면 리다이렉트 처리
			if (result == 1) {
				// 삭제 성공
				System.out.println("삭제 성공!");
				response.sendRedirect(request.getContextPath() + "/Member/cartList.me");
				return; // sendRedirect 후 메소드 종료
			} else if (result == 0) {
				// 삭제 실패: 해당 레시피는 위시리스트에 없음
				System.out.println("삭제 실패: 해당 레시피는 위시리스트에 없습니다.");
			} else {
				// DB 통신 오류
				System.out.println("DB 통신 오류가 발생했습니다.");
			}
		}
	}
	
	private void updateCartList(HttpServletRequest request, HttpServletResponse response) throws IOException {
	    // 요청 파라미터 가져오기
	    String userId = request.getParameter("userId");
	    String mealkitNo = request.getParameter("mealkitNo");
	    String quantityStr = request.getParameter("quantity");

	    // 값이 제대로 넘어오는지 확인
	    System.out.println("userId: " + userId);
	    System.out.println("mealkitNo: " + mealkitNo);
	    System.out.println("quantity: " + quantityStr);

	    // 수량 값 유효성 검사
	    int quantity = 0;
	    try {
	        quantity = Integer.parseInt(quantityStr);
	        if (quantity <= 0) {
	            System.out.println("수량 값이 0 이하입니다. 유효한 수량을 입력하세요.");
	            response.sendRedirect(request.getContextPath() + "/Member/cartList.me");
	            return;
	        }
	    } catch (NumberFormatException e) {
	        System.out.println("수량 값이 잘못되었습니다: " + quantityStr);
	        response.sendRedirect(request.getContextPath() + "/Member/cartList.me");
	        return;
	    }

	    // 서비스 계층을 통해 수량 업데이트
	    int result = memberService.updateCartList(userId, mealkitNo, quantity);

	    if (!response.isCommitted()) { // 응답이 커밋되지 않았다면 리다이렉트 처리
	        if (result == 1) {
	            // 업데이트 성공
	            System.out.println("수량 업데이트 성공!");
	            response.sendRedirect(request.getContextPath() + "/Member/cartList.me");
	        } else if (result == 0) {
	            // 업데이트 실패: 해당 항목이 없음
	            System.out.println("수량 업데이트 실패: 해당 항목이 장바구니에 없습니다.");
	            response.sendRedirect(request.getContextPath() + "/Member/cartList.me");
	        } else {
	            // DB 통신 오류
	            System.out.println("DB 통신 오류가 발생했습니다.");
	            response.sendRedirect(request.getContextPath() + "/Member/cartList.me");
	        }
	    }
	}
	
//	private void sendPayMent(HttpServletRequest request, HttpServletResponse response) throws IOException {
//	    HttpSession session = request.getSession();
//	    String userId = (String) session.getAttribute("userId");
//
//	    // 장바구니에서 선택된 아이템 가져오기
//	    String selectedMealkitNosParam = request.getParameter("selectedMealkitNos");
//
//	    // 선택된 아이템이 없으면 처리
//	    if (selectedMealkitNosParam == null || selectedMealkitNosParam.isEmpty()) {
//	        System.out.println("sendPayMent - 선택된 상품이 없습니다.");
//	        response.sendRedirect(request.getContextPath() + "/Member/cartList.me");
//	        return;
//	    }
//
//	    // "1,2"와 같은 문자열을 "," 기준으로 분리하여 배열로 만듦
//	    String[] selectedMealkitNos = selectedMealkitNosParam.split(",");
//
//	    // 장바구니 정보 가져오기
//	    ArrayList<HashMap<String, Object>> cartListInfos = memberService.getCartListInfos(userId);
//	    
//	    // 선택된 아이템 필터링
//	    ArrayList<HashMap<String, Object>> filteredItems = new ArrayList<>();
//	    try {
//	        for (String selectedMealkitNo : selectedMealkitNos) {
//	            int no = Integer.parseInt(selectedMealkitNo); // 문자열을 숫자로 변환
//	            for (HashMap<String, Object> cartItem : cartListInfos) {
//	                MealkitVO mealkitVO = (MealkitVO) cartItem.get("mealkitVO");
//	                if (mealkitVO.getNo() == no) {
//	                    filteredItems.add(cartItem);
//	                }
//	            }
//	        }
//	    } catch (NumberFormatException e) {
//	        System.err.println("sendPayMent - Invalid mealkit number: " + e.getMessage());
//	    } 
//
//	    // 선택된 아이템을 세션에 저장
//	    session.setAttribute("selectedItems", filteredItems);
//
//	    // 결제 페이지로 리디렉션
//	    response.sendRedirect(request.getContextPath() + "/Member/openPayMent.me");
//	}
//
//
//
//
//
//	private void openPayMent(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//	    HttpSession session = request.getSession();
//	    ArrayList<HashMap<String, Object>> selectedItems = (ArrayList<HashMap<String, Object>>) session.getAttribute("selectedItems");
//
//	    // 선택된 아이템을 request에 설정
//	    if (selectedItems != null && !selectedItems.isEmpty()) {
//	        request.setAttribute("selectedItems", selectedItems);
//	    } else {
//	        request.setAttribute("selectedItems", new ArrayList<>()); // 기본 빈 리스트 전달
//	    }
//
//	    // 페이지 설정
//	    request.setAttribute("center", "members/payment.jsp");
//
//	    // main.jsp로 포워딩
//	    RequestDispatcher dispatcher = request.getRequestDispatcher("/main.jsp");
//	    dispatcher.forward(request, response);
//	}


	private void updateOrderList(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		// 세션에서 userId 가져오기
	    HttpSession session = request.getSession();
	    String userId = (String) session.getAttribute("userId");

	    if (userId == null) {
	        response.sendRedirect(request.getContextPath() + "/login.jsp"); // 세션에 userId가 없으면 로그인 페이지로 리디렉션
	        return;
	    }

	    // 폼 데이터 받기 (배열로 여러 개의 품목을 받음)
	    String[] mealkitNos = request.getParameterValues("mealkitNo");
	    String[] quantities = request.getParameterValues("quantity");
	    String address1 = request.getParameter("address1");
	    String address2 = request.getParameter("address2");
	    String address3 = request.getParameter("address3");

	    // 배송지 정보 합치기
	    String fullAddress = address1 + " " + address2 + " " + address3;

	    // 반복문을 통해 각 품목에 대한 결제 처리
	    boolean result = false; // 전체 결제가 성공했는지 여부
	    for (int i = 0; i < mealkitNos.length; i++) {
	        // mealkitNo와 quantity는 int로 변환
	        int mealkitNo = Integer.parseInt(mealkitNos[i]);
	        int quantity = Integer.parseInt(quantities[i]);

	        // 각 품목에 대해 주문 처리
	        result = memberService.updateOrderList(userId, mealkitNo, quantity, fullAddress);
	    }

	    // 주문 성공/실패에 따라 처리
	    if (result) {
	        response.sendRedirect(request.getContextPath() + "/Member/viewMyDelivery.me");  // 주문 성공 후 배송지 조회 페이지로 이동
	    } else {
	        response.sendRedirect(request.getContextPath() + "/Member/openPayMent.me");  // 주문 실패 시 결제 페이지로 이동
	    }
	}
	

		







	
	


	// 혜원 파트
	// ------------------------------------------------------------------------------------------
	// 민석 파트

	private boolean openMypagemainView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		String userId = (String) request.getSession().getAttribute("userId");
		request.setAttribute("pageTitle", "마이페이지");
		if (userId == null || userId.equals("") || userId.length() <= 0) {
			
			PrintWriter out = response.getWriter();
			
			out.println("<script>");
			out.println("alert('로그인이 필요합니다. 로그인 페이지로 이동합니다.');");
			out.println("location.href='" + request.getContextPath() + "/Member/login.me';");
			out.println("</script>");
			out.close();
			
			return false;
		}
		
		MemberVO member = memberService.getMemberProfile(userId);

		ArrayList<Integer> deliveredCounts = memberService.getCountOrderDelivered(request);
		ArrayList<Integer> sendedCounts = memberService.getCountOrderSended(request);

		response.setHeader("Cache-Control", "no-cache");
		response.addHeader("Cache-Control", "no-store");
		
		request.setAttribute("member", member);
		request.setAttribute("deliveredCounts", deliveredCounts);
		request.setAttribute("sendedCounts", sendedCounts);
		request.setAttribute("center", "members/mypagemain.jsp");

		nextPage = "/main.jsp";
		
		return true;
	}

	private void openMemberUpdateView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		MemberVO vo = memberService.getMember(request);
		
		request.setAttribute("vo", vo);
		request.setAttribute("pageTitle", "프로필 수정");
		request.setAttribute("center", "members/profileupdate.jsp");

		nextPage = "/main.jsp";
	}

	private void processMemberUpdate(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		int result = memberService.updateProfile(request);

		response.setHeader("Cache-Control", "no-cache");
		response.addHeader("Cache-Control", "no-store");
		
		nextPage = "/Member/mypagemain.me";
	}

	private void openMyDeliveryView(HttpServletRequest request, HttpServletResponse response) {

		HttpSession session = request.getSession();
		String id = (String) session.getAttribute("userId");
		request.setAttribute("pageTitle", "배송조회 페이지");
		ArrayList<HashMap<String, Object>> orderedMealkitList = memberService.getDeliveredMealkit(request);

		request.setAttribute("orderedMealkitList", orderedMealkitList);
		request.setAttribute("center", "members/mydelivery.jsp");
		nextPage = "/main.jsp";
	}

	private void openMySendView(HttpServletRequest request, HttpServletResponse response) {
	    HttpSession session = request.getSession();
	    String id = (String) session.getAttribute("userId");

	    // 서비스 호출
	    ArrayList<HashMap<String, Object>> orderedMealkitList = memberService.getSendedMealkit(request);

	    // JSP에 데이터 전달
	    request.setAttribute("orderedMealkitList", orderedMealkitList);
	    request.setAttribute("pageTitle", "발송조회 페이지");
	    request.setAttribute("center", "members/sendmealkit.jsp");

	    nextPage = "/main.jsp";
	}

	private void openMyRecipeView(HttpServletRequest request, HttpServletResponse response) {
		request.setAttribute("center", "members/myreceipe.jsp");
		nextPage = "/main.jsp";
	}
	
	private void processGetOrderedMealkitList(HttpServletRequest request, HttpServletResponse response) { 
		String userId = (String) request.getSession().getAttribute("id"); 
		List<HashMap<String, Object>> orderedMealkitList = memberService.getOrderedMealkitList(userId); 
		request.setAttribute("orderedMealkitList", orderedMealkitList); 
		request.setAttribute("center", "members/sendmealkit.jsp"); 
		nextPage = "/main.jsp"; }

	private void openMyReviewsView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HashMap<String, Object> reviews = memberService.getReviews(request);

		request.setAttribute("reviews", reviews);

		request.setAttribute("pageTitle", "내 리뷰 관리");
		request.setAttribute("center", "members/myreview.jsp");

		nextPage = "/main.jsp";
	}

	
	private void openPaymentView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		ArrayList<HashMap<String, Object>> orders = mealkitService.getPurchaseMealkits(request);
		MemberVO myInfo = memberService.getMember(request); 
		
		request.setAttribute("orders", orders);
		request.setAttribute("myInfo", myInfo);
		request.setAttribute("isCart", request.getParameter("isCart"));
		request.setAttribute("pageTitle", "밀키트 구매하기");
		request.setAttribute("center", "members/payment.jsp");

		nextPage = "/main.jsp";
	}
}