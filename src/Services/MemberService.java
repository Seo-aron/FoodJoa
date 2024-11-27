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
import DAOs.MemberDAO;
import DAOs.RecipeDAO;
import VOs.DeliveryInfoVO;
import VOs.MemberVO;

public class MemberService {

	  private MemberDAO memberDAO;
	    private RecipeDAO recipeDAO; // RecipeDAO 객체 추가

	    public MemberService() {
	        memberDAO = new MemberDAO(); // MemberDAO 초기화
	        recipeDAO = new RecipeDAO(); // RecipeDAO 초기화
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
	

	public ArrayList<HashMap<String, Object>> getWishListInfos(String id) {
		
	    RecipeDAO recipeDAO = new RecipeDAO();
	    return recipeDAO.selectWishListInfos(id);
	}

	public void getMemberProfile(HttpServletRequest request, String userId) throws ServletException, IOException, SQLException {
	    // 회원 정보를 DAO에서 조회
	    MemberVO member = memberDAO.getMemberProfile(userId);
	    
	    if (member != null) {
	        // 회원 정보를 request에 저장
	        request.setAttribute("member", member);
	    } else {
	        // 회원 정보 조회 실패 시 에러 메시지 설정
	        request.setAttribute("error", "회원 정보를 찾을 수 없습니다.");
	    }
	}

	public ArrayList<DeliveryInfoVO> getDeliver(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String id = (String) session.getAttribute("userId");
		return memberDAO.selectDeliver(id);
	}



	public ArrayList<DeliveryInfoVO> getSend(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String id = (String) session.getAttribute("userId");
		return memberDAO.selectSend(id);
	}
}
