<%@ page import="java.util.HashMap"%>
<%@ page import="VOs.RecipeVO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=utf-8");

String contextPath = request.getContextPath();

String id = (String) session.getAttribute("userId");
%>

<c:set var="recentRecipes" value="${ recentViewInfos.recipe }" />
<c:set var="recentMealkits" value="${ recentViewInfos.mealkit }" />

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>최근 본 글 목록</title>
	<link
		href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap"
		rel="stylesheet">
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	
	<style>
		.recent-container {
			width: 1200px;
			margin: 0 auto;
			font-family: "Noto Serif KR", serif;
		}
		
		.recent-category-area {
			margin-bottom: 20px;
		}
		
		.recent-category-area input {
			font-family: "Noto Serif KR", serif;
			font-size: 1rem;
			padding: 8px 16px;
			border-radius: 5px;
			cursor: pointer;
		}
		
		.recent-view-grid {
			display: grid;
			grid-template-columns: repeat(2, 1fr);
			gap: 25px;
			width: 100%;
		}
		
		.recent-view-item {
			border: 1px solid #ddd;
			border-radius: 5px;
			box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
			text-align: center;
			display: flex;
			align-items: center;
			padding: 10px;
		}
		
		.recent-view-item img {
			max-width: 150px;
			height: 150px;
			margin-right: 20px;
		}
		
		.recent-view-item .info {
			text-align: left;
		}
	</style>
</head>

<body>
	<div id="recent-container">
		<div class="recent-category-area">
			<input type="button" value="레시피" onclick="changeMyReview(0)">
			<input type="button" value="밀키트" onclick="changeMyReview(1)">
		</div>

		<!-- 최근 본 레시피 목록 -->
		<div id="recentViewRecipe" class="recent-view" style="display: none;">
			<div class="recent-view-grid">
				<c:forEach var="item" items="${recentRecipes}">
					<c:if test="${item.recipeVO != null}">
						<div class="recent-view-item">
							<a
								href="<%= request.getContextPath() %>/Recipe/read?no=${item.recipeVO.no}">
								<img
								src="<%= request.getContextPath() %>/images/recipe/thumbnails/${item.recipeVO.no}/${item.recipeVO.thumbnail}"
								alt="${item.recipeVO.title}">
							</a>

							<div class="info">
								<div>
									<b>${item.recipeVO.title}</b>
								</div>
								<div>작성자: ${item.memberVO.nickname}</div>
								<div>${item.recipeVO.description}</div>
								<div>평점: ${item.averageRating}</div>
							</div>
						</div>
					</c:if>
				</c:forEach>
			</div>
		</div>

		<!-- 최근 본 밀키트 목록 -->
		<div id="recentViewMealKit" class="recent-view" style="display: none;">
			<div class="recent-view-grid">
				<c:forEach var="item" items="${recentMealkits}">
					<c:if test="${item.mealkitVO != null}">
						<div class="recent-view-item">
							 <a href="<%= request.getContextPath() %>/Mealkit/info?no=${item.mealkitVO.no}">
                     <img src="<%= request.getContextPath() %>/images/mealkit/thumbnails/${item.mealkitVO.no}/${item.mealkitVO.id}/${item.mealkitVO.pictures.substring(4)}" 
                             alt="${item.mealkitVO.title}">
                             </a>
							<div class="info">
								<div>
									<b>${item.mealkitVO.title}</b>
								</div>
								<div>작성자: ${item.memberVO.nickname}</div>
								<div>가격: ${item.mealkitVO.price}</div>
								<div>평점: ${item.averageRating}</div>
							</div>
						</div>
					</c:if>
				</c:forEach>
			</div>
		</div>
	</div>


	<script>
		let categoryButtons = $(".recent-category-area input");
		const categoryButtonStyles = [ {
			border : 'none',
			backgroundColor : '#BF917E',
			color : 'white'
		}, {
			border : '1px solid #BF917E',
			backgroundColor : 'white',
			color : '#BF917E'
		} ];

		function changeMyReview(type) {
			$('#recentViewRecipe').css('display', type == 0 ? 'block' : 'none');
			$('#recentViewMealKit')
					.css('display', type == 0 ? 'none' : 'block');

			$.each(categoryButtons, function(index, button) {
				var style = categoryButtonStyles[type === index ? 0 : 1];
				$(button).css(style);
			});
		}

		window.onload = changeMyReview(0);
	</script>
</body>
</html>
