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
	
	String currentPageStr = (String) request.getAttribute("currentPage");
	String currentBlockStr = (String) request.getAttribute("currentBlock");
	
	final int columnCount = 4;
	
	int totalRecipeCount = recipes.size();
	
	int recipeCountPerPage = 12;
	int totalPageCount = (int) Math.ceil((double) totalRecipeCount / recipeCountPerPage);
	int currentPage = (currentPageStr == null) ? 0 :
		Integer.parseInt(currentPageStr);
	
	int pageCountPerBlock = 5;
	int totalBlockCount = (int) Math.ceil((double) totalPageCount / pageCountPerBlock);
	int currentBlock = (currentBlockStr == null) ? 0 :
		Integer.parseInt(currentBlockStr);
	
	int firstRecipeIndex = currentPage * recipeCountPerPage;
	
	String id = (String) session.getAttribute("userId");
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
			
			$('#word').on('keydown', function(e) {
		        var keyCode = e.which;

		        if (keyCode === 13) {
		        	onSearchButton();
		        }
		    });
		});
	
		function openRecipeContent(recipeNo) {
			document.frmOpen.action = '<%= contextPath %>/Recipe/read';
			document.frmOpen.no.value = recipeNo;
			document.frmOpen.submit();
		}
		
		function onSearchButton() {
			let category = '<%= category %>';
			let key = document.getElementById('key').value;
			let word = document.getElementById('word').value;
			
			location.href = '<%= contextPath %>/Recipe/search?category=' + category + '&key=' + key + '&word=' + word;
		}
	</script>
	
	<link rel="stylesheet" href="<%=contextPath%>/css/recipe/list.css">
</head>

<body>
	<div id="container">
		<h1>
			<%
			int _catetory = (category == null || category.equals("")) ? 0 : Integer.parseInt(category);
		
			switch (_catetory) {
			case 1: %> 한식 요리 <% break;
			case 2: %> 일식 요리 <% break;
			case 3: %> 중식 요리 <% break;
			case 4: %> 양식 요리 <% break;
			case 5: %> 자취 요리 <% break;
			default: %> 전체 레시피 <%;
			}
			%>
		</h1>
		<div class="recipe-list-header">
			<div class="recipe-list-search-area">
				<select id="key" name="key">
					<option value="recipe">레시피 명</option>
					<option value="nickname">작성자</option>
				</select>
				<input type="text" id="word" name="word" placeholder="검색할 레시피를 입력하세요.">
				<input type="button" id="search-button" name="search-button" value="검색" onclick="onSearchButton()">
			</div>
			
			<div class="recipe-write-button">
				<%
				if (id != null && !id.equals("")) {
					%><input type="button" id="write" name="write" value="레시피 작성"><%
				}
				%>
			</div>
		</div>
		
		<table class="recipe-list-table">
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
					int reviewCount = (int) recipes.get(i).get("reviewCount");
					float rating = (float) recipes.get(i).get("average");
					String nickname = (String) recipes.get(i).get("nickname");
					
					%>
					<td class="recipe-cell">
					    <a href="javascript:openRecipeContent(<%= recipe.getNo() %>)" class="cell-link">
					    	<table>
					    		<tr>
					    			<td class="recipe-thumbnail" colspan="2">
					    				<img src="<%= contextPath %>/images/recipe/thumbnails/<%= recipe.getNo() %>/<%= recipe.getThumbnail() %>">	
					    			</td>
					    		</tr>
					    		<tr>
					    			<td class="recipe-title" colspan="2">
					    				<%= recipe.getTitle() %>
					    			</td>
					    		</tr>
					    		<tr>
					    			<td class="recipe-nickname" colspan="2">
					    				<%= nickname %>
					    			</td>
					    		</tr>
					    		<tr>
					    			<td class="recipe-review">					    			
					    				<img src="<%= contextPath %>/images/recipe/review_icon.png">
					    				<span><%= reviewCount %> reviews</span>
					    				<%-- <%
					    				if (rating < 1) {
					    					%>등록된 리뷰가 없습니다.<%
					    				}
					    				else {
								            String starImage = "";
								            for (int j = 1; j <= 5; j++) {
								                if (j <= rating) starImage = "full_star.png";
								                else if (j > rating && j < rating + 1) starImage = "half_star.png";
								                else starImage = "empty_star.png";
								                %>
								                <img class="review_star" src="<%= contextPath %>/images/recipe/<%= starImage %>" alt="별점">
								                <%
								            }
					    				}
							            %> --%>
					    			</td>
					    			<td class="recipe-views">
					    				<img src="<%= contextPath %>/images/recipe/views_icon.png">
					    				<span><%= recipe.getViews() %> views</span>
					    			</td>
					    		</tr>
					    	</table>
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