package Services;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

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
		String user_id = request.getParameter("id");
		String user_name = request.getParameter("name");
		String user_nickname = request.getParameter("nickname");
		String user_phone = request.getParameter("phone");
		String user_address = request.getParameter("address");
		String user_profile = request.getParameter("profile");

		MemberVO vo = new MemberVO(user_id, user_name, user_nickname, user_phone, user_address, user_profile);
		memberDAO.insertMember(vo);
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
