package Services;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import Common.FileIOController;
import Common.NaverLoginAPI;
import DAOs.MealkitDAO;
import DAOs.MemberDAO;
import DAOs.RecipeDAO;
import VOs.MemberVO;

public class MemberService {

	  private MemberDAO memberDAO;
	    private RecipeDAO recipeDAO; // RecipeDAO 객체 추가
	    private MealkitDAO mealkitDAO;

	    public MemberService() {
	        memberDAO = new MemberDAO(); // MemberDAO 초기화
	        recipeDAO = new RecipeDAO(); // RecipeDAO 초기화
	        mealkitDAO = new MealkitDAO();
	    }
    

    
    //네이버 아이디 받아오기
    public  String insertNaverMember(HttpServletRequest request, HttpServletResponse response)throws IOException {
    	
    	String naverId = null;


		try {

			// 네이버 인증 후 콜백 처리
			naverId = NaverLoginAPI.handleNaverLogin(request, response);

			/*
			 * System.out.println("네이버 아이디: " + naverId); // 콘솔에 아이디 출력
			 * 
			 * request.getSession().setAttribute("userId", naverId);
			 * 
			 * // 액세스 토큰 추출 String accessToken = request.getParameter("accessToken");
			 * 
			 * // 네이버 사용자 정보 요청 JSONObject userProfile =
			 * NaverLoginAPI.handleUserProfile(accessToken);
			 * 
			 * System.out.println(userProfile);
			 * 
			 * // 사용자 id 가져오기 String naverId = userProfile.getString("id");
			 * 
			 * // DAO 메소드 호출로 id 값만 DB에 저장 memberDAO.insertNaverMember(vo);
			 */

		} catch (Exception e) {
			System.out.println("네이버 회원 정보 저장 중 오류 발생: " + e.getMessage());
			e.printStackTrace();
		}
		return naverId;
	}

	public String insertKakaoMember(String code) throws Exception {
		// 1. 액세스 토큰 요청
		String tokenUrl = "https://kauth.kakao.com/oauth/token";
		String tokenParams = "grant_type=authorization_code" + "&client_id=dfedef18f339b433884cc51b005f2b42" // REST API
																												// 키
				+ "&redirect_uri=http://localhost:8090/FoodJoa/Member/kakaojoin.me" // Redirect URI
				+ "&code=" + code;

		HttpURLConnection tokenConn = (HttpURLConnection) new URL(tokenUrl).openConnection();
		tokenConn.setRequestMethod("POST");
		tokenConn.setDoOutput(true);
		try (OutputStream os = tokenConn.getOutputStream()) {
			os.write(tokenParams.getBytes());
			os.flush();
		}

		// 응답 확인
		BufferedReader tokenBr = new BufferedReader(new InputStreamReader(tokenConn.getInputStream()));
		StringBuilder tokenResponse = new StringBuilder();
		String line;
		while ((line = tokenBr.readLine()) != null) {
			tokenResponse.append(line);
		}
		tokenBr.close();

		// JSON 파싱: 액세스 토큰 추출
		JSONObject tokenJson = new JSONObject(tokenResponse.toString());
		String accessToken = tokenJson.getString("access_token");

		// 2. 사용자 정보 요청
		String userInfoUrl = "https://kapi.kakao.com/v2/user/me";
		HttpURLConnection userInfoConn = (HttpURLConnection) new URL(userInfoUrl).openConnection();
		userInfoConn.setRequestMethod("GET");
		userInfoConn.setRequestProperty("Authorization", "Bearer " + accessToken);

		BufferedReader userBr = new BufferedReader(new InputStreamReader(userInfoConn.getInputStream()));
		StringBuilder userInfoResponse = new StringBuilder();
		while ((line = userBr.readLine()) != null) {
			userInfoResponse.append(line);
		}
		userBr.close();

		// JSON 파싱: 사용자 ID 추출
		JSONObject userInfoJson = new JSONObject(userInfoResponse.toString());

		// 카카오에서 반환된 사용자 정보 중 ID를 숫자형으로 추출
		long kakaoIdLong = userInfoJson.getLong("id");

		// 숫자형 ID를 문자열로 변환
		String kakaoId = String.valueOf(kakaoIdLong);

		// 카카오 아이디 확인 (디버깅)
		System.out.println("받은 카카오 아이디: " + kakaoId);

		// DB에 카카오 ID 저장 (회원 정보 저장 등 추가 로직 가능)
		MemberVO vo = new MemberVO();
		vo.setId(kakaoId); // 카카오 ID를 VO에 설정

		return kakaoId;
	}

	// 추가정보
	public boolean insertMember(HttpServletRequest request) throws ServletException, IOException {

		ServletContext application = request.getServletContext();

		String path = application.getRealPath(File.separator + "images");
		int maxSize = 1024 * 1024 * 1024;

		MultipartRequest multipartRequest = new MultipartRequest(request, path + File.separator + "temp", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());

		String userId = multipartRequest.getParameter("userId"); // 파라미터로도 확인

		// 주소 파라미터 가져오기
		String address1 = multipartRequest.getParameter("address1");
		String address2 = multipartRequest.getParameter("address2");
		String address3 = multipartRequest.getParameter("address3");

		// 전체 주소 결합
		String address = address1 + " " + address2 + " " + address3;

		String profileFileName = multipartRequest.getFilesystemName("profileFile");
		// 회원 정보 생성 (프로필 파일명 포함)
		MemberVO vo = new MemberVO(userId, multipartRequest.getParameter("name"),
				multipartRequest.getParameter("nickname"), multipartRequest.getParameter("phone"), address, // 결합된 주소
				profileFileName);

		if (memberDAO.insertMember(vo) == 1) {
			// 회원가입 성공했을 경우
			
			request.getSession().setAttribute("userId", userId);
			// 프로필 이미지 이동
			String srcPath = path + File.separator + "temp" + File.separator;
			String descPath = path + File.separator + "member" + File.separator + "userProfiles" + File.separator + userId;

			FileIOController.moveFile(srcPath, descPath, profileFileName);
			
			return true;
		}
		else {
			return false;
		}		
	}

	public String getNaverId(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String naverId = null;
		try {
			// 네이버 인증 후 콜백 처리
			naverId = NaverLoginAPI.handleNaverLogin(request, response); // request와 response 전달

		} catch (Exception e) {
			System.out.println("네이버 회원 정보 저장 중 오류 발생: " + e.getMessage());
			e.printStackTrace();
		}
		return naverId;
	}

	public String getKakaoId(String code) throws Exception {
		String kakaoId = null;
		try {
			// 1. 액세스 토큰 요청
			String tokenUrl = "https://kauth.kakao.com/oauth/token";
			String tokenParams = "grant_type=authorization_code" + "&client_id=dfedef18f339b433884cc51b005f2b42" // REST
																													// API
																													// 키
					+ "&redirect_uri=http://localhost:8090/FoodJoa/Member/kakaologin.me" // Redirect URI
					+ "&code=" + code;

			HttpURLConnection tokenConn = (HttpURLConnection) new URL(tokenUrl).openConnection();
			tokenConn.setRequestMethod("POST");
			tokenConn.setDoOutput(true);
			try (OutputStream os = tokenConn.getOutputStream()) {
				os.write(tokenParams.getBytes());
				os.flush();
			}

			// 응답 확인
			BufferedReader tokenBr = new BufferedReader(new InputStreamReader(tokenConn.getInputStream()));
			StringBuilder tokenResponse = new StringBuilder();
			String line;
			while ((line = tokenBr.readLine()) != null) {
				tokenResponse.append(line);
			}
			tokenBr.close();

			// JSON 파싱: 액세스 토큰 추출
			JSONObject tokenJson = new JSONObject(tokenResponse.toString());
			String accessToken = tokenJson.getString("access_token");

			// 2. 사용자 정보 요청
			String userInfoUrl = "https://kapi.kakao.com/v2/user/me";
			HttpURLConnection userInfoConn = (HttpURLConnection) new URL(userInfoUrl).openConnection();
			userInfoConn.setRequestMethod("GET");
			userInfoConn.setRequestProperty("Authorization", "Bearer " + accessToken);

			BufferedReader userBr = new BufferedReader(new InputStreamReader(userInfoConn.getInputStream()));
			StringBuilder userInfoResponse = new StringBuilder();
			while ((line = userBr.readLine()) != null) {
				userInfoResponse.append(line);
			}
			userBr.close();

			// JSON 파싱: 사용자 ID 추출
			JSONObject userInfoJson = new JSONObject(userInfoResponse.toString());

			// 카카오에서 반환된 사용자 정보 중 ID를 숫자형으로 추출
			long kakaoIdLong = userInfoJson.getLong("id");

			// 숫자형 ID를 문자열로 변환
			kakaoId = String.valueOf(kakaoIdLong);

			// 카카오 아이디 확인 (디버깅)
			System.out.println("받은 카카오 아이디: " + kakaoId);

		} catch (Exception e) {
			System.out.println("카카오 아이디 가져오기 중 오류 발생: " + e.getMessage());
			e.printStackTrace();
		}

		return kakaoId; // 카카오 아이디 반환
	}

	public int serviceUserCheck(HttpServletRequest request) {
		String login_id = request.getParameter("id");
		String login_name = request.getParameter("name");
		HttpSession session = request.getSession();
		session.setAttribute("id", login_id);

		return memberDAO.checkMember(login_id, login_name);
	}

	public MemberVO getMember(HttpServletRequest request) throws ServletException, IOException {

		HttpSession session = request.getSession();
		String id = (String) session.getAttribute("userId");
		return memberDAO.selectMember(id);

	}

	public int updateProfile(HttpServletRequest request) throws ServletException, IOException {

		HttpSession session = request.getSession();
		String id = (String) session.getAttribute("userId");
		// String id = "admin";

		ServletContext application = request.getServletContext();

		String path = application.getRealPath(File.separator + "images");
		int maxSize = 1024 * 1024 * 1024;

		MultipartRequest multipartRequest = new MultipartRequest(request, path + File.separator + "temp", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());

		String originProfile = multipartRequest.getParameter("origin-profile");
		String fileName = multipartRequest.getOriginalFileName("profile");

		if (fileName == null) {
			fileName = originProfile;
		}

		MemberVO member = new MemberVO(id, multipartRequest.getParameter("name"),
				multipartRequest.getParameter("nickname"), multipartRequest.getParameter("phone"),
				multipartRequest.getParameter("address"), fileName);

		int result = memberDAO.updateMember(member);

		// 병합 후 FileIOController 클래스 생성 되면 작성 해야 함

		return result;
	}

	public boolean isUserExists(String userId) throws SQLException {
		// DB에서 아이디가 존재하는지 확인하는 로직
		return memberDAO.isUserExists(userId);
	}

	public boolean deleteMember(String readonlyId) {
		try {
			// DAO를 통해 회원 삭제 처리
			int result = memberDAO.deleteMemberById(readonlyId);

			// 결과가 1이면 삭제 성공
			return result == 1;
		} catch (Exception e) {
			e.printStackTrace();
			return false; // 예외 발생 시 false 반환
		}
	}
	

	public void getWishListInfos(HttpServletRequest request, String userId) {
	    // 레시피 위시리스트 정보 가져오기
	    ArrayList<HashMap<String, Object>> recipeWishList = getRecipeWishList(userId);

	    // 밀키트 위시리스트 정보 가져오기
	    ArrayList<HashMap<String, Object>> mealKitWishList = getMealKitWishList(userId);

	    // request에 각각 설정
	    request.setAttribute("recipeWishListInfos", recipeWishList);
	    request.setAttribute("mealKitWishListInfos", mealKitWishList);
	}

	private ArrayList<HashMap<String, Object>> getRecipeWishList(String userId) {
	    // RecipeDAO에서 레시피 위시리스트 정보를 가져오는 메소드 호출
	    return recipeDAO.selectRecipeInfos(userId); // recipeDAO에서 레시피 위시리스트 가져오기
	}

	private ArrayList<HashMap<String, Object>> getMealKitWishList(String userId) {
	    // MealkitDAO에서 밀키트 위시리스트 정보를 가져오는 메소드 호출
	    return mealkitDAO.selectMealKitInfos(userId); // 0은 밀키트 위시리스트를 의미
	}




	public MemberVO getMemberProfile(String userId) {

	   return memberDAO.getMemberProfile(userId);
	}

	public ArrayList<HashMap<String, Object>> getDeliveredMealkit(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		String id = (String) session.getAttribute("userId");
		
		return memberDAO.selectDeliveredMealkit(id);
	}

	public ArrayList<HashMap<String, Object>> getSendedMealkit(HttpServletRequest request) {
	    HttpSession session = request.getSession();
	    String id = (String) session.getAttribute("userId");

	    // delivered 값을 요청 파라미터에서 가져오기
	    int delivered = 0; // 기본값
	    if (request.getParameter("delivered") != null) {
	        try {
	            delivered = Integer.parseInt(request.getParameter("delivered"));
	        } catch (NumberFormatException e) {
	            System.out.println("Invalid delivered value: " + request.getParameter("delivered"));
	        }
	    }

	    // DAO 호출
	    ArrayList<HashMap<String, Object>> sendedMealkitList = memberDAO.selectSendedMealkit(id, delivered);

	    return sendedMealkitList;
	}
    // 최근 본 목록을 조회하는 메소드
	public HashMap<String, Object> getRecentViews(String userId) {
		
		HashMap<String, Object> recentViews = new HashMap<String, Object>();
		
		ArrayList<HashMap<String, Object>> recentRecipeViews = memberDAO.getRecentRecipeViews(userId);
		ArrayList<HashMap<String, Object>> recentMealkitViews = memberDAO.getRecentMealkitViews(userId);
		
		recentViews.put("recipe", recentRecipeViews);
		recentViews.put("mealkit", recentMealkitViews);
		
		return recentViews;
	}

    public int deleteWishRecipe(String userId, String recipeNo) {
        // DAO에서 삭제 메소드를 호출하고 결과를 받음
        int result = recipeDAO.deleteWishRecipe(userId, recipeNo);
        
        // 결과에 따라 처리
        if (result == 0) {
            // 삭제할 레시피가 없으면 실패 처리
            return 0;  // 삭제 실패
        } else {
            // 삭제 성공 처리
            return 1;  // 삭제 성공
        }
    }
    
    public HashMap<String, Object> getReviews(HttpServletRequest request) {
    	
    	String id = (String) request.getSession().getAttribute("userId");
    	
    	HashMap<String, Object> reviews = new HashMap<String, Object>();
    	
    	ArrayList<HashMap<String, Object>> recipeReviews = recipeDAO.selectRecipeReviewsById(id);
    	ArrayList<HashMap<String, Object>> mealkitReviews = mealkitDAO.selectMealkitReviewsById(id);
    	
    	reviews.put("recipe", recipeReviews);
    	reviews.put("mealkit", mealkitReviews);
    	
    	return reviews;
    }

	public ArrayList<HashMap<String, Object>> getCartListInfos(String userId) {
       
		   if (userId == null || userId.isEmpty()) {
		        // 예외 처리 또는 빈 리스트 반환
		        return new ArrayList<>();
		    }

		    try {
		        return mealkitDAO.selectCartList(userId);
		    } catch (Exception e) {
		        // 예외 처리 (예: 로그 출력)
		        System.err.println("Error while fetching cart list: " + e.getMessage());
		        return new ArrayList<>();
		    }
		    
	}
		
    public ArrayList<Integer> getCountOrderDelivered(HttpServletRequest request) {
    	return mealkitDAO.selectCountOrderDelivered((String) request.getSession().getAttribute("userId"));
    }
    
    public ArrayList<Integer> getCountOrderSended(HttpServletRequest request) {
    	return mealkitDAO.selectCountOrderSended((String) request.getSession().getAttribute("userId"));
    }
    
	public int deleteWishMealkit(String userId, String mealkitNo) {
		  // DAO에서 삭제 메소드를 호출하고 결과를 받음
        int result = mealkitDAO.deleteWishMealkit(userId, mealkitNo);
        
        // 결과에 따라 처리
        if (result == 0) {
            // 삭제할 레시피가 없으면 실패 처리
            return 0;  // 삭제 실패
        } else {
            // 삭제 성공 처리
            return 1;  // 삭제 성공
        }
	}

	public int deleteCartList(String userId, String mealkitNo) {
		  // DAO에서 삭제 메소드를 호출하고 결과를 받음
        int result = mealkitDAO.deleteCartList(userId, mealkitNo);
        
        // 결과에 따라 처리
        if (result == 0) {
            // 삭제할 레시피가 없으면 실패 처리
            return 0;  // 삭제 실패
        } else {
            // 삭제 성공 처리
            return 1;  // 삭제 성공
        }
	}

	public int updateCartList(String userId, String mealkitNo, int quantity) {
		// DAO 객체를 통해 수량을 업데이트
	    int result = mealkitDAO.updateCartList(userId, mealkitNo, quantity);
	    
	    // 결과에 따라 1 또는 0을 반환 (성공/실패)
	    return result;
	}

	public boolean updateOrderList(String userId, int mealkitNo, int quantity, String fullAddress) {
		 // 주문 저장 메소드 호출
        boolean result = mealkitDAO.updateOrder(userId, mealkitNo, quantity, fullAddress);

        // 결과 반환
        return result;  // 주문 성공 시 true, 실패 시 false 반환
	}

	public int updateOrder(int orderNo, int deliveredStatus, int refundStatus) {
	    return memberDAO.updateOrderStatus(deliveredStatus, refundStatus, orderNo);
	}

	public List<HashMap<String, Object>> getOrderedMealkitList(String userId) { 
		 List<HashMap<String, Object>> orderedMealkitList = new ArrayList<>();
		 return orderedMealkitList; 
		}

}


