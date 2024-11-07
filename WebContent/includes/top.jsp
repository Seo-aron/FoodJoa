<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	request.setCharacterEncoding("UTF-8");

	String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<style type="text/css">
		a {
			text-decoration: none;
		}
	</style>
</head>

<body>
	<table width="100%" height="5">
		<tr>
			<!-- 홈 -->
			<td align="center" bgcolor="lightgreen" width="20%">
				<a href="<%= contextPath %>/index.jsp">
					<div style="font-size: 2.5rem; color: white;">홈</div>
				</a>
			</td>
			<!-- 레시피 -->
			<td align="center" bgcolor="lightgreen" width="20%">
				<a href="<%= contextPath %>/Recipe/list">
					<div style="font-size: 2.5rem; color: white;">레시피 공유</div>
				</a>
			</td>
			<!-- 밀키트 -->
			<td align="center" bgcolor="lightgreen" width="20%">
				<a href="#">
					<div style="font-size: 2.5rem; color: white;">나만의 음식 판매</div>
				</a>
			</td>
			<!-- 자유 게시판 -->
			<td align="center" bgcolor="lightgreen" width="20%">
				<a href="#">
					<div style="font-size: 2.5rem; color: white;">자유게시판</div>
				</a>
			</td>
			<!-- 마이 페이지 -->
			<td align="center" bgcolor="lightgreen" width="20%">
				<a href="#">
					<div style="font-size: 2.5rem; color: white;">마이페이지</div>
				</a>
			</td>
		</tr>
	</table>
</body>

</html>