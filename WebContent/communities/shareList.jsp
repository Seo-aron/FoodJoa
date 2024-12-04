<%@page import="VOs.MemberVO"%>
<%@page import="VOs.CommunityShareVO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	String contextPath = request.getContextPath();
	ArrayList<HashMap<String, Object>> shareList = (ArrayList<HashMap<String, Object>>) request.getAttribute("shareList");
	
	String id = (String) session.getAttribute("userId");
	
	int totalRecord = shareList.size();
	
	int numPerPage = 10;		// 한 페이지에 보여줄 게시글 개수
	int totalPage = 0;
	int nowPage = 0;
	int beginPerPage = 0;		// 각 페이지의 첫 번째 게시글 순서
	
	int pagePerBlock = 5;		// 한 블럭당 보여줄 페이지 개수
	int totalBlock = 0;
	int nowBlock = 0;

	if (request.getAttribute("nowPage") != null) {
		nowPage = Integer.parseInt(request.getAttribute("nowPage").toString());
	}

	if (request.getAttribute("nowBlock") != null) {
		nowBlock = Integer.parseInt(request.getAttribute("nowBlock").toString());
	}
	
	beginPerPage = nowPage * numPerPage;
	
	totalPage = (int) Math.ceil((double) totalRecord / numPerPage);
	
	totalBlock = (int) Math.ceil((double) totalPage / pagePerBlock);
%>  
    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">	
	<title>Insert title here</title>
	<link rel="stylesheet" href="<%=contextPath%>/css/community/sharelist.css">
</head>

<body>
	<div id="commnunity-container">
		<div id="community-header" align="center">
			<p class="community_p1">COMMUNITY</p>
			<p class="community_p2">나눔/같이먹어요 게시판</p>
			<p>자유롭게 글을 작성해보세요</p>
		</div>
	</div>
	
	<div id="container">
		<table class="table-list" width="100%">
			<tr align="center" bgcolor="#e9ecef">
				<td class="col-no" width="5%">글번호</td>
				<td class="col-title" width="5%">분류</td>
				<td class="col-title" width="40%">제목</td>
				<td class="col-write">작성자</td>
				<td class="col-views" width="5%">조회수</td>
				<td class="col-date">작성날짜</td>
			</tr>
			
			<%
			if (shareList == null || shareList.size() == 0){				
				%>
				<tr align="center">
					<td colspan="6">등록된 글이 없습니다.</td>
				</tr>
				<%
			}
			else {
				for(int i = beginPerPage; i < beginPerPage + numPerPage; i++) {
					if (i == totalRecord) {
						break;
					}
					
					CommunityShareVO share = (CommunityShareVO) shareList.get(i).get("share");
					MemberVO member = (MemberVO) shareList.get(i).get("member");
								
					%>			
					<tr align="center">
						<td width="10%">
							<%=totalRecord - i%>
						</td>
						<td width="10%" align="center">
							<% 
							if(share.getType() == 0){
								%> [재료나눔] <%
							}else{
								%> [같이먹어요] <%
							}
							%>
						</td>						
						<td width="25%" align="left">
							<a href="<%=contextPath%>/Community/shareRead?no=<%=share.getNo()%>&nowPage=<%=nowPage%>&nowBlock=<%=nowBlock%>">
								<%=share.getTitle()%>
							</a>
						</td>
						<td width="15%"><%= member.getNickname() %></td>
						<td width="10%"><%= share.getViews()%></td>
						<td width="15%"><%= new SimpleDateFormat("yyyy-MM-dd").format(share.getPostDate()) %></td>
					</tr>
					<%
				}
			}
			%>
			<tr class="page_number">
				<td colspan="6" align="center">
					<%
					if (totalRecord > 0) {
						
						if (nowBlock > 0) {
							%>
							<a href="<%= contextPath %>/Community/shareList?nowBlock=<%= nowBlock - 1 %>&nowPage=<%= (nowBlock - 1) * pagePerBlock %>">
								<
							</a>
							<%
						}
						
						for (int i = 0; i < pagePerBlock; i++) {
							if ((nowBlock * pagePerBlock) + i == totalPage) {
								break;
							}
							%>
							<a href="<%= contextPath %>/Community/shareList?nowBlock=<%= nowBlock %>&nowPage=<%= (nowBlock * pagePerBlock) + i %>">
								<%= (nowBlock * pagePerBlock) + i + 1 %>
							</a>
							<%
						}
						
						if (nowBlock + 1 < totalBlock) {
							%>
							<a href="<%= contextPath %>/Community/shareList?nowBlock=<%= nowBlock + 1 %>&nowPage=<%= (nowBlock + 1) * pagePerBlock %>">
								>
							</a>
							<%
						}
					}
					%>
				</td>
			</tr>
			<tr>
				<td colspan="6" align="center">
					<div class="community-table-bottom">
						<form action="<%=contextPath%>/Community/shareSearchList" method="post"
						  name="frmSearch" onsubmit="fnSearch(); return false;">
							<span class="select-button">						
								<select name="key">
									<option value="title">제목</option>								
									<option value="nickname">작성자</option>								
									<option value="type">분류</option>								
								</select>
							</span>
							<span class="community-search-area">
								<input type="text" name="word" id="word" placeholder="검색어를 입력해주세요">
							</span>
							<span class="community-search-button">
								<input type="submit" value="검색"/>
							</span>
						</form>
						<%
						if(id != null && id.length()!= 0){
							%>
							<div class="community-write-button">
								<input type="button" value="글쓰기" onclick="onWriteButton(event)">
							</div>
							<%
						}
						%>
					</div>
				</td>
			</tr>
		</table>
	</div>
	
	
	<script>
		function fnSearch(){
			var word = document.getElementById("word").value;
			
			if(word == null || word == ""){
				alert("검색어를 입력하세요.");
				document.getElementById("word").focus();
				
				return false;
			}
			else{
				
				document.frmSearch.submit();
			}
		}
	
		function onWriteButton(event) {
			event.preventDefault();
			
			location.href='<%=contextPath%>/Community/shareWrite';
		}
		
		function frmSearch(){
			var word = document.getElementById("word").value;
			
			if(word == null || word == ""){
				alert("검색어를 입력해주세요");
				
				document.getElementById("word").focus();
				
				return false;
			}
		}
	</script>		
</body>
</html>