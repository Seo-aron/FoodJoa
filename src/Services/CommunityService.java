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
	
	
	
	
}
