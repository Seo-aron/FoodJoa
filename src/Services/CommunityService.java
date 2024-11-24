package Services;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import Common.FileIOController;
import DAOs.CommunityDAO;
import VOs.CommunityShareVO;
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

	public ArrayList<CommunityVO> processCommunitySearch(String key, String word) {

		return communitydao.communityList(key, word);
	}

	public ArrayList<HashMap<String, Object>> getShareList() {
		return communitydao.selectCommunityShareList();
	}
	
	public ArrayList<HashMap<String, Object>> getSearchedShareList(String key, String word) {
		return communitydao.selectSearchedShareList(key, word);
	}

	public int insertCommunityShare(HttpServletRequest request) throws ServletException, IOException {
		
		ServletContext application = request.getServletContext();
		
		String path = application.getRealPath("/images/");
		int maxSize = 1024 * 1024 * 1024;
		
		MultipartRequest multipartRequest = new MultipartRequest(request, path + "temp/", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());
		
		String fileName = multipartRequest.getOriginalFileName("thumbnail");
		
		String id = (String) request.getSession().getAttribute("userId");
		
		int type = multipartRequest.getParameter("type").equals("food") ? 0 : 1;
		
		CommunityShareVO share = new CommunityShareVO(
				id,
				fileName,
				multipartRequest.getParameter("title"),
				multipartRequest.getParameter("contents"), 
				Double.parseDouble(multipartRequest.getParameter("lat")), 
				Double.parseDouble(multipartRequest.getParameter("lng")), 
				type, 
				0);
		
		int no = communitydao.selectNoInsertedShare(share);
		
		String srcPath = path + "\\temp\\";
		String destinationPath = path + "\\community\\thumbnails\\" + String.valueOf(no);
		
		FileIOController.moveProfile(srcPath, destinationPath, fileName);
		
		return no;
	} 
}
