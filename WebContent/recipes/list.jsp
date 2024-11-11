<%@page import="VOs.RecipeVO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<link rel="stylesheet" href="<%=contextPath%>/css/recipe/list.css">
	
	<script type="text/javascript">
		$(function() {			
			$("#write").click(function() {
				location.href = '<%= contextPath %>/Recipe/write';
			});
		});
	
		function openRecipeContent(recipeNo) {
			console.log(recipeNo);
			document.frmOpen.action = '<%= contextPath %>/Recipe/read';
			document.frmOpen.no.value = recipeNo;
			document.frmOpen.submit();
		}
	</script>
</head>

<body>
	<div id="container">
		<table class="header">
			<tr>
				<td align="center">
					<input type="text" name="search" placeholder="검색할 레시피를 입력하세요.">
					<input type="button" name="search_button" value="검색">
				</td>
				<td align="center">
					<input type="button" id="write" name="write" value="나만의 레시피 쓰기">
				</td>
			</tr>
		</table>
		
		<table class="list_table">
			<%
			if (recipes == null || recipes.size() <= 0) {
				%>
				<tr>
					<td>등록된 레시피가 없습니다.</td>
				</tr>
				<%
			}
			else {
				for (int i = 0; i < recipes.size(); i++) {
					
					RecipeVO recipe = recipes.get(i);
					
					if (i % columnCount == 0) { %> <tr> <% }
					
					float rating = recipe.getRating();
					
					%>
					<td class="list_cell">
					    <a href="javascript:openRecipeContent('<%= recipe.getNo() %>')" class="cell-link">
					        <span class="thumbnail">
					            <img src="<%= contextPath %>/images/recipe/test_thumbnail.png" alt="레시피 썸네일">
					        </span>
					        <span class="title"><%= recipe.getTitle() %></span>
					        <span class="author"><%= recipe.getId() %></span>
					        
					        <span class="rating">
					            <%
					            String starImage = "";
					            for (int j = 1; j <= 5; j++) {
					                if (j <= rating) starImage = "full_star.png";
					                else if (j > rating && j < rating + 1) starImage = "half_star.png";
					                else starImage = "empty_star.png";
					                %>
					                <img class="review_star" src="<%= contextPath %>/images/recipe/<%= starImage %>" alt="별점">
					                <%
					            }
					            %>
					        </span>
					        <span class="views"><%= recipe.getViews() %></span>
					    </a>
					</td>
					<%					
					if (i % columnCount == columnCount - 1) { %> </tr> <% }
				}
			}
			%>
		</table>
	</div>
	
	<form name="frmOpen">
		<input type="hidden" name="no">
	</form>
</body>

</html>