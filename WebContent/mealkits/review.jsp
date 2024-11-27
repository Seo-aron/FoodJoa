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
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="<%=contextPath%>/css/mealkit/review.css">
	
</head>
<body>
	<div id="review-container">
		<table>
			<tr>
				<td colspan="4" class="review-h2"><h2>리뷰</h2></td>
			</tr>
			<c:forEach var="review" items="${reviewvo}">
				<tr>
					<th>작성자</th>
					<td>
						<input type="text" name="id" value="user2" readonly>
						<input type="hidden" name="mealkit_no" value="${mealkit.no }" data-review-no="${review.no}">
					</td>
					<td>
						<span>평점: ${review.rating}</span>
					</td>
					<td>
						<div class="empathy-container">
							<button type="button" class="empathy-button" onclick="empathyCount(${review.no})">공감</button>
							<input type="text" name="empathy" value="${review.empathy}" 
							class="empathyInput" data-review-no="${review.no}" readonly>
						</div>
					</td>
				</tr>
				<tr>
					<th>사진</th>
					<td colspan="3">
						<img src="<%= contextPath %>/images/mealkit/review/${review.no}/${review.pictures}" alt="${review.pictures}">
					</td>
				</tr>
				<tr>
					<th>내용</th>
					<td colspan="3">
						<textarea name="contents" class="review-contents" rows="5" required>${review.contents}</textarea>
					</td>
				</tr>
			</c:forEach>
			<tr>
				<td colspan="4">
					<input type="button" value="리뷰 작성" class="review-button"
					onclick="location.href='<%=contextPath%>/Mealkit/reviewwrite?mealkit_no=${mealkit.no }'">
				</td>
			</tr>
		</table>
	</div>
	
	<script>	
		function empathyCount(no) {	
			let empathyValue = parseInt($('#empathyInput_' + no + '').val());
			let mealkit_no = parseInt($('input[name=mealkit_no][data-review-no=' + no + ']').val());

			$.ajax({
				url: '<%= contextPath %>/Mealkit/empathy.pro',
				type: 'POST',
				async: true,
				data: {
					empathyCount: empathyValue,
					mealkit_no: mealkit_no,
					no: no
				},
				dataType:"text",
				success: function(response) {
					if (response === "1") {
						alert('공감 했습니다 ');
						empathyValue++;
						$('#empathyInput_' + no).val(empathyValue);
						
					} else {
						alert('공감 실패: ');
					}
				}
			});
		}  
	</script>
	
</body>
</html>
