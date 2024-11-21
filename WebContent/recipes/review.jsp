<%@page import="VOs.RecipeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
	
	RecipeVO recipe = (RecipeVO) request.getAttribute("recipe");
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	
	<style type="text/css">
		#container {
			width: 1200px;
			margin: 0 auto;
		}
		
		#thumbnail {
			width: 64px;
			height: 64px;
		}
		
		#pictureFiles {
		    color: transparent;
		    width: 128px;
		    height: 128px;

			background-image: url('../images/recipe/file_select_button.png');
			background-repeat: no-repeat;
			background-position: center;
			background-size: cover;
			
			cursor: pointer;
		}
		
		#pictureFiles::-webkit-file-upload-button {
		    visibility: hidden;
		}
		
		.preview_image {
			width: 128px;
			height: 128px;
			border: 1px solid black;
		}
        
		li {
			list-style-type: none;
			margin-left: 0;
		}
		
		.stars li {
			float: left;
		}
		
		.star-button {
			background-image: url('../images/recipe/full_star.png');
			background-repeat: no-repeat;
			background-position: center;
			background-size: cover;
			width: 32px;
			height: 32px;
			border: none;
			cursor: pointer;
		}
		
		#contents {
			width: 100%;
			height: 500px;
		}
	</style>
</head>

<body>
	<div id="container">
		<form id="frmReview" action="#" method="post" enctype="multipart/form-data">
			<input type="hidden" id="recipe_no" name="recipe_no" value="<%= recipe.getNo() %>">
			
			<table width="100%" border="1">
				<tr>
					<td>
						<img id="thumbnail"
							src="<%= contextPath %>/images/recipe/thumbnails/<%= recipe.getNo() %>/<%= recipe.getThumbnail() %>">
						<%= recipe.getTitle() %>
					</td>
				</tr>
				<tr>
					<td>
						<ul class="stars">
							<li><button class="star-button" onclick="setRating(event, 1)"></button></li>
							<li><button class="star-button" onclick="setRating(event, 2)"></button></li>
							<li><button class="star-button" onclick="setRating(event, 3)"></button></li>
							<li><button class="star-button" onclick="setRating(event, 4)"></button></li>
							<li><button class="star-button" onclick="setRating(event, 5)"></button></li>
						</ul>
						<input type="hidden" id="rating" name="rating" value="5">
					</td>
				</tr>
				<tr>
					<td>
						리뷰 사진 업로드<br>
						<ul>
						</ul>
    					<div id="imagePreview"></div>
   						<input type="file" id="pictureFiles" name="pictureFiles" 
							accept=".jpg,.jpeg,.png" multiple onchange="handleFileSelect(this.files)">
							
						<input type="hidden" id="pictures" name="pictures">
					</td>
				</tr>
				<tr>
					<td>
						<textarea id="contents" name="contents"></textarea>
					</td>
				</tr>
				<tr>
					<td>
						<input type="button" value="리뷰 쓰기" onclick="onSubmit(event,'<%= contextPath %>')">
						<input type="button" value="취소" onclick="onCancleButton(event)">
					</td>
				</tr>
			</table>
		</form>
	</div>
	
	
	<script src="<%= contextPath %>/js/recipe/review.js"></script>
	<script>
		function setRating(event, ratingValue) {
			event.preventDefault();
	
			let emptyStarPath = '<%= contextPath %>/images/recipe/empty_star.png';
			let fullStarPath = '<%= contextPath %>/images/recipe/full_star.png';
	
			let startButtons = $(".star-button");
			startButtons.each(function(index, element) {
	
				let path = (index < ratingValue) ? fullStarPath : emptyStarPath;
				$(element).css('background-image', 'url(' + path + ')');
			});
	
			document.getElementsByName('rating')[0].value = ratingValue;
		}
	</script>
</body>

</html>