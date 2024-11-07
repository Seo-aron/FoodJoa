<%@page import="VOs.RecipeVO"%>
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
	
	ArrayList<RecipeVO> recipes = (ArrayList<RecipeVO>) request.getAttribute("recipes");
	final int columnCount = 4;
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>나만의 레시피 공유</title>
	
	<link rel="stylesheet" href="<%=contextPath%>/css/recipe/list.css">
	
	<script type="text/javascript">
		function openRecipeContent(recipeNo) {
			console.log(recipeNo);
			document.frmOpen.action = '<%= contextPath %>/Recipe/content';
			document.frmOpen.no.value = recipeNo;
			document.frmOpen.submit();
		}	
	</script>
</head>

<body>
	<div id="container">
		<table class="list_table">
			<%
			for (int i = 0; i < recipes.size(); i++) {
				
				RecipeVO recipe = recipes.get(i);
				
				if (i % columnCount == 0) { %> <tr> <% }
				
				float rating = recipe.getRating();
				
				%>
				<td class="list_cell">
					<a href="javascript:openRecipeContent('<%= recipe.getNo() %>')">
						<div class="thumbnail">
							<img src="<%= contextPath %>/images/recipe/test_thumbnail.png">
						</div>
						<p><%= recipe.getTitle() %></p>
						<p><%= recipe.getId() %></p>
						
						<%
						String starImage = "";
						for (int j = 1; j <= 5; j++) {
							if (j <= rating)
								starImage = "full_star.png";
							else if (j > rating && j < rating + 1)
								starImage = "half_star.png";
							else
								starImage = "empty_star.png";
							
							%>
							<img class="review_star" src="<%= contextPath %>/images/recipe/<%= starImage %>">
							<%
						}
						%>
						<span><%= recipe.getViews() %></span>
					</a>
				</td>
				<%
				
				if (i % columnCount == columnCount - 1) { %> </tr> <% }
			}
			%>
		</table>
	</div>
	
	<form name="frmOpen">
		<input type="hidden" name="no">
	</form>
</body>

</html>