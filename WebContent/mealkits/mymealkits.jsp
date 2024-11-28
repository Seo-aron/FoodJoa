<%@page import="VOs.MealkitVO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
	
	ArrayList<HashMap<String, Object>> mealkits = (ArrayList<HashMap<String, Object>>) request.getAttribute("mealkits");
	
	String id = (String) session.getAttribute("userId");
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
	
	<style>
		#container {
			width: 1200px;
		}
		
		table {
			border-collapse: collapse;
		}
		
		.mealkit-container {
			border: 1px solid black;
			margin-bottom: 10px;
		}
		
		.mealkit-thumbnail {
			width: 300px;
			height: 200px;
			overflow: hidden;
		}
		
		.mealkit-thumbnail img {
			width: 100%;
			height: 100%;
			object-fit: cover;
		}
		
		.title-area {
			padding: 10px;
		}
		
		.description-area {
			padding: 10px;
		}
		
		.rating-area, .views-area {
			padding: 10px;
			text-align: right;
		}
		
		.rating-star {
			width: 24px;
			height: 24px;
		}
		
		.button-area {
			text-align: right;
			padding: 5px;
		}
		
		.button-area input {
			width: 60px;
			height: 44px;
		}
	</style>
</head>

<body>
	<div id="container">
		<h1>내 밀키트 관리</h1>
		<table width="100%">
			<%
			if (mealkits == null || mealkits.size() == 0) {
				%>
				<tr>
					<td>작성한 밀키트 상품이 없습니다.</td>
				</tr>
				<%
			}
			else {
				for(int i = 0; i < mealkits.size(); i++) {
					MealkitVO mealkitVO = (MealkitVO) mealkits.get(i).get("mealkitVO");
					float averageRating = (float) mealkits.get(i).get("averageRating");
					%>
					<tr>
						<td>
							<div class="mealkit-container">
								<table width="100%">
									<tr>
										<td rowspan="3" width="300px">
											<div class="mealkit-thumbnail">
												<img src="<%= contextPath %>/images/mealkit/thumbnails/<%= mealkitVO.getNo() %>/<%= mealkitVO.getPictures() %>">
											</div>
										</td>
										<td class="title-area" width="718px">
											<p><%= mealkitVO.getTitle() %></p>
										</td>
										<td class="rating-area" width="180px">
											<img class="rating-star" src="<%= contextPath %>/images/recipe/full_star.png">
											<%= averageRating %>
										</td>
									</tr>
									<tr>
										<td class="description-area" rowspan="2">
											<%= mealkitVO.getContents() %>
										</td>
										<td class="views-area">
											조회수 : <%= mealkitVO.getViews() %>
										</td>
									</tr>
									<tr>
										<td class="button-area">
											<input type="button" class="update-button" value="수정" onclick="onUpdateButton('<%= mealkitVO.getNo() %>')">
											<input type="button" class="delete-button" value="삭제" onclick="onDeleteButton('<%= mealkitVO.getNo() %>')">
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>					
					<%
				}
			}
			%>
		</table>
	</div>
	
	
	<script>
		function onUpdateButton(no) {
			location.href = '<%= contextPath %>/Mealkit/update?no=' + no;
		}
		
		function onDeleteButton(no) {
			if (confirm('정말로 삭제하시겠습니까?')) {
				location.href = '<%= contextPath %>/Mealkit/delete.pro?no=' + no;	
			}
		}
	</script>
</body>

</html>