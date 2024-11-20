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
	
	private synchronized void moveProfile(String srcPath, String destinationPath, String fileName) throws IOException {
	    if (fileName == null || fileName.isEmpty()) return;

	    String fileSeparator = File.separator;
	    File srcFile = new File(srcPath + fileSeparator + fileName);
	    File destDir = new File(destinationPath);

	    // 대상 디렉토리가 존재하지 않으면 생성
	    if (!destDir.exists()) {
	        destDir.mkdirs();
	    }

	    File destFile = new File(destDir, fileName);
	    if (destFile.exists()) {
	        System.out.println("파일이 이미 대상 디렉토리에 존재합니다: " + destFile.getAbsolutePath());
	    } else {
	        if (srcFile.exists()) {
	            // 파일 이동
	            FileUtils.moveToDirectory(srcFile, destDir, true);
	            System.out.println("파일이 성공적으로 이동되었습니다: " + destFile.getAbsolutePath());
	        } else {
	            System.out.println("원본 파일이 존재하지 않습니다: " + srcFile.getAbsolutePath());
	        }
	    }
	}

	// 경로가 없으면 디렉토리를 생성하는 메서드
	private void createDirectoryIfNotExists(String path) {
	    File directory = new File(path);
	    if (!directory.exists()) {
	        if (directory.mkdirs()) {
	            System.out.println("폴더 생성 성공: " + path);
	        } else {
	            System.out.println("폴더 생성 실패: " + path);
	        }
	    }
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

	    // 임시 디렉토리와 저장 디렉토리 경로 생성
	    String tempPath = path + "temp/";
	    String destinationBasePath = path + "mealkit/thumbnails/";

	    // 디렉토리 생성 로직
	    createDirectoryIfNotExists(tempPath);
	    createDirectoryIfNotExists(destinationBasePath);

	    // MultipartRequest로 파일 업로드 처리
	    MultipartRequest multipartRequest = new MultipartRequest(request, tempPath, maxSize, "UTF-8",
	            new DefaultFileRenamePolicy());

	    // 업로드된 파일 이름을 가져옴
	    List<String> uploadedFileNames = new ArrayList<>();

	    // MultipartRequest의 fileNames() 메서드를 사용해 업로드된 파일들을 가져오기
	    Enumeration<?> fileNames = multipartRequest.getFileNames();
	    while (fileNames.hasMoreElements()) {
	        String inputName = (String) fileNames.nextElement(); // input 태그의 name 속성
	        String uploadedFileName = multipartRequest.getFilesystemName(inputName); // 저장된 파일 이름
	        if (uploadedFileName != null) {
	            uploadedFileNames.add(uploadedFileName);
	        }
	    }

	    String id = multipartRequest.getParameter("id");
	    String title = multipartRequest.getParameter("title");
	    String contents = multipartRequest.getParameter("contents");
	    int category = Integer.parseInt(multipartRequest.getParameter("category"));
	    String price = multipartRequest.getParameter("price");
	    int stock = Integer.parseInt(multipartRequest.getParameter("stock"));
	    String orders = multipartRequest.getParameter("orders");
	    String origin = multipartRequest.getParameter("origin");

	    MealkitVO vo = new MealkitVO();
	    vo.setId(id);
	    vo.setTitle(title);
	    vo.setContents(contents);
	    vo.setCategory(category);
	    vo.setPrice(price);
	    vo.setStock(stock);
	    vo.setOrders(orders);
	    vo.setOrigin(origin);

	    if (!uploadedFileNames.isEmpty()) {
	        String pictures = String.join(",", uploadedFileNames);
	        vo.setPictures(pictures); // MealkitVO에 파일 이름 설정
	    } else {
	        vo.setPictures(null); // 파일이 업로드되지 않은 경우
	    }

	    int no = mealkitDAO.insertNewContent(vo);

	    // 파일 이동: 임시 디렉토리에서 실제 디렉토리로 이동
	    String destinationPath = destinationBasePath + String.valueOf(no);
	    createDirectoryIfNotExists(destinationPath); // 이동할 디렉토리가 없으면 생성

	    for (String fileName : uploadedFileNames) {
	        moveProfile(tempPath, destinationPath, fileName);
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
	    String path = application.getRealPath("/images/mealkit/");
	    int maxSize = 1024 * 1024 * 10;

	    String tempPath = path + "temp/";
	    createDirectoryIfNotExists(tempPath);
	    
	    MultipartRequest multipartRequest = new MultipartRequest(request, tempPath, maxSize, "UTF-8", new DefaultFileRenamePolicy());

	    String uploadedFileName = multipartRequest.getFilesystemName("pictures");
	    String finalPicturePath = null;

	    int no = Integer.parseInt(multipartRequest.getParameter("mealkit_no"));
	    String id = multipartRequest.getParameter("id");
	    String contents = multipartRequest.getParameter("contents");
	    int rating = Integer.parseInt(multipartRequest.getParameter("rating"));

	    MealkitReviewVO vo = new MealkitReviewVO();
	    vo.setId(id);
	    vo.setMealkitNo(no);
	    vo.setContents(contents);
	    vo.setRating(rating);
	    vo.setPictures(uploadedFileName);

	    int review_no = mealkitDAO.insertNewReview(vo);
	    
	    if (uploadedFileName != null) {
	        String destinationPath = path + "review" + "/" + review_no + "/";
	        createDirectoryIfNotExists(destinationPath);

	        moveProfile(tempPath, destinationPath, uploadedFileName);
	        finalPicturePath = "review" + "/" + review_no + "/" + uploadedFileName;
	    }

	    System.out.println("사진이름" + vo.getPictures());
	    
	    PrintWriter printWriter = response.getWriter();
	    if (review_no > 0) {
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
	    
	    String srcPath = path + "/temp/";

	    createDirectoryIfNotExists(srcPath);
	    
	    MultipartRequest multipartRequest = new MultipartRequest(request, path + "temp/", maxSize, "UTF-8",
	            new DefaultFileRenamePolicy());

	    List<String> uploadedFileNames = new ArrayList<>();
	    Enumeration<?> fileNames = multipartRequest.getFileNames();
	    while (fileNames.hasMoreElements()) {
	        String inputName = (String) fileNames.nextElement();
	        String uploadedFileName = multipartRequest.getFilesystemName(inputName);
	        if (uploadedFileName != null) {
	            uploadedFileNames.add(uploadedFileName);
	        } else {
	            System.out.println("파일 업로드 실패: " + inputName);
	        }
	    }

	    int no = Integer.parseInt(multipartRequest.getParameter("no"));
	    String title = multipartRequest.getParameter("title");
	    String contents = multipartRequest.getParameter("contents");
	    String price = multipartRequest.getParameter("price");
	    String origin = multipartRequest.getParameter("origin");
	    String orders = multipartRequest.getParameter("orders");
	    int stock = Integer.parseInt(multipartRequest.getParameter("stock"));

	    MealkitVO vo = new MealkitVO();
	    vo.setNo(no);
	    vo.setTitle(title);
	    vo.setContents(contents);
	    vo.setPrice(price);
	    vo.setStock(stock);
	    vo.setOrders(orders);
	    vo.setOrigin(origin);
	    
	    MealkitVO mealkitvo = mealkitDAO.getMealkitByNo(no);
	    vo.setPictures(mealkitvo.getPictures());

	    if (!uploadedFileNames.isEmpty()) {
	        String pictures = String.join(",", uploadedFileNames);
	        vo.setPictures(pictures);
	    } else {
	        vo.setPictures(mealkitvo.getPictures());
	    }

	    no = mealkitDAO.updateMealkit(vo);

	    String destinationPath = path + "/mealkit/thumbnails/" + no;
	    
	    for (String fileName : uploadedFileNames) {
	        File srcFile = new File(srcPath + fileName);
	        if (srcFile.exists()) {
	            moveProfile(srcPath, destinationPath, fileName);
	        } else {
	            System.out.println("파일 이동 실패: " + fileName);
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
