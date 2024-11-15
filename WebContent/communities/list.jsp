<%@page import="VOs.CommunityVO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	String contextPath = request.getContextPath();
	ArrayList<CommunityVO> communities = (ArrayList<CommunityVO>)request.getAttribute("list");
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
		<table border="1">
			<tr>
				<td>번호</td>
				<td>제목</td>
				<td>작성자</td>
				<td>조회수</td>
				<td>작성날짜</td>
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
				<tr>
					<td><%= vo.getNo() %></td>
					<td><%= vo.getTitle() %></td>
					<td><%= vo.getContents() %></td>
					<td><%= vo.getViews() %></td>
					<td><%= vo.getPostDate() %></td>
				</tr>
			<%
				}
			}
			%>
			
			<tr>
				<td></td>
				
			</tr>
		</table>
	</div>
</body>
</html>