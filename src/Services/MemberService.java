package Services;
 
import java.io.File;
import java.io.IOException;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import DAOs.MemberDAO;
import VOs.MemberVO;
import jdk.incubator.http.HttpRequest;

public class MemberService {

    private MemberDAO memberDAO;

    public MemberService() {
        memberDAO = new MemberDAO();
    }

    public String serviceJoinName(HttpServletRequest request) {
        return request.getParameter("center");
    }

    public boolean serviceOverLappedId(HttpServletRequest request) {
        String id = request.getParameter("id");
        return memberDAO.overlappedId(id);
    }
    
    public void serviceInsertNaverMember(HttpServletRequest request) {
		//코드 넣을 곳
		
	}

    public void serviceInsertMember(HttpServletRequest request) throws ServletException, IOException {
        // 새로운 경로 설정: images/member/userProfiles 디렉토리
        String path = request.getServletContext().getRealPath("/images/member/userProfiles/");
        
        // 디렉토리 확인 후 없으면 생성
        File dir = new File(path);
        if (!dir.exists()) {
            dir.mkdirs(); // 디렉토리 생성
        }
        
        // 파일 업로드 처리
        int maxSize = 1024 * 1024 * 1024; // 최대 파일 크기 설정 (1GB)
        MultipartRequest multipartRequest = new MultipartRequest(request, path, maxSize, "UTF-8", new DefaultFileRenamePolicy());
        
        // 로그로 확인
        String id = multipartRequest.getParameter("id");
        String profileFileName = multipartRequest.getFilesystemName("profileFile");
        
        // id와 profile 값 확인
        System.out.println("id: " + id);

        // 회원 정보 처리
        MemberVO vo = new MemberVO(
            id,
            multipartRequest.getParameter("name"),
            multipartRequest.getParameter("nickname"),
            multipartRequest.getParameter("phone"),
            multipartRequest.getParameter("address"),
            profileFileName
        );
        
        // 회원 DB에 정보 저장
        memberDAO.insertMember(vo);
    }


    private synchronized void moveProfile(String path, String id, String fileName) throws IOException {
        if (fileName == null || fileName.isEmpty()) {
            // fileName이 null이거나 빈 값인 경우 처리
            System.out.println("Profile image file name is missing. Skipping file move.");
            return;  // 파일 이동을 하지 않고 메소드를 종료
        }

        synchronized (this) {
            File srcFile = new File(path + "\\" + fileName);
            File destDir = new File(path + "\\" + id);

            // 디렉토리가 없으면 생성
            if (!destDir.exists()) {
                destDir.mkdirs();
            }

            // 파일이 이미 존재하는지 확인
            File destFile = new File(destDir, fileName);
            if (destFile.exists()) {
                // 파일이 이미 존재하는 경우 처리
                System.out.println("File already exists: " + destFile.getAbsolutePath());
            } else {
                // 파일 이동
                FileUtils.moveToDirectory(srcFile, destDir, true);
            }
        }
    }

    public String serviceLoginMember() {
        return "members/login.jsp";
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
	public void addProfile(HttpRequest request){	
        
	}
}
