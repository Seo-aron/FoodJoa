<%@page import="java.util.List"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="Common.StringParser"%>
<%@page import="VOs.RecipeReviewVO"%>
<%@page import="VOs.MemberVO"%>
<%@page import="VOs.RecipeVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=utf-8");

String contextPath = request.getContextPath();

HashMap<String, Object> reviews = (HashMap<String, Object>) request.getAttribute("reviews");

ArrayList<HashMap<String, Object>> recipeReviews = (ArrayList<HashMap<String, Object>>) reviews.get("recipe"); 
ArrayList<HashMap<String, Object>> mealkitReviews = (ArrayList<HashMap<String, Object>>) reviews.get("mealkit");

String id = (String) session.getAttribute("userId");
%>

<!DOCTYPE html>
<html lang="ko">

<head>
	<meta charset="UTF-8">
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
	<link rel="stylesheet"
		href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css">
	<link rel="stylesheet" href="<%=contextPath%>/css/member/myreview.css">
	<title>리뷰 관리</title>
</head>

<body>
	<div class="myreview-container">
		<h1>내가 쓴 리뷰</h1>
		<div class="myreview-button-area">
			<input type="button" value="레시피">
			<input type="button" value="밀키트">
		</div>
		<div class="myreview-recipe">
			<table width="100%">
				<%
				for (int i = 0; i < recipeReviews.size(); i++) {
					RecipeVO recipeVO = (RecipeVO) recipeReviews.get(i).get("recipe");
					RecipeReviewVO reviewVO = (RecipeReviewVO) recipeReviews.get(i).get("review");
					MemberVO memberVO = (MemberVO) recipeReviews.get(i).get("member");
					
					int category = recipeVO.getCategory();
					String categoryStr = (category == 1) ? "한식" : 
							(category == 2) ? "일식" :
							(category == 3) ? "중식" :
							(category == 4) ? "양식" : "자취";
					categoryStr = "[" + categoryStr + "]";
					
					List<String> reviewPictures = null;
					
					if (reviewVO.getPictures() != null && !reviewVO.getPictures().equals("") && reviewVO.getPictures().length() > 0)
						reviewPictures = StringParser.splitString(reviewVO.getPictures());
					
					System.out.println("reviewPictures : " + reviewPictures.get(0));
					%>
					<tr>
						<td>
							<table width="100%">
								<tr>
									<td>
										<div class="review-title">
											<%= categoryStr %>
											<%= recipeVO.getTitle() %>
										</div>
									</td>
									<td rowspan="3">
										<div class="review-picture">
											<%
											if (reviewPictures != null && reviewPictures.size() > 0) {
												%>
												<img src="<%= contextPath %>/images/recipe/reviews/<%= reviewVO.getRecipeNo() %>/<%= id %>/<%= reviewPictures.get(0) %>">
												<%
											}
											%>											
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<div class="review-rating">
											<ul>
											<%
											int rating = reviewVO.getRating();
											for (int startIndex = 1; startIndex <= 5; startIndex++) {
												String starImage = (startIndex <= rating) ? "full_star.png" : "empty_star.png";
												%>
								                <li>
								                	<img src="<%= contextPath %>/images/recipe/<%= starImage %>" alt="별점">
								                </li>
								                <%
											}
											%>
											</ul>
											<span><%= new SimpleDateFormat("yyyy-MM-dd").format(reviewVO.getPostDate()) %></span>
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<div class="review-contents">
											<%= reviewVO.getContents() %>
										</div>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<%
				}
				%>
			</table>
		</div>
		<div class="myreview-mealkit">
		</div>
	</div>
</body>
</html>