package Controllers;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import Services.CommunityService;
import VOs.CommunityShareVO;
import VOs.CommunityVO;
import VOs.NoticeVO;

@WebServlet("/Community/*")
public class CommunityController extends HttpServlet {

	private CommunityService communityService;
	private String nextPage;
	private String printWriter;
	
	public void init(ServletConfig config) throws ServletException {
		
		communityService = new CommunityService();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doHandle(request, response);
	}

	protected void doHandle(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html;charset=utf-8");

		String action = request.getPathInfo();
		System.out.println("action : " + action);
		
		switch (action) {
			case "/list": openCommunityList(request,response);break;
			case "/write": openCommunityWriteView(request,response);break;
			case "/write.pro": processCommunityWrite(request,response);break;
			case "/read": openCommunityRead(request,response);break;
			case "/update": openCommunityUpdateView(request,response);break;
			case "/updatePro": processCommunityUpdate(request, response);return;
			case "/deletePro": processCommunityDelete(request, response);return;	
			case "/searchList" : processCommunitySearch(request, response);break;
			
			case "/shareList": openShareList(request, response);break; 
			case "/shareWrite": openShareWriteView(request, response);break; 
			case "/shareWrite.pro": if (!processShareWrite(request, response)) return; break; 
			case "/shareRead": openShareRead(request, response);break; 
			case "/shareUpdate": openShareUpdateView(request, response);break; 
			case "/shareUpdatePro": processShareUpdate(request, response);return; 
			case "/shareDeletePro": processShareDelete(request, response);break;
			case "/shareSearchList": processShareSearch(request, response); break;
			
			case "/noticeList": openNoticeListView(request, response); break;
			case "/noticeWrite": openNoticeWriteView(request, response); break;
			case "/noticeWritePro": processNoticeWrite(request, response); return;
			case "/noticeRead": openNoticeReadView(request, response); break;
			case "/noticeUpdate": openNoticeUpdateView(request, response); break;
			case "/noticeUpdatePro": processNoticeUpdate(request, response); return;
			case "/noticeDeletePro": processNoticeDelete(request, response); return;
			
			default:
		}
		
		RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
		dispatcher.forward(request, response);
		
	}

	private void openCommunityList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		HttpSession session = request.getSession();
		String loginid = (String)session.getAttribute("id");
	
		ArrayList<HashMap<String, Object>> communities = communityService.getCommunityList();
		
		String nowPage = request.getParameter("nowPage");
		String nowBlock = request.getParameter("nowBlock");

		request.setAttribute("communities", communities);
		request.setAttribute("center", "communities/list.jsp");
		request.setAttribute("nowPage", nowPage);
		request.setAttribute("nowBlock", nowBlock);

		request.setAttribute("pageTitle", "자유게시판");
		nextPage = "/main.jsp";	
	}

	private void openCommunityWriteView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
	
		request.setAttribute("center", "communities/write.jsp");
		request.setAttribute("pageTitle", "게시글 작성");
		
		nextPage = "/main.jsp";
	}
	
	private void processCommunityWrite(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{

		communityService.insertCommunity(request);
		
		nextPage = "/Community/list";
	}
	
	private void openCommunityRead(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		
		String no = request.getParameter("no");
		//CommunityVO vo = communityService.HashMap<String, Object>openCommunityRead(no);
		
		HashMap<String, Object> community = communityService.openCommunityRead(no);
		
		request.setAttribute("community", community);
		request.setAttribute("center", "communities/read.jsp");
		request.setAttribute("pageTitle", "자유게시판");

		nextPage = "/main.jsp";
		
	}
	
	private void openCommunityUpdateView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
	
		CommunityVO vo = new CommunityVO();
		vo.setNo(Integer.parseInt(request.getParameter("no")));
		vo.setTitle(request.getParameter("title"));
		vo.setContents(request.getParameter("contents"));
		vo.setViews(Integer.parseInt(request.getParameter("views")));
		
		request.setAttribute("vo", vo);
		request.setAttribute("center", "communities/update.jsp");
		request.setAttribute("pageTitle", "자유게시판");

		nextPage = "/main.jsp";
	}

	private void processCommunityUpdate(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		int result = communityService.updateCommunity(request);
		
		PrintWriter out = response.getWriter();
		
		out.print(result);
		
		out.close();
	}
	
	private void processCommunityDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		int result = communityService.deleteCommunity(request);
		
		PrintWriter out = response.getWriter();
		
		out.print(result == 1 ? "삭제 완료" : "삭제 실패");
		
		out.close();
		
	}
	
	private void processCommunitySearch(HttpServletRequest request, HttpServletResponse response) {

		HttpSession session = request.getSession();
		String loginid = (String)session.getAttribute("id");
		
		String key = request.getParameter("key");
		String word = request.getParameter("word");
		
		ArrayList<HashMap<String, Object>> communities = communityService.processCommunitySearch(key, word);

		request.setAttribute("communities", communities);
		request.setAttribute("center", "communities/list.jsp");
		
		nextPage = "/main.jsp";
		
	}
	
	private void openShareList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		
		ArrayList<HashMap<String, Object>> shareList = communityService.getShareList();
		
		String nowPage = request.getParameter("nowPage");
		String nowBlock = request.getParameter("nowBlock");
		
		request.setAttribute("shareList", shareList);
		request.setAttribute("nowPage", nowPage);
		request.setAttribute("nowBlock", nowBlock);
		request.setAttribute("center", "communities/shareList.jsp");
		request.setAttribute("pageTitle", "커뮤니티");

		nextPage = "/main.jsp";
	}
	
	private void openShareWriteView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{

		request.setAttribute("center", "communities/shareWrite.jsp");
		request.setAttribute("pageTitle", "커뮤니티");

		
		nextPage = "/main.jsp";
	}
	
	private boolean processShareWrite(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		
		int result = communityService.insertCommunityShare(request);
		
		if (result != -1) {

			nextPage = "/Community/shareList";
			
			return true;
		}
		else {
			PrintWriter out = response.getWriter();
			
			out.print("<script>");
			
			out.print("alert('게시물 등록에 실패했습니다.');");
			out.print("location.href = '<%= request.getContextPath() %>/Community/shareList';");
			
			out.print("</script>");
			
			out.close();
			
			return false;
		}
	}
	
	private void openShareRead(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		
		HashMap<String, Object> share = communityService.getCommunityShareMap(request);
		
		request.setAttribute("share", share);
		request.setAttribute("nowBlock", request.getParameter("nowBlock"));
		request.setAttribute("nowPage", request.getParameter("nowPage"));
		request.setAttribute("center", "communities/shareRead.jsp");
		request.setAttribute("pageTitle", "커뮤니티");

		nextPage = "/main.jsp";
	}
	
	private void openShareUpdateView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		
		CommunityShareVO share = communityService.getCommunityShare(request);

		request.setAttribute("share", share);
		request.setAttribute("nowBlock", request.getParameter("nowBlock"));
		request.setAttribute("nowPage", request.getParameter("nowPage"));
		request.setAttribute("center", "communities/shareUpdate.jsp");
		request.setAttribute("pageTitle", "커뮤니티");

		nextPage = "/main.jsp";
	}
	
	private void processShareUpdate(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException{
		
		int result = communityService.processShareUpdate(request);
		
		PrintWriter out = response.getWriter();
		
		out.print(result);
		
		out.close();
	}
	
	private void processShareDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		int result = communityService.processShareDelete(request);

		nextPage = "/Community/shareList";
	}

	private void processShareSearch(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		ArrayList<HashMap<String, Object>> shareList = communityService.getSearchedShareList(request);
		
		request.setAttribute("shareList", shareList);
		request.setAttribute("center", "communities/shareList.jsp");
		
		nextPage = "/main.jsp";
	}
	
	private void openNoticeListView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		ArrayList<NoticeVO> noticeList = communityService.getNoticeList(request);
		
		String nowPage = request.getParameter("nowPage");
		String nowBlock = request.getParameter("nowBlock");

		request.setAttribute("noticeList", noticeList);
		request.setAttribute("nowPage", nowPage);
		request.setAttribute("nowBlock", nowBlock);
		request.setAttribute("pageTitle", "공지사항");
		request.setAttribute("center", "communities/noticeList.jsp");

		nextPage = "/main.jsp";	
	}
	
	private void openNoticeWriteView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setAttribute("pageTitle", "공지사항 작성");
		request.setAttribute("center", "communities/noticeWrite.jsp");

		nextPage = "/main.jsp";	
	}
	
	private void processNoticeWrite(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		int result = communityService.processNoticeWrite(request);
		
		PrintWriter out = response.getWriter();
		
		out.print(result);
		
		out.close();
	}
	
	private void openNoticeReadView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		NoticeVO noticeVO = communityService.getNotice(request);
		
		request.setAttribute("noticeVO", noticeVO);
		request.setAttribute("nowPage", request.getParameter("nowPage"));
		request.setAttribute("nowBlock", request.getParameter("nowBlock"));
		request.setAttribute("pageTitle", "공지사항 - " + noticeVO.getTitle());
		request.setAttribute("center", "communities/noticeRead.jsp");

		nextPage = "/main.jsp";	
	}
	
	private void openNoticeUpdateView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
	
		NoticeVO noticeVO = communityService.getNotice(request);
		
		request.setAttribute("noticeVO", noticeVO);
		request.setAttribute("nowPage", request.getParameter("nowPage"));
		request.setAttribute("nowBlock", request.getParameter("nowBlock"));
		request.setAttribute("pageTitle", "공지사항 수정하기 - " + noticeVO.getTitle());
		request.setAttribute("center", "communities/noticeUpdate.jsp");

		nextPage = "/main.jsp";	
	}
	
	private void processNoticeUpdate(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		int result = communityService.processNoticeUpdate(request);
		
		PrintWriter out = response.getWriter();
		
		out.print(result);
		
		out.close();
	}
	
	private void processNoticeDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		int result = communityService.processNoticeDelete(request);
		
		PrintWriter out = response.getWriter();
		
		out.print(result);
		
		out.close();
	}
}
