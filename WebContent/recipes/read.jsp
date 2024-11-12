<%@page import="VOs.RecipeReviewVO"%>
<%@page import="java.util.List"%>
<%@page import="Common.StringParser"%>
<%@page import="VOs.RecipeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
	
	RecipeVO recipe = (RecipeVO) request.getAttribute("recipe");
	String ratingAvg = (String) request.getAttribute("ratingAvg");
			
	String compressedContents = recipe.getContents();
	List<String> parsedIngredient = StringParser.parseStringWithLength(recipe.getIngredient());
	List<String> parsedIngredientAmount = StringParser.parseStringWithLength(recipe.getIngredientAmount());
	List<String> parsedOrders = StringParser.parseStringWithLength(recipe.getOrders());
	
	List<RecipeReviewVO> reviewes = (List<RecipeReviewVO>) request.getAttribute("reviewes");
%>
    
    
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pako/2.1.0/pako.min.js"></script>
	
	<link rel="stylesheet" href="<%=contextPath%>/css/recipe/read.css">    
</head>

<body>
	<div id="container">
		<table width="100%">
			<tr>
				<td>
					<input type="button" value="리뷰 쓰기" onclick="">
					<input type="button" value="목록" onclick="onListButton()">
				</td>
			</tr>
			<tr>
				<td>			
					<ul class="recipe-list">
					    <li class="profile-img">
					        <img alt="프로필 사진" src="">
					    </li>
					    <li class="recipe-title">
					        <%= recipe.getTitle() %>
					    </li>
					    <li class="recipe-id">
					        <%= recipe.getId() %>
					    </li>
					    <li class="recipe-info">
					        <p>
					            <img src="<%= contextPath %>/images/recipe/full_star.png" class="rating-star">
					            <%= ratingAvg %>
					        </p>
					        <p>조회수 : <%= recipe.getViews() %></p>
					    </li>
					</ul>
				</td>	
			</tr>
			<tr>
				<td align="center">
					<div id="thumbnail">
						<img src="<%= contextPath %>/images/recipe/thumbnails/<%= recipe.getNo() %>/<%= recipe.getThumbnail() %>">
						<div id="wishlist">
							<button id="wishlist-button">레시피 찜하기</button>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td align="center">
					<div id="description">
						<%= recipe.getDescription() %>
					</div>
				</td>
			</tr>
			<tr>
				<td align="center">
					<div id="contents"></div>
				</td>				
			</tr>
			<tr>
				<td>
					<div id="ingredient">
						<p>사용한 재료</p>
						<%
						for (int i = 0; i < parsedIngredient.size(); i++) {
							String ingredient = parsedIngredient.get(i);
							String ingredientAmout = parsedIngredientAmount.get(i);
							%>
							<p>
								<span><%= ingredient %></span>
								<span><%= ingredientAmout %></span>
							</p>
							<%
						}
						%>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div id="orders">
						<p>조리 순서</p>
						<%
							for (int i = 0; i < parsedOrders.size(); i++) {
							String orders = parsedOrders.get(i);
						%>
							<p>
								<span><%=orders%></span>
							</p>
							<%
						}
						%>
					</div>
				</td>
			</tr>
			<tr>
				<td align="center">
					<%
					if (reviewes == null || reviewes.size() == 0) {
						%>
						등록된 리뷰가 없습니다.
						<%
					}
					else {
						
					}
					%>
				</td>
			</tr>
		</table>
	</div>
	
	
	<script>
		function onListButton() {
			location.href = '<%= contextPath %>/Recipe/list';
		}
	
		/* id 파라미터 부분 로그인 완성 되면 수정 필요 */
		$("#wishlist-button").click(function() {
			$.ajax({
				url: "<%= contextPath %>/Recipe/wishlist",
				type: "POST",
				data: {
					id: "admin",
					recipeNo: <%= recipe.getNo() %>
				},
				dataType: "text",
				success: function(responseData, status, jqxhr) {
					if (responseData == "2") {
						alert("이미 찜 목록에 있습니다.");
					}
					else if (responseData == "1") {
						alert("찜 목록에 추가 되었습니다.");
					}
					else {
						alert("찜 목록 추가에 실패 했습니다.");
					}
				},
				error: function(xhr, status, error) {
					console.log(error);
					alert("찜 목록 추가에 실패 했습니다.");
				}
			});
		});
		
	    function decompressAndDisplay() {
		    var compressedData = "<%= compressedContents %>";
		    
	        try {
	            // Base64 디코딩
	            const binaryString = atob(compressedData);
	            const bytes = new Uint8Array(binaryString.length);
	            for (let i = 0; i < binaryString.length; i++) {
	                bytes[i] = binaryString.charCodeAt(i);
	            }

	            const decompressedBytes = pako.inflate(bytes);
	            
	            const decompressedText = new TextDecoder('utf-8').decode(decompressedBytes);
	            
	            document.getElementById('contents').innerHTML = decompressedText;
	        } catch (error) {
	            console.error("압축 해제 중 오류 발생:", error);
	            document.getElementById('contents').innerHTML = "내용을 표시할 수 없습니다.";
	        }
	    }
	
	    // 페이지 로드 시 함수 실행
	    window.onload = decompressAndDisplay;
</script>
</body>

</html>