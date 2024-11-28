<%@page import="VOs.RecipeVO"%>
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
	
	ArrayList<HashMap<String, Object>> recipes = (ArrayList<HashMap<String, Object>>) request.getAttribute("recipes");
	
	String id = (String) session.getAttribute("userId");
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
	
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="<%=contextPath%>/css/recipe/myrecipes.css">	
</head>

<body>
	<div id="myrecipe-container">
		<h1>내 레시피 관리</h1>
		<table width="100%">
			<%
			if (recipes == null || recipes.size() == 0) {
				%>
				<tr>
					<td>작성한 레시피가 없습니다.</td>
				</tr>
				<%
			}
			else {
				for(int i = 0; i < recipes.size(); i++) {
					RecipeVO recipeVO = (RecipeVO) recipes.get(i).get("recipeVO");
					float averageRating = (float) recipes.get(i).get("averageRating");
					%>
					<tr>
						<td>
							<div class="recipe-container">
								<table width="100%">
									<tr>
										<td rowspan="3" width="300px">
											<div class="recipe-thumbnail">
												<img src="<%= contextPath %>/images/recipe/thumbnails/<%= recipeVO.getNo() %>/<%= recipeVO.getThumbnail() %>">
											</div>
										</td>
										<td class="title-area" width="718px">
											<p><%= recipeVO.getTitle() %></p>
										</td>
										<td class="rating-area" width="180px">
											<img class="rating-star" src="<%= contextPath %>/images/recipe/full_star.png">
											<%= averageRating %>
										</td>
									</tr>
									<tr>
										<td class="description-area" rowspan="2">
											<p><%= recipeVO.getDescription() %></p>
										</td>
										<td class="views-area">
											조회수 : <%= recipeVO.getViews() %>
										</td>
									</tr>
									<tr>
										<td class="button-area">
											<input type="button" class="update-button" value="수정" onclick="onUpdateButton('<%= recipeVO.getNo() %>')">
											<input type="button" class="delete-button" value="삭제" onclick="onDeleteButton('<%= recipeVO.getNo() %>')">
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
			location.href = '<%= contextPath %>/Recipe/update?no=' + no;
		}
		
		function onDeleteButton(no) {
			if (confirm('정말로 삭제하시겠습니까?')) {
				location.href = '<%= contextPath %>/Recipe/deletePro?no=' + no;	
			}
		}
	</script>
</body>

</html>