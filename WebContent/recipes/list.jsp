<%@page import="java.util.HashMap"%>
<%@page import="VOs.RecipeVO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
	
	ArrayList<HashMap<String, Object>> recipes = (ArrayList<HashMap<String, Object>>) request.getAttribute("recipes");
	
	String category = (String) request.getAttribute("category");
	
	final int columnCount = 4;
	
	int totalRecipeCount = recipes.size();
	
	int recipeCountPerPage = 12;
	int totalPageCount = (int) Math.ceil((double) totalRecipeCount / recipeCountPerPage);
	int currentPage = (request.getAttribute("currentPage") == null) ? 0 :
		Integer.parseInt(request.getAttribute("currentPage").toString());
	
	int pageCountPerBlock = 5;
	int totalBlockCount = (int) Math.ceil((double) totalPageCount / pageCountPerBlock);
	int currentBlock = (request.getAttribute("currentBlock") == null) ? 0 :
		Integer.parseInt(request.getAttribute("currentBlock").toString());
	
	int firstRecipeIndex = currentPage * recipeCountPerPage;
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>나만의 레시피 공유</title>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>	
	<script type="text/javascript">
		$(function() {			
			$("#write").click(function() {
				location.href = '<%= contextPath %>/Recipe/write';
			});
		});
	
		function openRecipeContent(recipeNo) {
			document.frmOpen.action = '<%= contextPath %>/Recipe/read';
			document.frmOpen.no.value = recipeNo;
			document.frmOpen.submit();
		}
	</script>
	
	<link rel="stylesheet" href="<%=contextPath%>/css/recipe/list.css">
</head>

<body>
	<div id="container">
		<table class="header">
			<tr>
				<td align="center">
					<select>
						<option>레시피 명</option>
						<option>작성자</option>
					</select>
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
				for (int i = firstRecipeIndex; i < firstRecipeIndex + recipeCountPerPage; i++) {
					
					if (i >= totalRecipeCount) { %> </tr> <% break; }
					
					if (i % columnCount == 0) { %> <tr> <% }

					RecipeVO recipe = (RecipeVO) recipes.get(i).get("recipe");					
					double rating = (double) recipes.get(i).get("average");
					String nickname = (String) recipes.get(i).get("nickname");
					
					%>
					<td class="list_cell">
					    <a href="javascript:openRecipeContent(<%= recipe.getNo() %>)" class="cell-link">
					        <span class="thumbnail">
					            <img src="<%= contextPath %>/images/recipe/thumbnails/<%= recipe.getNo() %>/<%= recipe.getThumbnail() %>">
					        </span>
					        <span class="title"><%= recipe.getTitle() %></span>
					        <span class="nickname"><%= nickname %></span>
					        
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
			<tr>
				<td class="paging-area" colspan="4">
					<ul>
					<%
					if (totalRecipeCount != 0) {
						if (currentBlock > 0) {
							%>
							<li>
								<a href="<%= contextPath %>/Recipe/list?category=<%= category %>&
									currentBlock=<%= currentBlock - 1 %>&currentPage=<%= (currentBlock - 1) * pageCountPerBlock %>">
									◀
								</a>
							</li>
							<%
						}
						
						for (int i = 0; i < pageCountPerBlock; i++) {
							int pageNumber = (currentBlock * pageCountPerBlock) + i;
							
							%>
							<li>
								<a href="<%= contextPath %>/Recipe/list?category=<%= category %>&
									currentBlock=<%= currentBlock %>&currentPage=<%= pageNumber %>">
									<%= pageNumber + 1 %>
								</a>
							</li>
							<%
							
							if (pageNumber + 1 == totalPageCount)
								break;
						}
						
						if (currentBlock + 1 < totalBlockCount) {
							%>
							<li>
								<a href="<%= contextPath %>/Recipe/list?category=<%= category %>&
									currentBlock=<%= currentBlock + 1 %>&currentPage=<%= (currentBlock + 1) * pageCountPerBlock %>">
									▶
								</a>
							</li>
							<%
						}
					}
					%>
					</ul>
				</td>
			</tr>
		</table>
	</div>
	
	<form name="frmOpen">
		<input type="hidden" name="no">
		<input type="hidden" name="category" value="<%= category %>">
		<input type="hidden" name="currentPage" value="<%= currentPage %>">
		<input type="hidden" name="currentBlock" value="<%= currentBlock %>">
	</form>
</body>

</html>