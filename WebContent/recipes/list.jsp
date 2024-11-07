<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>나만의 레시피 공유</title>
	
	<style type="text/css">
		#container {
			width: 1000px;
		}
		
		.list_cell {
			text-align: center;
			width: 380px;
			height: 400px;
		}
		
		.review_star {
			width: 32px;
			height: 32px;
		}
		
		.thumbnail {
			width: 256px;
			height: 256px;
		}
	</style>
</head>

<body>
	<div id="container">
		<table border="1">
			<tr>
				<td class="list_cell">
					<a href="#">
						<img class="thumbnail" src="<%= contextPath %>/images/recipe/test_thumbnail.png">
						<p>요리 이름</p>
						<p>작성자 이름</p>
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<span>5</span>
					</a>
				</td>
				<td class="list_cell">
					<a href="#">
						<img class="thumbnail" src="<%= contextPath %>/images/recipe/test_thumbnail.png">
						<p>요리 이름</p>
						<p>작성자 이름</p>
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<span>5</span>
					</a>
				</td>
				<td class="list_cell">
					<a href="#">
						<img class="thumbnail" src="<%= contextPath %>/images/recipe/test_thumbnail.png">
						<p>요리 이름</p>
						<p>작성자 이름</p>
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<span>5</span>
					</a>
				</td>
				<td class="list_cell">
					<a href="#">
						<img class="thumbnail" src="<%= contextPath %>/images/recipe/test_thumbnail.png">
						<p>요리 이름</p>
						<p>작성자 이름</p>
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<span>5</span>
					</a>
				</td>
			</tr>
			<tr>
				<td class="list_cell">
					<a href="#">
						<img class="thumbnail" src="<%= contextPath %>/images/recipe/test_thumbnail.png">
						<p>요리 이름</p>
						<p>작성자 이름</p>
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<span>5</span>
					</a>
				</td>
				<td class="list_cell">
					<a href="#">
						<img class="thumbnail" src="<%= contextPath %>/images/recipe/test_thumbnail.png">
						<p>요리 이름</p>
						<p>작성자 이름</p>
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<span>5</span>
					</a>
				</td>
				<td class="list_cell">
					<a href="#">
						<img class="thumbnail" src="<%= contextPath %>/images/recipe/test_thumbnail.png">
						<p>요리 이름</p>
						<p>작성자 이름</p>
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<span>5</span>
					</a>
				</td>
				<td class="list_cell">
					<a href="#">
						<img class="thumbnail" src="<%= contextPath %>/images/recipe/test_thumbnail.png">
						<p>요리 이름</p>
						<p>작성자 이름</p>
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<img class="review_star" src="<%= contextPath %>/images/recipe/full_star.png">
						<span>5</span>
					</a>
				</td>
			</tr>
		</table>
	</div>
</body>

</html>