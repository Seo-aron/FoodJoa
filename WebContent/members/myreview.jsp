<%@page import="VOs.MealkitReviewVO"%>
<%@page import="VOs.MealkitVO"%>
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

ArrayList<String> reviewContents = new ArrayList<String>();

String id = (String) session.getAttribute("userId");
%>

<!DOCTYPE html>
<html lang="ko">

<head>
	<meta charset="UTF-8">
	<title>리뷰 관리</title>
	
	<script src="<%= contextPath %>/js/common/common.js"></script>
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="<%= contextPath %>/css/member/myreview.css">
</head>

<body>
	<h1>내가 쓴 리뷰</h1>
	<div class="myreview-container" style="display: block;">
		<div class="myreview-category-area">
			<input type="button" value="레시피" onclick="changeMyReview(0)">
			<input type="button" value="밀키트" onclick="changeMyReview(1)">
		</div>
		<div class="myreview-recipe">
			<table width="100%">
				<%
				if (recipeReviews == null || recipeReviews.size() <= 0) {
					%>
					<tr>
						<td align="center">
							<div class="myreview-none-label">
								작성한 리뷰가 없습니다.
							</div>
						</td>
					</tr>
					<%
				}
				else {
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
						%>
						<tr>
							<td><div class="myreview-cell">
								<table width="100%">
									<tr>
										<td rowspan="3" width="240px" style="vertical-align: top;">
											<div class="myreview-picture">
												<%
												if (reviewPictures != null && reviewPictures.size() > 0) {
													%>
													<img src="<%= contextPath %>/images/recipe/reviews/<%= reviewVO.getRecipeNo() %>/<%= id %>/<%= reviewPictures.get(0) %>">
													<%
												}
												%>											
											</div>
										</td>
										<td>
											<div class="myreview-title">
												<%= categoryStr %>
												<%= recipeVO.getTitle() %>
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div class="myreview-rating">
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
												<span class="myreview-postdate">
													<%= new SimpleDateFormat("yyyy-MM-dd").format(reviewVO.getPostDate()) %>
												</span>
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div class="myreview-contents">
												<% reviewContents.add(reviewVO.getContents()); %>
											</div>
										</td>
									</tr>
									<tr>
										<td class="myreview-button-area" colspan="2" align="right">
											<input type="button" value="수정" onclick="onRecipeReviewUpdate(<%= reviewVO.getNo() %>)">
											<input type="button" value="삭제" onclick="onRecipeReviewDelete(<%= recipeVO.getNo() %>, <%= reviewVO.getNo() %>)">
										</td>
									</tr>
								</table>
							</div></td>
						</tr>
						<%
					}
				}
				%>
			</table>
		</div>
		<div class="myreview-mealkit" style="display: none;">
			<table width="100%">
				<%
				if (mealkitReviews == null || mealkitReviews.size() <= 0) {
					%>
					<tr>
						<td align="center">
							<div class="myreview-none-label">
								작성한 리뷰가 없습니다.
							</div>
						</td>
					</tr>
					<%
				}
				else {					
					for (int i = 0; i < mealkitReviews.size(); i++) {
						MealkitVO mealkitVO = (MealkitVO) mealkitReviews.get(i).get("mealkit");
						MealkitReviewVO reviewVO = (MealkitReviewVO) mealkitReviews.get(i).get("review");
						MemberVO memberVO = (MemberVO) mealkitReviews.get(i).get("member");
						
						int category = mealkitVO.getCategory();
						String categoryStr = (category == 1) ? "한식" : 
								(category == 2) ? "일식" :
								(category == 3) ? "중식" :
								(category == 4) ? "양식" : "자취";
						categoryStr = "[" + categoryStr + "]";
						
						List<String> reviewPictures = null;
						
						if (reviewVO.getPictures() != null && !reviewVO.getPictures().equals("") && reviewVO.getPictures().length() > 0)
							reviewPictures = StringParser.splitString(reviewVO.getPictures());
						%>
						<tr>
							<td><div class="myreview-cell">
							<table width="100%">
								<tr>
									<td rowspan="3" width="240px" style="vertical-align: top;">
										<div class="myreview-picture">
											<%
											if (reviewPictures != null && reviewPictures.size() > 0) {
												%>
												<img src="<%= contextPath %>/images/mealkit/reviews/<%= reviewVO.getMealkitNo() %>/<%= id %>/<%= reviewPictures.get(0) %>">
												<%
											}
											%>											
										</div>
									</td>
									<td>
										<div class="myreview-title">
											<%= categoryStr %>
											<%= mealkitVO.getTitle() %>
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<div class="myreview-rating">
											<ul>
											<%
											float rating = reviewVO.getRating();
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
											<span class="myreview-postdate">
												<%= new SimpleDateFormat("yyyy-MM-dd").format(reviewVO.getPostDate()) %>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<div class="myreview-contents">
											<% reviewContents.add(reviewVO.getContents()); %>
										</div>
									</td>
								</tr>
								<tr>
									<td class="myreview-button-area" colspan="2" align="right">
										<input type="button" value="수정" onclick="onMealkitReviewUpdate(<%= reviewVO.getNo() %>)">
										<input type="button" value="삭제" onclick="onMealkitReviewDelete(<%= reviewVO.getNo() %>, <%= mealkitVO.getNo()%>)">
									</td>
								</tr>
							</table>
						</div></td>
						</tr>
						<%
					}
				}
				%>
			</table>
		</div>
	</div>
	
	
	<script>	
		function onRecipeReviewUpdate(reviewNo) {
			location.href = '<%= contextPath %>/Recipe/reviewUpdate?no=' + reviewNo;
		}
		
		function onRecipeReviewDelete(recipeNo, reviewNo) {
			if (confirm('정말로 삭제하시겠습니까?')) {
				$.ajax({
					url: '<%= contextPath %>/Recipe/reviewDeletePro',
				    type: "POST",
				    data: {
				    	no: reviewNo,
				    	recipeNo: recipeNo
				    },
				    dataType: "text",
				    success: function(responseData, status, jqxhr) {
						if(responseData == "1") {
							alert('리뷰를 삭제했습니다.');
							location.reload();
						}
						else {
							alert('리뷰 삭제에 실패했습니다.');
						}
				    },
				    error: function(xhr, status, error) {
				        console.log("error", error);
						alert('통신 에러');
				    }
				});
			}
		}
		
		function onMealkitReviewUpdate(reviewNo) {
			location.href = '<%= contextPath %>/Mealkit/reviewUpdate?no=' + reviewNo;
		}
		
		function onMealkitReviewDelete(reviewNo, mealkitNo) {
			if (confirm('정말로 삭제하시겠습니까?')) {
				$.ajax({
					url: '<%= contextPath %>/Mealkit/reviewDelete.pro',
				    type: "POST",
				    async: true,
				    data: {
				    	no: reviewNo,
				    	mealkitNo: mealkitNo
				    },
				    dataType: "text",
				    success: function(responseData) {
						if(responseData == "1") {
							alert('리뷰를 삭제했습니다.');
							location.reload();
						}
						else {
							alert('리뷰 삭제에 실패했습니다.');
						}
				    }
				});
			}
		}
	
		let categoryButtons = $(".myreview-category-area input");
		const categoryButtonStyles = [
	        { border: 'none', backgroundColor: '#BF917E', color: 'white' },
	        { border: '1px solid #BF917E', backgroundColor: 'white', color: '#BF917E' }
	    ];
		
		function changeMyReview(type) {
			$('.myreview-recipe').css('display', type == 0 ? 'block' : 'none');
			$('.myreview-mealkit').css('display', type == 0 ? 'none' : 'block');

			$.each(categoryButtons, function(index, button) {
		        var style = categoryButtonStyles[type === index ? 0 : 1];
		        $(button).css(style);
		    });
		}
		
		function setReviewContents() {
			let reviewContents = [
	            <%
	            for (int i = 0; i < reviewContents.size(); i++) {
	                String str = StringParser.escapeHtml(reviewContents.get(i));
	            %>
	                `<%= str.replace("\"", "\\\"") %>`<%= (i < reviewContents.size() - 1) ? "," : "" %>
	            <%
	            }
	            %>
	        ];
	        
	        $(".myreview-contents").each(function(index, element) {
				$(element).text(unescapeHtml(reviewContents[index]));
			})
		}
		
		window.onload = function() {
			setReviewContents();
			changeMyReview(0);
		}
	</script>
</body>
</html>