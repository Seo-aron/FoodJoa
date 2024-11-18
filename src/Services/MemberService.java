package Services;
 
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONObject;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import Common.NaverLoginAPI;
import DAOs.MemberDAO;
import VOs.MemberVO;

public class MemberService {

	private MemberDAO memberDAO;

    public MemberService() {
        memberDAO = new MemberDAO();
    }
	
    private void moveProfile(String path, String id, String profileFileName) {
        if (profileFileName != null) {
            File oldFile = new File(path + "temp/" + profileFileName);
            File newFile = new File(path + profileFileName);  // 최종 위치 (userProfiles/ID_파일명)

            if (!oldFile.exists()) return;
            
            // 새 위치로 파일 이동
            oldFile.renameTo(newFile);
        }
    }

    public boolean checkMemberId(HttpServletRequest request) {
        String id = request.getParameter("id");
        return memberDAO.isExistMemberId(id);
    }
    
    //네이버 아이디 받아오기
    public  String insertNaverMember(HttpServletRequest request, HttpServletResponse response)throws IOException {
    	
    	String naverId = null;
		try {

			// 네이버 인증 후 콜백 처리
			naverId = NaverLoginAPI.handleNaverLogin(request, response);
			
			/*
			System.out.println("네이버 아이디: " + naverId); // 콘솔에 아이디 출력

			request.getSession().setAttribute("userId", naverId);

			// 액세스 토큰 추출
			String accessToken = request.getParameter("accessToken");

			// 네이버 사용자 정보 요청
			JSONObject userProfile = NaverLoginAPI.handleUserProfile(accessToken);

			System.out.println(userProfile);

			// 사용자 id 가져오기
			String naverId = userProfile.getString("id");

			// DAO 메소드 호출로 id 값만 DB에 저장
			memberDAO.insertNaverMember(vo);
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
        String tokenParams = "grant_type=authorization_code"
                + "&client_id=dfedef18f339b433884cc51b005f2b42" // REST API 키
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
        String kakaoId = String.valueOf(kakaoIdLong);       

        // 카카오 아이디 확인 (디버깅)
        System.out.println("받은 카카오 아이디: " + kakaoId);

        // DB에 카카오 ID 저장 (회원 정보 저장 등 추가 로직 가능)
        MemberVO vo = new MemberVO();
        vo.setId(kakaoId);  // 카카오 ID를 VO에 설정

        return kakaoId;
    }

    
    
    
    
    //추가정보
    public void insertMember(HttpServletRequest request) throws ServletException, IOException {
        // 이미지 업로드 디렉토리 설정
        String path = request.getServletContext().getRealPath("/images/member/userProfiles/");
 
        // 디렉토리 존재 확인 후 없으면 생성
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs();  // 디렉토리 생성
        }
        
        // 최대 파일 크기 1GB로 설정
        int maxSize = 1024 * 1024 * 1024;  // 1GB
        MultipartRequest multipartRequest = new MultipartRequest(
                request, 
                path, 
                maxSize, 
                "UTF-8", 
                new DefaultFileRenamePolicy()
        );

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        if (userId == null) {
            userId = multipartRequest.getParameter("userId"); // 파라미터로도 확인
        }


        String profileFileName = multipartRequest.getFilesystemName("profileFile");
        // 회원 정보 생성 (프로필 파일명 포함)
        MemberVO vo = new MemberVO(
        		userId, 
                multipartRequest.getParameter("name"),
                multipartRequest.getParameter("nickname"),
                multipartRequest.getParameter("phone"),
                multipartRequest.getParameter("address"),
                profileFileName
        );


        memberDAO.insertMember(vo);
        
        // 프로필 이미지 이동
        moveProfile(path, userId, profileFileName);
    }

    
    // 네이버 아이디 받기
    public String getNaverId(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String naverId = null;
        try {
            // 네이버 인증 후 콜백 처리
            naverId = NaverLoginAPI.handleNaverLogin(request, response);  // 기존 코드 재사용
        } catch (Exception e) {
            System.out.println("네이버 회원 정보 저장 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
        return naverId;
    }

    
    // 카카오 아이디 받기
    public String getKakaoId(String code) throws Exception {
        String kakaoId = null;
        
        // 1. 액세스 토큰 요청
        String tokenUrl = "https://kauth.kakao.com/oauth/token";
        String tokenParams = "grant_type=authorization_code"
                + "&client_id=dfedef18f339b433884cc51b005f2b42"  // REST API 키
                + "&redirect_uri=http://localhost:8090/FoodJoa/Member/kakaologin.me"  // Redirect URI
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

        return kakaoId;
    }
    
    
    public int serviceUserCheck(HttpServletRequest request) {
        String login_id = request.getParameter("id");
        String login_name = request.getParameter("name");
        HttpSession session = request.getSession();
        session.setAttribute("id", login_id);

        return memberDAO.userCheck(login_id, login_name);
    }

    public String profileupdate(HttpServletRequest request) {
       
        return null;
    }
    
	//정보수정 사진 추가
	public void addProfile(HttpServletRequest request){	
        
	}
	
	public MemberVO getMember(HttpServletRequest request) throws ServletException, IOException  {
		
		//HttpSession session = request.getSession();
		
		//String loginedId = (String) session.getAttribute("id");
		
		String login_id = request.getParameter("id");
		String login_name = request.getParameter("name");
		
		
		return memberDAO.selectMember(request.getParameter("id"));
		//return memberDAO.selectMember(loginedId);
		
	}

	public boolean isUserExists(String userId) throws SQLException {
	    // DB에서 아이디가 존재하는지 확인하는 로직
	    return memberDAO.isUserExists(userId);
	}

	
}
