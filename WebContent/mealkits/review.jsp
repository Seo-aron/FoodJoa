<%@page import="VOs.MemberVO"%>
<%@page import="VOs.MealkitReviewVO"%>
<%@page import="java.util.HashMap"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Common.StringParser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=utf-8");

String contextPath = request.getContextPath();

String id = (String) session.getAttribute("userId");

ArrayList<HashMap<String, Object>> list = (ArrayList<HashMap<String, Object>>) request.getAttribute("reviews");
%>
<c:set var="mealkit" value="${requestScope.mealkitvo}" />

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰</title>

<script src="https://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
<link rel="stylesheet" href="<%=contextPath%>/css/mealkit/review.css">

</head>
<body>
	<input type="hidden" name="mealkit_no" value="${mealkit.no }">
	<div id="review-container">
		<table class="list">
			<tr>
				<td colspan="4" class="review-h2"><h1>리뷰</h2></td>
			</tr>
			<%
			if (list.isEmpty()) {
			%>
			<tr>
				<td>등록된 리뷰가 없습니다.</td>
			</tr>
			<%
			} else {
				for (int i = 0; i < list.size(); i++) {
					HashMap<String, Object> review = list.get(i);
					
					MealkitReviewVO reviewVO = (MealkitReviewVO) review.get("reviewVO");
					MemberVO memberVO = (MemberVO) review.get("memberVO");
	
					List<String> pictures = StringParser.splitString(reviewVO.getPictures());	
			%>
			<tr>
				<th>작성자</th>
				<td class="nickname-td"><input type="text" name="id" class="id" value="<%=memberVO.getNickname()%>" readonly></td>
				<td><span>평점: <%=reviewVO.getRating()%></span></td>
			</tr>
			<tr>
				<th>후기</th>
				<td colspan="3">
					<div class="contents-container">
						<div class="review-images">
							<ul class="review-bxslider">
								<%
								for (String picture : pictures) {
								%>
								<li>
									<img src="<%=contextPath%>/images/mealkit/reviews/<%=reviewVO.getMealkitNo()%>/<%=reviewVO.getId()%>/<%=picture%>"
										class="review-image" alt="<%=picture%>">
								</li>
								<%
								}
								%>
							</ul>
						</div>
						<div class="review-contents-container">
							<textarea name="contents" class="review-contents" rows="5" readonly required><%=reviewVO.getContents()%></textarea>
						</div>
					</div>
				</td>
			</tr>

			<%
				} // for
			} // esle
			%>
			<tr>
				<td colspan="4">
					<input type="button" value="리뷰 작성" class="review-button"
						onclick="location.href='<%=contextPath%>/Mealkit/reviewwrite?no=${mealkit.no }'">
				</td>
			</tr>
		</table>
	</div>
</body>
</html>
