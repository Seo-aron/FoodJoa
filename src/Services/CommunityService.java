package Services;

import java.util.ArrayList;

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
	
	
	
	
}
