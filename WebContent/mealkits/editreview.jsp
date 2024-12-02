<%@page import="java.util.List"%>
<%@page import="Common.StringParser"%>
<%@page import="VOs.MealkitVO"%>
<%@page import="VOs.MealkitReviewVO"%>
<%@page import="VOs.RecipeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
	
	// MealkitVO mealkit = (MealkitVO) request.getAttribute("mealkit");
	MealkitReviewVO review = (MealkitReviewVO) request.getAttribute("reviewvo");
	String nickName = (String) request.getAttribute("nickName");
	
	List<String> pictures = StringParser.splitString(review.getPictures());
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script src="<%= contextPath %>/js/common/common.js"></script>
	
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="<%=contextPath%>/css/mealkit/reviewWrite.css">
</head>

<body>
	<div id="recipe-review-container">
		<h1>밀키트 리뷰 수정</h1>
		<form id="frmReview" action="#" method="post" enctype="multipart/form-data">
			<input type="hidden" id="recipe_no" name="recipe_no" value="<%= mealkit.getNo() %>">
			<input type="hidden" id="nickname" name="nickname" value="<%=nickName%>"/>
					
			<table width="100%">
				<tr>
					<td align="center">
						<div class="thumbnail-area">						
							<img src="<%= contextPath %>/images/recipe/thumbnails/<%= mealkit.getNo() %>/<%= pictures.get(0) %>">
						</div>
					</td>
				</tr>
				<tr>
					<td align="center">
						<div class="title-area">
							<%= mealkit.getTitle() %>
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<div class="rating-star-area">
							<div class="rating-star-label">
								평점 선택
							</div>
								<img src="<%= contextPath %>/images/recipe/full_star.png" onclick="setRating(event, 1)">
								<img src="<%= contextPath %>/images/recipe/full_star.png" onclick="setRating(event, 2)">
								<img src="<%= contextPath %>/images/recipe/full_star.png" onclick="setRating(event, 3)">
								<img src="<%= contextPath %>/images/recipe/full_star.png" onclick="setRating(event, 4)">
								<img src="<%= contextPath %>/images/recipe/full_star.png" onclick="setRating(event, 5)">
							<input type="hidden" id="rating" name="rating" value="5">
						</div>
					</td>
				</tr>
				<tr>
					<td>
						<p class="review-picture-label">리뷰 사진 업로드</p>
						<div class="preview-area">
	    					<ul id="imagePreview">
	    						<li>
	    							<input type="file" id="pictureFiles" name="pictureFiles" 
										accept=".jpg,.jpeg,.png" multiple onchange="handleFileSelect(this.files)">
	    						</li>
	    					</ul>
    					</div>
							
						<input type="hidden" id="pictures" name="pictures">
					</td>
				</tr>
				<tr>
					<td>					
						<div class="review-contents-label">
							리뷰 내용 작성
						</div>
						<div class="reivew-contents-area">	
							<textarea id="contents" name="contents"></textarea>
						</div>
					</td>
				</tr>
				<tr>
					<td align="right">
						<div class="review-button-area">
							<input type="button" value="리뷰 쓰기" onclick="onSubmit(event,'<%= contextPath %>')">
							<input type="button" value="취소" onclick="onCancleButton(event)">
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
	
	
	<script src="<%= contextPath %>/js/mealkit/editreview.js"></script>
	<script>
		function setRating(event, ratingValue) {
			event.preventDefault();
			
			let emptyStarPath = '<%= contextPath %>/images/recipe/empty_star.png';
			let fullStarPath = '<%= contextPath %>/images/recipe/full_star.png';
	
			let startButtons = $(".rating-star-area img");
			startButtons.each(function(index, element) {
	
				let path = (index < ratingValue) ? fullStarPath : emptyStarPath;
				$(element).attr('src', path);
			});
	
			document.getElementsByName('rating')[0].value = ratingValue;
		}
	</script>
</body>

</html>