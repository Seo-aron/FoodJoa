package Services;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import Common.FileIOController;
import Common.StringParser;
import DAOs.MealkitDAO;
import VOs.MealkitOrderVO;
import VOs.MealkitReviewVO;
import VOs.MealkitVO;

public class MealkitService {
	
	private MealkitDAO mealkitDAO;
	private PrintWriter printWriter;
	
	public MealkitService() {
		
		mealkitDAO = new MealkitDAO();
	}
	
	public ArrayList<MealkitVO> getMealkitsList() {
		
		return mealkitDAO.selectMealkits();
	}

	public MealkitVO getMealkitInfo(HttpServletRequest request) {
		
		int no = Integer.parseInt(request.getParameter("no"));
		
		mealkitDAO.incrementViewCount(no);
		
		return mealkitDAO.InfoMealkit(no);
	}

	public ArrayList<MealkitReviewVO> getReviewInfo(HttpServletRequest request) {
		
		int no = Integer.parseInt(request.getParameter("no"));
		
		return mealkitDAO.InfoReview(no);
	}

	public void setMyMealkit(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		int no = Integer.parseInt(request.getParameter("no"));
		int type = Integer.parseInt(request.getParameter("type"));
		
		int result = mealkitDAO.addMyMealkit(no, type);
		
		
		String res = String.valueOf(result);

		printWriter = response.getWriter();
		printWriter.print(res);
		printWriter.flush();
		printWriter.close();
		
		return;
	}

	public void setWriteMealkit(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {

	    // 서버의 실제 경로를 가져옴
	    ServletContext application = request.getServletContext();
	    String path = application.getRealPath("/images/"); // 업로드된 파일이 저장될 기본 경로
	    int maxSize = 1024 * 1024 * 1024;
	    
	    // MultipartRequest로 파일 업로드 처리
	    MultipartRequest multipartRequest = new MultipartRequest(request, path + "temp/", maxSize, "UTF-8",
	            new DefaultFileRenamePolicy());

	    String id = multipartRequest.getParameter("id");
	    String title = multipartRequest.getParameter("title");
	    String pictures = multipartRequest.getParameter("pictures");
	    String contents = multipartRequest.getParameter("contents");
	    int category = Integer.parseInt(multipartRequest.getParameter("category"));
	    String price = multipartRequest.getParameter("price");
	    int stock = Integer.parseInt(multipartRequest.getParameter("stock"));
	    String orders = multipartRequest.getParameter("orders");
	    String origin = multipartRequest.getParameter("origin");        

	    List<String> fileNames = StringParser.splitString(pictures);
	    
	    String allPictures = String.join(",", fileNames);

	    System.out.println("pictures : " + allPictures);
	    
	    MealkitVO vo = new MealkitVO();
	    vo.setId(id);
	    vo.setTitle(title);
	    vo.setPictures(allPictures);
	    vo.setContents(contents);
	    vo.setCategory(category);
	    vo.setPrice(price);
	    vo.setStock(stock);
	    vo.setOrders(orders);
	    vo.setOrigin(origin);

	    int no = mealkitDAO.insertNewContent(vo);
	    
        for(String fileName : fileNames) {
    		
    		String srcPath = path + "temp" + File.separator;
    	    String destinationPath = path + "mealkit" + File.separator + "thumbnails" + File.separator + no + File.separator + id;
    		
    		FileIOController.moveProfile(srcPath, destinationPath, fileName);
        }
		
	    PrintWriter printWriter = response.getWriter();
	    if (no > 0) {
	        printWriter.print(no);
	    } else {
	        printWriter.print(no);
	    }

	    printWriter.close();
	}

	public void setWriteReview(HttpServletRequest request, HttpServletResponse response) throws IOException {

	    ServletContext application = request.getServletContext();
	    
	    String path = application.getRealPath("/images/");
	    int maxSize = 1024 * 1024 * 1024;

	    MultipartRequest multipartRequest = new MultipartRequest(request, path + "temp/", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());
	    
	    String fileName = multipartRequest.getOriginalFileName("pictures");

	    int no = Integer.parseInt(multipartRequest.getParameter("mealkit_no"));
	    String id = multipartRequest.getParameter("id");
	    String contents = multipartRequest.getParameter("contents");
	    int rating = Integer.parseInt(multipartRequest.getParameter("rating"));

	    MealkitReviewVO vo = new MealkitReviewVO();
	    vo.setId(id);
	    vo.setMealkitNo(no);
	    vo.setContents(contents);
	    vo.setRating(rating);
	    vo.setPictures(fileName);

	    int reviewNo = mealkitDAO.insertNewReview(vo);
	    
	    String srcPath = path + "\\temp\\";
		String destinationPath = path + "\\mealkit\\reviews\\" + String.valueOf(reviewNo);
		
		FileIOController.moveProfile(srcPath, destinationPath, fileName);
		

	    System.out.println("사진이름" + vo.getPictures());
	    
	    PrintWriter printWriter = response.getWriter();
	    if (reviewNo > 0) {
	    	String contextPath = request.getContextPath();
	    	
	        printWriter.println("<script>");
	        printWriter.println("alert('리뷰가 작성되었습니다.');");
	        printWriter.println("location.href='" + contextPath + "/Mealkit/info?no=" + no + "';");
	        printWriter.println("</script>");
	        printWriter.close();
	    } else {
	        printWriter.println("<script>");
	        printWriter.println("alert('리뷰 작성에 실패했습니다.');");
	        printWriter.println("</script>");
	        printWriter.close();
	    }
	}

	public void setPlusEmpathy(HttpServletRequest request, HttpServletResponse response) throws IOException {

		int empathyCount = Integer.parseInt(request.getParameter("empathyCount"));
		int mealkit_no = Integer.parseInt(request.getParameter("mealkit_no"));
		int no = Integer.parseInt(request.getParameter("no"));
			
		int result = mealkitDAO.updateEmpathy(empathyCount, mealkit_no, no);

		printWriter = response.getWriter();

		String go = String.valueOf(result);
		
		printWriter.print(go);

	}

	public void delMealkit(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		int no = Integer.parseInt(request.getParameter("no"));
		
		int result = mealkitDAO.deleteMealkit(no);
		
	    PrintWriter printWriter = response.getWriter();
	    if (result > 0) {
	        printWriter.print("1");
	    } else {
	        printWriter.print("0");
	    }
	}

	public void updateMealkit(HttpServletRequest request, HttpServletResponse response) throws IOException {
	    ServletContext application = request.getServletContext();
	    
	    String path = application.getRealPath("/images/");
	    int maxSize = 1024 * 1024 * 1024;
	    
	    MultipartRequest multipartRequest = new MultipartRequest(request, path + "temp/", maxSize, "UTF-8",
	            new DefaultFileRenamePolicy());

	    String originFileName = multipartRequest.getParameter("thumbnail-origin");
		String fileName = multipartRequest.getOriginalFileName("file");
	    
	    int no = Integer.parseInt(multipartRequest.getParameter("no"));
	    String id = multipartRequest.getParameter("id");
	    String title = multipartRequest.getParameter("title");
	    String pictures = multipartRequest.getParameter("pictures");
	    String contents = multipartRequest.getParameter("contents");
	    String price = multipartRequest.getParameter("price");
	    String origin = multipartRequest.getParameter("origin");
	    String orders = multipartRequest.getParameter("orders");
	    int stock = Integer.parseInt(multipartRequest.getParameter("stock"));

	    MealkitVO vo = new MealkitVO();
	    vo.setNo(no);
	    vo.setId(id);
	    vo.setTitle(title);
	    vo.setPictures(pictures);
	    vo.setContents(contents);
	    vo.setPrice(price);
	    vo.setStock(stock);
	    vo.setOrders(orders);
	    vo.setOrigin(origin);
	    
	    MealkitVO mealkitvo = mealkitDAO.getMealkitByNo(no);

	    no = mealkitDAO.updateMealkit(vo);

	    List<String> fileNames = StringParser.splitString(pictures);
        
        for(String file : fileNames) {
        	if (fileName != null && !fileName.equals("")) {
        		String srcPath = path + "\\temp\\";
	    		String destinationPath = path + "\\mealkit\\thumbnails\\" + String.valueOf(no) + "\\" + id;
			
	    		FileIOController.deleteFile(destinationPath, originFileName);
    			FileIOController.moveProfile(srcPath, destinationPath, file);	 		
        	}
    	}

	}

	public Map<Integer, Float> getAllRatingAvr(ArrayList<MealkitVO> mealkits) {
		Map<Integer, Float> ratingMap = new HashMap<>();
		
		for(MealkitVO mealkit : mealkits) {
			int no = mealkit.getNo();
			float ratingAvr = mealkitDAO.getRatingAvr(no);
			
			ratingMap.put(no, ratingAvr);
		}
		
		return ratingMap;
	}

	public float getRatingAvr(MealkitVO mealkitvo) {
		int no = mealkitvo.getNo();
		float ratingAvr = mealkitDAO.getRatingAvr(no);
		
		return ratingAvr;
	}

	public ArrayList<MealkitVO> searchList(HttpServletRequest request) {
		
		String key = request.getParameter("key");
		String word = request.getParameter("word");
		
		return mealkitDAO.selectSearchList(key, word);
	}
}
