package Controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import Services.MealkitService;
import VOs.MealkitOrderVO;
import VOs.MealkitReviewVO;
import VOs.MealkitVO;

@WebServlet("/Mealkit/*")
public class MealkitController extends HttpServlet {

	private MealkitService mealkitService;
	private PrintWriter printWriter;
	private String nextPage;

	@Override
	public void init() throws ServletException {
		mealkitService = new MealkitService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doHandle(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doHandle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=UTF-8");

		String action = request.getPathInfo();

		switch (action) {
		case "/list": openMealkitView(request, response); break;
		case "/info": openMealkitInfoView(request, response); break;
		case "/wish.pro": processWishMealkit(request, response); return;
		case "/write": openAddMealkit(request, response); break;
		case "/write.pro": processAddMealkit(request, response); return;
		case "/reviewwrite": openAddReview(request, response); break;
		case "/reviewwrite.pro": processAddReview(request, response); return;
		case "/empathy.pro": processEmpathy(request, response); return;
		case "/delete.pro": processDelete(request, response); return;
		case "/update": openUpdateBoard(request, response); break;
		case "/update.pro": processUpdate(request, response); return;
		case "/searchlist.pro": processSearchList(request, response); break;
		case "/buyMealkit.pro": processBuyMealkit(request, response); return;

		default: break;
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
	}

	private void processBuyMealkit(HttpServletRequest request, HttpServletResponse response) throws IOException {
		mealkitService.buyMealkit(request, response);
	}

	private void processSearchList(HttpServletRequest request, HttpServletResponse response) {
		ArrayList<MealkitVO> list = mealkitService.searchList(request);

		request.setAttribute("mealkitList", list);
		request.setAttribute("center", "mealkits/list.jsp");

		nextPage = "/main.jsp";
	}

	private void openUpdateBoard(HttpServletRequest request, HttpServletResponse response) {
		MealkitVO mealkitvo = mealkitService.getMealkitInfo(request);
		//String updatePictures = mealkitService.getBytePicturesParser(request);
		
		// String bytePictures = request.getParameter("bytePictures");
		
		// System.out.println("getBytePicures(controller) : " + updatePictures);
		// System.out.println("getBytePicures(controller) : " + bytePictures);
		
		request.setAttribute("mealkitvo", mealkitvo);
		//request.setAttribute("updatePictures", updatePictures);	// 파일명
		// request.setAttribute("bytePictures", bytePictures);		// 0000파일명
		request.setAttribute("center", "mealkits/editBoard.jsp");
		
		nextPage = "/main.jsp";
	}

	private void processUpdate(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		mealkitService.updateMealkit(request, response);
	}

	private void processDelete(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		mealkitService.delMealkit(request, response);
	}

	private void processEmpathy(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		mealkitService.setPlusEmpathy(request, response);
	}

	private void openAddReview(HttpServletRequest request, HttpServletResponse response) {
		
		MealkitVO mealkit = mealkitService.getMealkit(request);
	    
	    request.setAttribute("mealkit", mealkit);
		request.setAttribute("center", "mealkits/reviewWrite.jsp");
		
		nextPage = "/main.jsp";
	}

	private void processAddReview(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		mealkitService.setWriteReview(request, response);
	}

	private void processAddMealkit(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		mealkitService.setWriteMealkit(request, response);
	}

	private void openAddMealkit(HttpServletRequest request, HttpServletResponse response) {
		// 추후 membervo에서 멤버 아이디를 session으로 받아와야 할 거임 
		request.setAttribute("center", "mealkits/write.jsp");
		
		nextPage = "/main.jsp";
	}

	private void processWishMealkit(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException{
		mealkitService.setWishMealkit(request, response);
	}
	
	private void openMealkitInfoView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		MealkitVO mealkitvo = mealkitService.getMealkitInfo(request);
		ArrayList<MealkitReviewVO> reviewvo = mealkitService.getReviewInfo(request);
		float ratingAvr = mealkitService.getRatingAvr(mealkitvo);
		
		request.setAttribute("mealkitvo", mealkitvo);
		request.setAttribute("reviewvo", reviewvo);
		request.setAttribute("ratingAvr", ratingAvr);
		
		request.setAttribute("center", "mealkits/info.jsp");

		nextPage = "/main.jsp";
	}

	private void openMealkitView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		ArrayList<MealkitVO> mealkits = mealkitService.getMealkitsList();
		Map<Integer, Float> ratingAvr = mealkitService.getAllRatingAvr(mealkits);
		
		String nowPage = request.getParameter("nowPage");
		String nowBlock = request.getParameter("nowBlock");

		request.setAttribute("mealkitList", mealkits);
		request.setAttribute("ratingAvr", ratingAvr);
		request.setAttribute("center", "mealkits/list.jsp");
		request.setAttribute("nowPage", nowPage);
		request.setAttribute("nowBlock", nowBlock);

		nextPage = "/main.jsp";
	}
}
