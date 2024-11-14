package Services;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
		
		String id = request.getParameter("id");
		String title = request.getParameter("title");
		String contents = request.getParameter("contents");	
		int category = Integer.parseInt(request.getParameter("category"));
		String price = request.getParameter("price");
		int stock = Integer.parseInt(request.getParameter("stock"));
		String pictures = request.getParameter("pictures");
		String orders = request.getParameter("orders");
		String origin = request.getParameter("origin");
		
		MealkitVO vo = new MealkitVO();
		vo.setId(id);
		vo.setTitle(title);
		vo.setContents(contents);
		vo.setCategory(category);
		vo.setPrice(price);
		vo.setStock(stock);
		vo.setPictures(pictures);
		vo.setOrders(orders);
		vo.setOrigin(origin);
		
		int result = mealkitDAO.insertNewContent(vo);
		
		request.setAttribute("result", result);
		
		RequestDispatcher dispatcher = request.getRequestDispatcher("/write.pro");
		dispatcher.forward(request, response);
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

}
