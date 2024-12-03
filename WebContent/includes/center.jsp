<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bxslider@4.2.17/dist/jquery.bxslider.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bxslider@4.2.17/dist/jquery.bxslider.min.js"></script>	
	<link rel="stylesheet" href="<%= contextPath %>/css/includes/center.css">
	
	<script>
        
		$(function() {
			$('.bx_slider').bxSlider({
				adaptiveHeight: true,
				auto : true,
				pager : false
			});
		});
	</script>
</head>

<body>
	<div id="container">
		<div class="event_banner">
			<img src="${contextPath}/images/mainpage/main_banner.png" alt="이벤트 배너">
		</div>
		<div class="rank">
			<ul class="bx_slider">
				<li>
					<div class="recipe-slider-cell">
						<div class="slide-cell-header">
							<img src="${contextPath}/images/mainpage/trophy.png" alt="별모양 이미지">
							<span>레시피 BEST</span>
						</div>
						<div class="block-cell">
							<div class="image-area">
								<img src="${contextPath}/images/mainpage/foodrank1.jpg" alt="레시피랭킹1">
								<div class="rank-flag">
									<img class="rank-flag" src="${contextPath}/images/mainpage/rankflag.png">
								</div>
								<div class="rank-label">1</div>
							</div>
							<div class="label-area">
								<p>레시피 제목</p>
								<p>작성자</p>
								<p>평점</p>
							</div>
						</div>
						<div class="block-cell">
							<div class="image-area">
								<img src="${contextPath}/images/mainpage/foodrank1.jpg" alt="레시피랭킹1">
								<div class="rank-flag">
									<img class="rank-flag" src="${contextPath}/images/mainpage/rankflag.png">
								</div>
								<div class="rank-label">2</div>
							</div>
							<div class="label-area">
								<p>레시피 제목</p>
								<p>작성자</p>
								<p>평점</p>
							</div>
						</div>
						<div class="block-cell">
							<div class="image-area">
								<img src="${contextPath}/images/mainpage/foodrank1.jpg" alt="레시피랭킹1">
								<div class="rank-flag">
									<img class="rank-flag" src="${contextPath}/images/mainpage/rankflag.png">
								</div>
								<div class="rank-label">3</div>
							</div>
							<div class="label-area">
								<p>레시피 제목</p>
								<p>작성자</p>
								<p>평점</p>
							</div>
						</div>
					</div>
				</li>
				<li>
					<div class="store-slider-cell">
						<div class="slide-cell-header">
							<img src="${contextPath}/images/mainpage/trophy.png" alt="별모양 이미지">
							<span>스토어 BEST</span>
						</div>
						<div class="block-cell">
							<div class="image-area">
								<img src="${contextPath}/images/mainpage/foodrank1.jpg" alt="레시피랭킹1">
								<div class="rank-flag">
									<img class="rank-flag" src="${contextPath}/images/mainpage/rankflag.png">
								</div>
								<div class="rank-label">1</div>
							</div>
							<div class="label-area">
								<p>상품명</p>
								<p>평점</p>
								<p>가격</p>
							</div>
						</div>
						<div class="block-cell">
							<div class="image-area">
								<img src="${contextPath}/images/mainpage/foodrank1.jpg" alt="레시피랭킹1">
								<div class="rank-flag">
									<img class="rank-flag" src="${contextPath}/images/mainpage/rankflag.png">
								</div>
								<div class="rank-label">2</div>
							</div>
							<div class="label-area">
								<p>상품명</p>
								<p>평점</p>
								<p>가격</p>
							</div>
						</div>
						<div class="block-cell">
							<div class="image-area">
								<img src="${contextPath}/images/mainpage/foodrank1.jpg" alt="레시피랭킹1">
								<div class="rank-flag">
									<img class="rank-flag" src="${contextPath}/images/mainpage/rankflag.png">
								</div>
								<div class="rank-label">3</div>
							</div>
							<div class="label-area">
								<p>상품명</p>
								<p>평점</p>
								<p>가격</p>
							</div>
						</div>
					</div>
				</li>
			</ul>
		</div>
	</div>
</body>


</html>