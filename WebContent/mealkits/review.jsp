<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	
	String contextPath = request.getContextPath();
	String nickname = (String) session.getAttribute("nickname");
%>
<c:set var="mealkit" value="${requestScope.mealkitvo}" />
<c:set var="review" value="${requestScope.reviewvo}" />
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>리뷰</title>
	
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	<link rel="stylesheet" href="<%=contextPath%>/css/mealkit/review.css">
	
	<script>
		let empathValue = parseInt($("input[name=empathy]").val())
	
		function empathyCount() {	
			$.ajax({
				url: '<%= contextPath %>/Mealkit/empathy',
				type: 'POST',
				async: true,
				data: {
					empathyCount: empathValue,
					mealkitNo: '${mealkit.no}'
				},
				success: function(response) {
					if (response.success) {
						console.log('공감 했습니다 ');
						empathValue++;
						document.getElementById('empathyInput').value = empathValue;
						
					} else {
						alert('공감 실패: ');
					}
				}
			});
		}  
	</script>
</head>
<body>
	<div id="container">
		<h2>리뷰</h2>
		<table>
			<tr>
				<th>작성자</th>
				<td>
					<input type="text" name="id" value="user2" readonly>
				</td>
				<td>
					평점: <input type="hidden" name="rating" value="" id="ratingInput">
				</td>
				<td>
					<div class="empathy-container">
						<button type="button" class="empathy-button" onclick="empathyCount()">공감</button>
						<input type="text" name="empathy" value="${review.empathy }" id="empathyInput" readonly>
					</div>
				</td>
			</tr>
			<tr>
				<th>사진</th>
				<td colspan="3">
					<img src="<%= contextPath %>/images/recipe/test_thumbnail.png" alt="Review Image">
				</td>
			</tr>
			<tr>
				<th>내용</th>
				<td colspan="3">
					<textarea name="contents" rows="5" required>${review.contents}</textarea>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<input type="button" value="리뷰 작성" 
					onclick="location.href='<%=contextPath%>/Mealkit/reviewwrite?mealkit_no=${mealkit.no }'">
				</td>
			</tr>
		</table>
	</div>
</body>
</html>
