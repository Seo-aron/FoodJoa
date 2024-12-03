<%@page import="VOs.MemberVO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.sql.Timestamp"%>
<%@page import="VOs.CommunityVO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	String contextPath = request.getContextPath();
	ArrayList<HashMap<String, Object>> communities = (ArrayList<HashMap<String, Object>>)request.getAttribute("communities");

	String id = (String) session.getAttribute("userId");
	
	int totalRecord = communities.size();
	
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

<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
<link rel="stylesheet" href="<%=contextPath%>/css/community/list.css">


</head>
<body>
	<div id="commnunity-container">
		<div id="community-header" align="center">
			<p class="community_p1">COMMUNITY</p>
			<p class="community_p2">자유게시판</p>
			<p>자유롭게 글을 작성해보세요</p>
		</div>
	</div>
	
	<div id="community-body">
		<table class="table-list" width="100%">
			<tr align="center" bgcolor="#e9ecef">
				<td class="col-no" width="15%">글번호</td>
				<td class="col-title" width="45%">제목</td>
				<td class="col-write" width="15%">작성자</td>
				<td class="col-views" width="10%">조회수</td>
				<td class="col-date" width="15%">작성날짜</td>
			</tr>
			
			<%
			if (communities == null || communities.size() == 0){				
				%>
				<tr align="center">
					<td colspan="5">등록된 글이 없습니다.</td>
				</tr>
				<%
			}
			else {
				for(int i = beginPerPage; i < beginPerPage + numPerPage; i++) {
					
					if (i == totalRecord) {
						break;
					}
					
					CommunityVO community = (CommunityVO)communities.get(i).get("community");
					MemberVO member = (MemberVO)communities.get(i).get("member");
					%>			
					<tr align="center">
						<td><%=totalRecord - i%></td>
						<td align="left"><a href="<%=contextPath%>/Community/read?no=<%=community.getNo()%>"> <%=community.getTitle()%></a></td>
						<td><%= member.getNickname()%></td>
						<td><%= community.getViews()%></td>
						<td><%= new SimpleDateFormat("yyyy-MM-dd").format(community.getPostDate()) %></td>
					</tr>
					<%
				}
			}
			%>
			<tr class="page_number">
				<td colspan="5" align="center">
					<%
					if (totalRecord > 0) {
						
						if (nowBlock > 0) {
							%>
							<a href="<%= contextPath %>/Community/list?nowBlock=<%= nowBlock - 1 %>&nowPage=<%= (nowBlock - 1) * pagePerBlock %>">
								이전
							</a>
							<%
						}
						
						for (int i = 0; i < pagePerBlock; i++) {
							if ((nowBlock * pagePerBlock) + i == totalPage) {
								break;
							}
							%>
							<a href="<%= contextPath %>/Community/list?nowBlock=<%= nowBlock %>&nowPage=<%= (nowBlock * pagePerBlock) + i %>">
								<%= (nowBlock * pagePerBlock) + i + 1 %>
							</a>
							<%
						}
						
						if (nowBlock + 1 < totalBlock) {
							%>
							<a href="<%= contextPath %>/Community/list?nowBlock=<%= nowBlock + 1 %>&nowPage=<%= (nowBlock + 1) * pagePerBlock %>">
								다음
							</a>
							<%
						}
					}
					%>
				</td>
			</tr>
			<tr>
				<td colspan="5" align="center">
					<div class="community-table-bottom">
						<form action="<%=contextPath%>/Community/searchList" method="post" 
							name="frmSearch" onsubmit="fnSearch(); return false;">
							<span class="select-button">
								<select name="key">
									<option value="titleContent">제목+내용</option>								
									<option value="writerContent">작성자</option>								
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
			
			location.href='<%=contextPath%>/Community/write';
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