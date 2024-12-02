<%@page import="java.util.List"%>
<%@page import="Common.StringParser"%>
<%@page import="VOs.MealkitVO"%>
<%@page import="VOs.RecipeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
	
<<<<<<< HEAD
	//RecipeVO recipe = (RecipeVO) request.getAttribute("recipe");
	MealkitVO mealkit = (MealkitVO) request.getAttribute("mealkit");
	
	List<String> pictures = StringParser.splitString(mealkit.getPictures());
=======
    String nickName = (String) request.getAttribute("nickName");
>>>>>>> aron
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
<<<<<<< HEAD
	<div id="recipe-review-container">
		<h1>레시피 리뷰 작성</h1>
		<form id="frmReview" action="#" method="post" enctype="multipart/form-data">
			<input type="hidden" id="recipe_no" name="recipe_no" value="<%= mealkit.getNo() %>">
			
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
	
	
	<script src="<%= contextPath %>/js/mealkit/reviewWrite.js"></script>
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
=======
    <div id="container">
        <h2>리뷰 작성</h2>
        <form action="<%=contextPath %>/Mealkit/reviewwrite.pro" method="post" enctype="multipart/form-data">
            <table>
                <tr>
                    <th>작성자</th>
                    <td>
                        <input type="text" name="nickname" value="<%=nickName %>" readonly>
                        <input type="hidden" name="mealkit_no" value="${mealkit_no }">
                    </td>
                    <td>
                        평점:
                        <div id="rating_buttons">
                            <div class="rating_button" id="rating1" onclick="setRating(1)">1</div>
                            <div class="rating_button" id="rating2" onclick="setRating(2)">2</div>
                            <div class="rating_button" id="rating3" onclick="setRating(3)">3</div>
                            <div class="rating_button" id="rating4" onclick="setRating(4)">4</div>
                            <div class="rating_button" id="rating5" onclick="setRating(5)">5</div>
                        </div>
                        <input type="hidden" name="rating" value="" id="ratingInput">
                    </td>
                </tr>
                <tr>
                    <th>사진</th>
                    <td colspan="3">
                        <input type="file" name="pictures" accept="image/*" required>
                    </td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td colspan="3">
                        <textarea name="contents" rows="5" style="width: 100%;" required></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <button type="submit">작성</button>
                        <button type="button" onclick="confirmCancel()">취소</button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
>>>>>>> aron
</body>

</html>