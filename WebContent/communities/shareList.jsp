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
	
	<style>
		#container {
			margin: 0 auto;
			width: 1200px;
		}		
	</style>
</head>

<body>
	<div id="container">
		<table border="0" width=100% cellpadding="2" cellspacing="0">
			<tr align="center" bgcolor="#99ff99">
				<td class="col-no">글번호</td>
				<td class="col-title">제목</td>
				<td class="col-write">작성자</td>
				<td class="col-views">조회수</td>
				<td class="col-date">작성날짜</td>
			</tr>
			
			<%
			if (shareList == null || shareList.size() == 0){				
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
					
					CommunityShareVO share = (CommunityShareVO) shareList.get(i).get("share");
					MemberVO member = (MemberVO) shareList.get(i).get("member");
								
					%>			
					<tr align="center">
						<td><%= share.getNo()%></td>
						<td>
							<a href="<%=contextPath%>/Community/shareRead?no=<%=share.getNo()%>&nowPage=<%=nowPage%>&nowBlock=<%=nowBlock%>">
								<%=share.getTitle()%>
							</a>
						</td>
						<td><%= member.getNickname() %></td>
						<td><%= share.getViews()%></td>
						<td><%= new SimpleDateFormat("yyyy-MM-dd").format(share.getPostDate()) %></td>
					</tr>
					<%
				}
			}
			%>
			<tr>
				<td colspan="5" align="center">
					<%
					if (totalRecord > 0) {
						
						if (nowBlock > 0) {
							%>
							<a href="<%= contextPath %>/Community/shareList?nowBlock=<%= nowBlock - 1 %>&nowPage=<%= (nowBlock - 1) * pagePerBlock %>">
								이전
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
								다음
							</a>
							<%
						}
					}
					%>
				</td>
			</tr>
			<tr>
				<td colspan="5" align="center">&nbsp;&nbsp;&nbsp;&nbsp;
					<form action="<%=contextPath%>/Community/shareSearchList" method="post"
					  name="frmSearch" onsubmit="fnSearch(); return false;">
						<select name="key">
							<option value="title">제목</option>								
							<option value="nickname">작성자</option>								
						</select>
							<input type="text" name="word" id="word" placeholder="검색어를 입력해주세요">
							<input type="submit" value="검색"/>

					<%	if(id != null && id.length()!= 0){
						
					%>
						<input type="button" value="글쓰기" onclick="onWriteButton(event)">
						
					<%  } %>
				
					</form>
				</td>
			</tr>
		</table>
	</div>
	
	
	<script>
		function fnSearch(){
			//입력한 검색어 얻기 
			var word = document.getElementById("word").value;
			
	    	//검색어를 입력하지 않았다면?
			if(word == null || word == ""){
				//검색어 입력 메세지창 띄우기 
				alert("검색어를 입력하세요.");
				//검색어를 입력 하는 <input>에 강제 포커스를 주어 검색어를 입력하게 유도함.
				document.getElementById("word").focus();
				
				//<form>의 action속성에 작성된 BoardController서버페이지 요청을 차단 
				return false;
			}
			else{//검색어를 입력했다면
				
				//<form>을 선택해서 가져와 action속성에 작성된 주소를 이용해
				//BoardController로 입력한 검색어에 관한 글목록 조회 요청을 함 
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