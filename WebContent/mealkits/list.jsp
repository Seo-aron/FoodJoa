<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	
	String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>나만의 음식 판매</title>
	<style>
	#container {
		width: 1000px;
	}
	
	.list {
		width: 1000px;
	}
	.thumbnail {
		width: 256px;
		height: 256px;
	}
	</style>
</head>
<body>

	<div id="container">
		<table class="list">
			<c:set var="i" value="0" />
			<c:forEach var="mealkit" items="${mealkitList}" varStatus="status">		
					<tr>
						<td>
							<a href="<%= contextPath %>/Mealkit/info?no=${mealkit.no}"> 
								<sapn>
								<img class="thumbnail" src="<%= contextPath %>/images/recipe/test_thumbnail.png">
									<!--<img src="${mealkit.pictures}" alt="${mealkit.title}">-->
									작성자: ${mealkit.id } &nbsp;&nbsp;&nbsp;&nbsp;
									작성일: ${mealkit.postDate} &nbsp;&nbsp;&nbsp;&nbsp;
									<!--나중에 수정 -->
									평점:  &nbsp;&nbsp;&nbsp;&nbsp;
									조회수: ${mealkit.views}
								</sapn>
								<h3>${mealkit.title}</h3>
								<p>가격: ${mealkit.price}</p>
								<p>${mealkit.contents}</p>
							</a>
						</td>
					</tr>
			</c:forEach>
		</table>
		
		<input type="button" id="newContent" value="글쓰기" 
		onclick="location.href='<%=contextPath%>/Mealkit/write'"/>
		
	</div>

</body>
</html>
