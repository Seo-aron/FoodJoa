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

	public void serviceInsertMember(HttpServletRequest request) 
			throws ServletException, IOException  {
		
		ServletContext application = request.getServletContext();
		
		String path = application.getRealPath("/images/");
		int maxSize = 1024 * 1024 * 1024;
		
		MultipartRequest multipartRequest = new MultipartRequest(request, path + "temp/", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());

		String id = multipartRequest.getParameter("id");
		String fileName = multipartRequest.getParameter("profile");
		
		MemberVO vo = new MemberVO(
				id, 
				multipartRequest.getParameter("name"), 
				multipartRequest.getParameter("nickname"), 
				multipartRequest.getParameter("phone"), 
				multipartRequest.getParameter("address"), 
				fileName);
		
		memberDAO.insertMember(vo);
		
		moveProfile(path, id, fileName);
	}
	
	private synchronized void moveProfile(String path, String id, String fileName) throws IOException {
		
		synchronized (this) {
			if (fileName != null && fileName.length() != 0) {
				File srcFile = new File(path + "\\temp\\" + fileName);
				File destDir = new File(path + "\\member\\userProfiles\\" + id);
				
				if (!destDir.exists())
					destDir.mkdirs();
				
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
}
