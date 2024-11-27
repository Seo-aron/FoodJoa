package Services;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import Common.FileIOController;
import Common.StringParser;
import DAOs.MealkitDAO;
import VOs.MealkitReviewVO;
import VOs.MealkitVO;

public class MealkitService {
	
	private MealkitDAO mealkitDAO;
	private PrintWriter printWriter;
	
	public MealkitService() {
		
		mealkitDAO = new MealkitDAO();
	}
	
	public ArrayList<Map<String, Object>> getMealkitsList() {
		
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

	public void setWishMealkit(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		int no = Integer.parseInt(request.getParameter("no"));
		String id = (String) request.getSession().getAttribute("userId");
		int type = Integer.parseInt(request.getParameter("type"));
		
		int result = mealkitDAO.insertMealkitWishlist(no, id, type);
		
		String res = String.valueOf(result);

		printWriter = response.getWriter();
		printWriter.print(res);
		printWriter.flush();
		printWriter.close();
		
		return;
	}

	public void setWriteMealkit(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {

		ServletContext application = request.getServletContext();

		String path = application.getRealPath(File.separator + "images");
		int maxSize = 1024 * 1024 * 1024;

		MultipartRequest multipartRequest = new MultipartRequest(request, path + File.separator + "temp", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());
	    
	    String id = (String) request.getSession().getAttribute("userId");
	    String title = multipartRequest.getParameter("title");
	    String pictures = multipartRequest.getParameter("pictures");
	    String contents = multipartRequest.getParameter("contents");
	    int category = Integer.parseInt(multipartRequest.getParameter("category"));
	    String price = multipartRequest.getParameter("price");
	    int stock = Integer.parseInt(multipartRequest.getParameter("stock"));
	    String orders = multipartRequest.getParameter("orders");
	    String origin = multipartRequest.getParameter("origin");        

	    MealkitVO vo = new MealkitVO();
	    vo.setId(id);
	    vo.setTitle(title);
	    vo.setPictures(pictures);
	    vo.setContents(contents);
	    vo.setCategory(category);
	    vo.setPrice(price);
	    vo.setStock(stock);
	    vo.setOrders(orders);
	    vo.setOrigin(origin);

	    int no = mealkitDAO.insertNewContent(vo);

	    List<String> fileNames = StringParser.splitString(pictures);
	    
        for(String fileName : fileNames) {
    		
    		String srcPath = path + File.separator + "temp" + File.separator;
    	    String destinationPath = path + File.separator + "mealkit" + File.separator + "thumbnails" + File.separator + no + File.separator + id;
    		
    		FileIOController.moveFile(srcPath, destinationPath, fileName);
        }

	    String bytePictures = multipartRequest.getParameter("pictures");
	    System.out.println("setWriteMealkit - bytePictures: " + bytePictures);

	    response.setContentType("application/json;charset=UTF-8");
	    PrintWriter printWriter = response.getWriter();
	    if (no > 0) {
	    	String jsonResponse = String.format("{\"no\": %d, \"bytePictures\": \"%s\"}", no, bytePictures);
	        printWriter.print(jsonResponse);
	    	
	        // printWriter.print(no);
		    
	        // RequestDispatcher dispatcher = request.getRequestDispatcher("mealkits/editBoard.jsp");
	    	// dispatcher.forward(request, response);
	    } else {
	    	printWriter.print("{\"no\": 0, \"error\": \"글 작성에 실패했습니다.\"}");
	    	
	        // printWriter.print(no);
	    }

	    printWriter.close();
	}

	public void setWriteReview(HttpServletRequest request, HttpServletResponse response) throws IOException {

		ServletContext application = request.getServletContext();

		String path = application.getRealPath(File.separator + "images");
		int maxSize = 1024 * 1024 * 1024;

		MultipartRequest multipartRequest = new MultipartRequest(request, path + File.separator + "temp", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());
	    
	    String fileName = multipartRequest.getOriginalFileName("pictures");

	    int no = Integer.parseInt(multipartRequest.getParameter("mealkit_no"));
	    String id = (String) request.getSession().getAttribute("userId");
	    String contents = multipartRequest.getParameter("contents");
	    int rating = Integer.parseInt(multipartRequest.getParameter("rating"));

	    MealkitReviewVO vo = new MealkitReviewVO();
	    vo.setId(id);
	    vo.setMealkitNo(no);
	    vo.setContents(contents);
	    vo.setRating(rating);
	    vo.setPictures(fileName);

	    int reviewNo = mealkitDAO.insertNewReview(vo);

		String srcPath = path + File.separator + "temp" + File.separator;
		String destinationPath = path + File.separator + "mealkit" + File.separator +
				"reviews" + File.separator + String.valueOf(reviewNo) + File.separator + id;
		
		FileIOController.moveFile(srcPath, destinationPath, fileName);
		

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
		printWriter.close();
	}

	public void updateMealkit(HttpServletRequest request, HttpServletResponse response) throws IOException {

		ServletContext application = request.getServletContext();

		String path = application.getRealPath(File.separator + "images");
		int maxSize = 1024 * 1024 * 1024;

		MultipartRequest multipartRequest = new MultipartRequest(request, path + File.separator + "temp", maxSize, "UTF-8",
				new DefaultFileRenamePolicy());

	    String originFileName = multipartRequest.getParameter("thumbnail-origin");
		String fileName = multipartRequest.getOriginalFileName("file");
	    
	    int no = Integer.parseInt(multipartRequest.getParameter("no"));
	    String id = (String) request.getSession().getAttribute("userId");
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

	    mealkitDAO.updateMealkit(vo);

	    List<String> fileNames = StringParser.splitString(pictures);
	    
	    String srcPath = path + File.separator + "temp" + File.separator;
		String destinationPath = path + File.separator + "mealkit" + File.separator +
				"thumbnails" + File.separator + String.valueOf(no) + File.separator + id;
		
		if (fileName != null && !fileName.equals("")) {
		    if (originFileName != null && !originFileName.equals("")) {
		        FileIOController.deleteFile(destinationPath, originFileName);
		    }
		    FileIOController.moveFile(srcPath, destinationPath, fileName);
		}
		
		for (String file : fileNames) {
		    if (file != null && !file.equals("")) {
		        FileIOController.moveFile(srcPath, destinationPath, file);
		    }
		}
		
		PrintWriter printWriter = response.getWriter();
		printWriter.println(no);
		printWriter.close();
	}

	public Map<Integer, Float> getAllRatingAvr(ArrayList<Map<String, Object>> mealkits) {
	    Map<Integer, Float> ratingMap = new HashMap<>();
	    
	    for (Map<String, Object> mealkit : mealkits) {
	        int no = (int) mealkit.get("no");
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

	public String getBytePicturesParser(HttpServletRequest request) {

		String bytePictures = request.getParameter("bytePictures");
		
		List<String> fileNames = StringParser.splitString(bytePictures);
	    
	    String updatePictures = String.join(",", fileNames);
		
	    System.out.println("getBytePicures(service) : " + updatePictures);
	    
		return updatePictures;
	}

	public void buyMealkit(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
	    String id = (String) request.getSession().getAttribute("userId");
	    int mealkitNo = Integer.parseInt(request.getParameter("mealkitNo"));
	    int quantity = Integer.parseInt(request.getParameter("quantity"));
	    int delivered = Integer.parseInt(request.getParameter("delivered"));
	    int refund = Integer.parseInt(request.getParameter("refund"));

	    boolean result = mealkitDAO.saveOrder(id, mealkitNo, quantity, delivered, refund);
	    PrintWriter out = response.getWriter();
	    out.print(result);
	    out.close();
	}

}
