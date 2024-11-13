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
		  width: 32px;  /* 이미지 크기에 맞게 조정 */
		  height: 32px;  /* 이미지 크기에 맞게 조정 */
		  border: none;  /* 필요에 따라 테두리 제거 */
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
		<form action="#" method="post" enctype="multipart/form-data">
			<table width="100%" border="1">
				<tr>
					<td>
						<img src="<%= contextPath %>/images/recipe/thumbnails/<%= recipe.getNo() %>/<%= recipe.getThumbnail() %>">
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
						<input type="hidden" name="rating" value="5">
					</td>
				</tr>
				<tr>
					<td>
						리뷰 사진 업로드<br>
						<input type="file" name="pictureFiles"
							accept=".jpg,.jpeg,.png" multiple onchange="setPicturesString(this.files)">
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
						<input type="submit" value="리뷰 쓰기">
						<input type="button" value="취소" onclick="onCancleButton(event)">
					</td>
				</tr>
			</table>
		</form>
	</div>
	
	
	<script>
		// 문자열을 합치는 함수
		function combineStrings(strings) {
		    let result = '';
		    for (let str of strings) {
		        // 문자열 길이를 2바이트로 변환
		        let length = str.length;
		        let lengthBytes = String.fromCharCode(length >> 8, length & 0xFF);
		        // 길이 + 문자열 추가
		        result += lengthBytes + str;
		    }
		    return result;
		}
		
		function setPicturesString(files) {
			let strings = [];
			
			for (let i = 0; i < files.length; i++) {
				console.log("File name: " + files[i].name);
		        console.log("File size: " + files[i].size + " bytes");
		        strings.push(files[i].name);
		    }
			
			let pictures = combineStrings(strings);
			console.log("pictures : " + pictures);
			
			document.getElementsByName('pictures')[0].value = pictures;
		}
		
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
		
		function onCancleButton(event) {
			event.preventDefault();
			
			history.back();
		}
	</script>
</body>

</html>