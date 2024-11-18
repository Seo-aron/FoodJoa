package Services;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

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

	    synchronized (this) {
	        String fileSeparator = File.separator; // 현재 운영 체제에 맞는 경로 구분자
	        File srcFile = new File(srcPath + fileSeparator + fileName);
	        File destDir = new File(destinationPath);

	        if (!destDir.exists()) {
	            destDir.mkdirs();
	        }

	        File destFile = new File(destDir, fileName);
	        if (destFile.exists()) {
	            System.out.println("File already exists: " + destFile.getAbsolutePath());
	        } else {
	            FileUtils.moveToDirectory(srcFile, destDir, true); // 파일 이동
	        }
	    }
	}

	public ArrayList<MealkitVO> getMealkitsList() {
		
		return mealkitDAO.selectMealkits();
	}

	public MealkitVO getMealkitInfo(HttpServletRequest request) {
		
		int no = Integer.parseInt(request.getParameter("no"));
		
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

	    int result = mealkitDAO.insertNewContent(vo);

	    // 파일 이동: 임시 디렉토리에서 실제 디렉토리로 이동
	    String srcPath = path + "/temp/";
	    String destinationPath = path + "/mealkit/thumbnails/" + String.valueOf(vo.getNo());

	    for (String fileName : uploadedFileNames) {
	        moveProfile(srcPath, destinationPath, fileName);
	    }

	    PrintWriter printWriter = response.getWriter();
	    if (result > 0) {
	        printWriter.print("1");
	    } else {
	        printWriter.print("0");
	    }

	    printWriter.close();
	}


	public void setWriteReview(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		String id = request.getParameter("id");
		int mealkit_no =  Integer.parseInt(request.getParameter("mealkit_no"));
		String contents = request.getParameter("contents");	
		String pictures = request.getParameter("pictures");
		int rating = Integer.parseInt(request.getParameter("rating"));
		
		MealkitReviewVO vo = new MealkitReviewVO();
		vo.setId(id);
		vo.setMealkitNo(mealkit_no);
		vo.setContents(contents);
		vo.setPictures(pictures);
		vo.setRating(rating);
		
		int result = mealkitDAO.insertNewReview(vo);
		System.out.println(result);
		if(result == 1) {
			printWriter = response.getWriter();
			printWriter.println("<script>");
			printWriter.println("alert('리뷰가 작성되었습니다.');");
			printWriter.println("location.href='/FoodJoa/Mealkit/info?no=" + mealkit_no + "';");
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

}
