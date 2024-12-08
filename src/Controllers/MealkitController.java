package Controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import Services.MealkitService;
import VOs.MealkitReviewVO;
import VOs.MealkitVO;

@WebServlet("/Mealkit/*")
public class MealkitController extends HttpServlet {

	private MealkitService mealkitService;
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
		case "/cart.pro": processCartMealkit(request, response); return;
		case "/wish.pro": processWishMealkit(request, response); return;
		
		case "/write": openAddMealkit(request, response); break;
		case "/write.pro": processAddMealkit(request, response); return;
		case "/delete.pro": processDelete(request, response); return;
		case "/update": openUpdateBoard(request, response); break;
		case "/update.pro": processUpdate(request, response); return;
		
		case "/reviewwrite": openAddReview(request, response); break;
		case "/reviewwrite.pro": processAddReview(request, response); return;
		case "/reviewDelete.pro": processReviewDelete(request, response); return;
		case "/reviewUpdate": openReviewUpdate(request, response); break;
		case "/reviewUpdate.pro": processReviewUpdate(request, response); return;
		
		case "/searchlist.pro": processSearchList(request, response); break;
		case "/buyMealkit.pro": processBuyMealkit(request, response); return;		
		case "/myMealkits": openMyMealkitView(request, response); break;

		default: break;
		}

		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
	}

	private void processReviewUpdate(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		mealkitService.updateReviewpro(request);
	}

	private void openReviewUpdate(HttpServletRequest request, HttpServletResponse response) {
		MealkitVO mealkit = mealkitService.getMealkitReview(request);
		String nickName = mealkitService.getMealkitNickName(mealkit);
		MealkitReviewVO reviewvo = mealkitService.updateReviewMealkit(request);
		
		String title = (String) mealkit.getTitle();
		
		request.setAttribute("mealkit", mealkit);
	    request.setAttribute("nickName", nickName);
		request.setAttribute("reviewvo", reviewvo);
		request.setAttribute("pageTitle", title);
		request.setAttribute("center", "mealkits/editreview.jsp");
		
		nextPage = "/main.jsp";
	}

	private void processReviewDelete(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		mealkitService.delMealkitReview(request, response);
	}

	private void openMyMealkitView(HttpServletRequest request, HttpServletResponse response) {
		ArrayList<HashMap<String, Object>> mealkits = mealkitService.getMealkitsListById(request);
		String nickName = mealkitService.getNickName(request);
		
		request.setAttribute("mealkits", mealkits);
		request.setAttribute("nickName", nickName);
		request.setAttribute("pageTitle", "내 상품 관리");
		request.setAttribute("center", "mealkits/mymealkits.jsp");
		request.setAttribute("pageTitle", "내 밀키트 관리");

		nextPage = "/main.jsp";
	}

	private void processBuyMealkit(HttpServletRequest request, HttpServletResponse response) throws IOException {
		
		int result = mealkitService.buyMealkit(request, response);
		
		PrintWriter out = response.getWriter();
		
		out.print(result);
		
		out.close();
	}

	private void processSearchList(HttpServletRequest request, HttpServletResponse response) {
		ArrayList<MealkitVO> list = mealkitService.searchList(request);

		request.setAttribute("mealkitList", list);
		request.setAttribute("center", "mealkits/list.jsp");

		nextPage = "/main.jsp";
	}

	private void openUpdateBoard(HttpServletRequest request, HttpServletResponse response) {
		MealkitVO mealkitvo = mealkitService.getMealkitInfo(request);
		
		String title = (String) mealkitvo.getTitle();
		
		request.setAttribute("mealkitvo", mealkitvo);
		request.setAttribute("center", "mealkits/editBoard.jsp");
		request.setAttribute("pageTitle", title);
		
		nextPage = "/main.jsp";
	}

	private void processUpdate(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {
		mealkitService.updateMealkit(request, response);
	}

	private void processDelete(HttpServletRequest request, HttpServletResponse response) 
			throws IOException {

		int result = mealkitService.delMealkit(request);		

	    PrintWriter printWriter = response.getWriter();
	    
	    printWriter.print(result);
	    
		printWriter.close();
	}

	private void openAddReview(HttpServletRequest request, HttpServletResponse response) {
		
		MealkitVO mealkit = mealkitService.getMealkitInfo(request);
		String nickName = mealkitService.getMealkitNickName(mealkit);
		
		String title = (String) mealkit.getTitle();
	    
	    request.setAttribute("mealkit", mealkit);
	    request.setAttribute("nickName", nickName);
		request.setAttribute("center", "mealkits/reviewWrite.jsp");
		request.setAttribute("pageTitle", title);
		
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
		
		request.setAttribute("pageTitle", "밀키트 게시글 작성");
		request.setAttribute("center", "mealkits/write.jsp");
		
		nextPage = "/main.jsp";
	}

	private void processWishMealkit(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException{
		mealkitService.setWishMealkit(request, response);
	}

	private void processCartMealkit(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException{
		int result = mealkitService.setCartMealkit(request, response);
		
		PrintWriter out = response.getWriter();
		
		out.print(result);
		
		out.close();
	}
	
	private void openMealkitInfoView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		HashMap<String, Object> mealkit = mealkitService.getMealkit(request);
		ArrayList<HashMap<String, Object>> reviews = mealkitService.getReviewInfo(request);
		
		String title = ((MealkitVO) mealkit.get("mealkitVO")).getTitle();
		
		request.setAttribute("mealkit", mealkit);
		request.setAttribute("reviews", reviews);
		request.setAttribute("pageTitle", title);
		request.setAttribute("center", "mealkits/info.jsp");

		nextPage = "/main.jsp";
	}

	private void openMealkitView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		int category = Integer.parseInt(request.getParameter("category"));

		ArrayList<Map<String, Object>> mealkits = mealkitService.getMealkitsList(category);
		Map<Integer, Float> ratingAvr = mealkitService.getAllRatingAvr(mealkits);
		
		String nowPage = request.getParameter("nowPage");
		String nowBlock = request.getParameter("nowBlock");

		request.setAttribute("mealkitList", mealkits);
		request.setAttribute("ratingAvr", ratingAvr);
		request.setAttribute("category", category);
		request.setAttribute("center", "mealkits/list.jsp");
		request.setAttribute("nowPage", nowPage);
		request.setAttribute("nowBlock", nowBlock);
		request.setAttribute("pageTitle", "밀키트 목록");

		nextPage = "/main.jsp";
	}
}
