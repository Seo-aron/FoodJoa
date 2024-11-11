<%@page import="java.util.List"%>
<%@page import="Common.StringParser"%>
<%@page import="VOs.RecipeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
	
	/* String compressedContents = (String) request.getAttribute("contents"); */
	
	RecipeVO recipe = (RecipeVO) request.getAttribute("recipe");
	
	String compressedContents = recipe.getContents();
	List<String> parsedIngredient = StringParser.parseStringWithLength(recipe.getIngredient());
	List<String> parsedIngredientAmount = StringParser.parseStringWithLength(recipe.getIngredientAmount());
	List<String> parsedOrders = StringParser.parseStringWithLength(recipe.getOrders());
%>
    
    
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pako/2.1.0/pako.min.js"></script>
    
</head>

<body>
	<div id="container">
		<div id="title">
			<img alt="프로필 사진" src="">
			<%= recipe.getTitle() %>
			<%= recipe.getId() %>
			<img src="<%= contextPath %>/images/recipe/full_star.png">
			<%= recipe.getRating() %>
			조회수 : <%= recipe.getViews() %>
		</div>
		<div id="thumbnail">
			<img src="<%= contextPath %>/images/recipe/thumbnails/<%= recipe.getNo() %>/<%= recipe.getThumbnail() %>">
			<div id="wishlist">
				<button id="wishlist-button" onclick="">레시피 찜하기</button>
			</div>
		</div>
		<div id="description">
			<%= recipe.getDescription() %>
		</div>	
		<div id="contents">
		</div>
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
		<div id="orders">
			<p>조리 순서</p>
			<%
			for (int i = 0; i < parsedOrders.size(); i++) {
				String orders = parsedOrders.get(i);
				%>
				<p>
					<span><%= orders %></span>
				</p>
				<%
			}
			%>
		</div>
	</div>
	
	
	<script>	
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