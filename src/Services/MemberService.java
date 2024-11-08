package Services;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;

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

	public void serviceInsertMember(HttpServletRequest request) {

		try {
			String saveDir = "";
			MultipartRequest multipartRequest = new MultipartRequest(request, saveDir);

			String user_id = multipartRequest.getParameter("id");
			String user_name = multipartRequest.getParameter("name");
			String user_nickname = multipartRequest.getParameter("nickname");
			String user_phone = multipartRequest.getParameter("phone");
			String user_address = multipartRequest.getParameter("address");
			String user_profile = multipartRequest.getParameter("profile");
			
			System.out.println(user_id + "/" + user_name + "/" + user_nickname + "/" + user_phone  + "/" + user_address + "/" + user_profile );

			
			MemberVO vo = new MemberVO(user_id, user_name, user_nickname, user_phone, user_address, user_profile);
			memberDAO.insertMember(vo);
		}
		
		catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
