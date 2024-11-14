package Services;
 
import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
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
    
    public  String serviceInsertNaverMember(HttpServletRequest request, HttpServletResponse response)throws IOException {
    	
    	String naverId = null;
        try {
        	
        	   // 네이버 인증 후 콜백 처리
        	 naverId =  NaverLoginAPI.handleNaverLogin(request, response);
//        	
//	            System.out.println("네이버 아이디: " + naverId);  // 콘솔에 아이디 출력
//
//	            request.getSession().setAttribute("userId", naverId);
	            
	            
	            
//            // 액세스 토큰 추출
//            String accessToken = request.getParameter("accessToken");
//
//            // 네이버 사용자 정보 요청
//            JSONObject userProfile = NaverLoginAPI.handleUserProfile(accessToken);
//            
//            System.out.println(userProfile);
//       
//            // 사용자 id 가져오기
//            String naverId = userProfile.getString("id");
           
            // DAO 메소드 호출로 id 값만 DB에 저장
             // memberDAO.insertNaverMember(vo);
           
        } catch (Exception e) {
            System.out.println("네이버 회원 정보 저장 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        }
        return naverId;
    }

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

        // 로그로 파일 정보 확인
//       String userId = (String)request.getSession(true).getAttribute("userId");
        
        
        
//        
        String profileFileName = multipartRequest.getFilesystemName("profileFile");
       String userId = multipartRequest.getParameter("userId");
//        
//        // 콘솔에 받아온 정보 출력
        System.out.println("ID: " + multipartRequest.getParameter("userId"));


        System.out.println("Name: " + multipartRequest.getParameter("name"));
        System.out.println("Nickname: " + multipartRequest.getParameter("nickname"));
        System.out.println("Phone: " + multipartRequest.getParameter("phone"));
        System.out.println("Address: " + multipartRequest.getParameter("address"));
        System.out.println("Profile File Name: " + profileFileName);

        // 회원 정보 생성 (프로필 파일명 포함)
        MemberVO vo = new MemberVO(
        		userId, 
                multipartRequest.getParameter("name"),
                multipartRequest.getParameter("nickname"),
                multipartRequest.getParameter("phone"),
                multipartRequest.getParameter("address"),
                profileFileName
        );

        // 회원 DB에 정보 저장
        try {
            memberDAO.insertMember(vo);
        } catch (SQLException e) {
            e.printStackTrace();
        }
//
//        // 프로필 이미지 이동
//        moveProfile(path, userId, profileFileName);
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
}
