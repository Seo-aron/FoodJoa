package Services;

import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import DAOs.CommunityDAO;
import VOs.CommunityVO;

public class CommunityService {

		CommunityDAO communitydao;
	
	public CommunityService() {
		
		communitydao = new CommunityDAO();
		
	}

	public ArrayList<CommunityVO> getCommunityList() {
		
		return communitydao.communityListAll();
	}
	
	public void insertCommunity(HttpServletRequest request) {
		
		CommunityVO communityVO = new CommunityVO();
	
		String id = "admin";
		String title = request.getParameter("title");
		String contents = request.getParameter("contents");
		
		communityVO.setId(id);
		communityVO.setTitle(title);
		communityVO.setContents(contents);
		
		communitydao.insertCommunity(communityVO);
		
	}

	public CommunityVO openCommunityRead(String no) {
		
		return communitydao.readCommunity(no);
	}

	public int updateCommunity(HttpServletRequest request) {
		
		CommunityVO vo = new CommunityVO(
				Integer.parseInt(request.getParameter("no")),
				request.getParameter("id"),
				request.getParameter("title"),
				request.getParameter("contents"),
				Integer.parseInt(request.getParameter("views")));
		
		int result = communitydao.updateCommunity(vo);
		
		return result;
	}

	public int deleteCommunity(HttpServletRequest request) {
		
		int result = communitydao.deleteCommunity(request.getParameter("no"));
		
		return result;
	}
}
