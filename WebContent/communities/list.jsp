<%@page import="VOs.CommunityVO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	String contextPath = request.getContextPath();
	ArrayList<CommunityVO> communities = (ArrayList<CommunityVO>)request.getAttribute("communities");
	
	String id = "admin";
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
			if (communities == null || communities.size() == 0){
				
			%>
				<tr align="center">
					<td colspan="5">등록된 글이 없습니다.</td>
				</tr>
			<%
			}
			else{
				for(int i=0; i<communities.size(); i++){
					CommunityVO vo = communities.get(i); 
			%>			
				<tr align="center">
					<td><%= vo.getNo()%></td>
					<td><a href="<%=contextPath%>/Community/read?no=<%=vo.getNo()%>"> <%=vo.getTitle()%></a></td>
					<td><%= vo.getId()%></td>
					<td><%= vo.getViews()%></td>
					<td><%= vo.getPostDate()%></td>
				</tr>
			<%
				}
			}
			%>
				<tr>
					<td colspan="5" align="center">&nbsp;&nbsp;&nbsp;&nbsp;
						<form action="<%=contextPath%>/Community/list.jsp" method="post"
						  name="frmSearch" onsubmit="fnSearch(); return false;">
							<select>
								<option value="titleContent">제목+내용</option>								
								<option value="titleContent">작성자</option>								
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
		<script>
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