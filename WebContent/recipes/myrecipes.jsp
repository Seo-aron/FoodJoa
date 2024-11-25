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
	
	ArrayList<HashMap<String, Object>> recipes = (ArrayList<HashMap<String, Obejct>>) request.getAttribute("recipes");
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
	</style>
</head>

<body>
	<div id="container">
		<h1>내 레시피 관리</h1>
		<table width="100%" border="1">
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
					RecipeVO recipeVO = recipes.get(i).get("recipeVO");
					float averageRating = recipes.get(i).get("averageRating");
					%>
					<tr>
						<td>
							<div class="recipe-container">
								<table border="1">
									<tr>
										<td rowspan="3">
											<div class="recipe-thumbnail">
												<img src="<%= contextPath %>/images/recipe/thumbnails/<%= recipeVO.getNo() %>/<%= recipeVO.getThumbnail() %>">
											</div>
										</td>
										<td>
											<p><%= recipeVO.getTitle() %></p>
										</td>
										<td>
											<img id="rating-star" src="<%= contextPath %>/images/recipe/full_star.png">
											<%= averageRating %>
										</td>
									</tr>
									<tr>
										<td rowspan="2">
											<%= recipeVO.getDescription() %>
										</td>
										<td>
											조회수 : <%= recipeVO.getViews() %>
										</td>
									</tr>
									<tr>
										<td>
											<input type="button" id="update-button" oncl>
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
</body>

</html>