package Services;

import java.io.File;
import java.io.IOException;
import java.nio.file.FileSystems;
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
		
		String path = application.getRealPath(File.separator + "images");
		int maxSize = 1024 * 1024 * 1024;
		
		MultipartRequest multipartRequest = new MultipartRequest(request, path + File.separator + "temp", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());
		
		String fileName = multipartRequest.getOriginalFileName("thumbnail");
		
		String id = (String) request.getSession().getAttribute("userId");
		
		int type = Integer.parseInt(multipartRequest.getParameter("type"));
		
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
		
		String srcPath = path + File.separator + "temp";
		String destinationPath = path + File.separator + "community" + File.separator +
				"thumbnails" + File.separator + String.valueOf(no);
		
		FileIOController.moveFile(srcPath, destinationPath, fileName);
		
		return no;
	}

	public HashMap<String, Object> getCommunityShareMap(HttpServletRequest request) {

		String no = request.getParameter("no");
		
		return communitydao.selectCommunityShareMap(no);
	}

	public CommunityShareVO getCommunityShare(HttpServletRequest request) {
		
		String no = request.getParameter("no");
		
		return communitydao.selectCommunityShare(no);
	}

	public int processShareUpdate(HttpServletRequest request) throws ServletException, IOException {

		String id = (String) request.getSession().getAttribute("userId");
		
		ServletContext application = request.getServletContext();

		String path = application.getRealPath(File.separator + "images");
		int maxSize = 1024 * 1024 * 1024;

		MultipartRequest multipartRequest = new MultipartRequest(request, path + File.separator + "temp", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());
		
		String originThumbnail = multipartRequest.getParameter("originThumbnail");
		String thumbnail = multipartRequest.getOriginalFileName("thumbnail");

		int no = Integer.parseInt(multipartRequest.getParameter("no"));

		CommunityShareVO share = new CommunityShareVO(
				no, 
				id, 
				(thumbnail == null || thumbnail.equals("")) ? originThumbnail : thumbnail,
				multipartRequest.getParameter("title"), 
				multipartRequest.getParameter("contents"), 
				Double.parseDouble(multipartRequest.getParameter("lat")),
				Double.parseDouble(multipartRequest.getParameter("lng")),
				Integer.parseInt(multipartRequest.getParameter("type")),
				Integer.parseInt(multipartRequest.getParameter("views")));
		
		int result = communitydao.updateCommunityShare(share);
		
		if ((thumbnail != null && !thumbnail.equals(""))) {
			String srcPath = path + File.separator + "temp";
			String destinationPath = path + File.separator + "community" + File.separator +
					"thumbnails" + File.separator + String.valueOf(no);
			
			FileIOController.deleteFile(destinationPath, originThumbnail);
			FileIOController.moveFile(srcPath, destinationPath, thumbnail);
		}
		
		return result;
	}

	public int processShareDelete(HttpServletRequest request) {

		String no = (String) request.getParameter("no");
		
		int result = communitydao.deleteCommunityShare(no);
		
		if (result == 1) {
			String path = request.getServletContext().getRealPath(File.separator + "images") + 
					File.separator + "community" + File.separator + "thumbnails" + File.separator + no;
			FileIOController.deleteDirectory(path);
		}
		
		return result;
	} 
}
