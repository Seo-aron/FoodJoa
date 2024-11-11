<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	
	String contextPath = request.getContextPath();
%>
<c:set var="mealkit" value="${requestScope.mealkitvo}"/>

<!DOCTYPE html>
<html>
<head>
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
  	<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
  	<link rel="stylesheet" href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css">
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<style type="text/css">
		#container {
			width: 1000px;
			display: flex;
			margin: 20px auto;
		}
		.info_image, .info_text {
			padding: 20px;
		}
		.info_image {
			width: 450px;
			text-align: center;
			margin-right: 20px;
		}
		.bxslider img {
			width: 400px;
			height: 400px;
			border-radius: 5px;
		}
		<!-- 상품 수량 정하는 부분 -->
		.amount_count {
			position: relative;
			width: 120px;
			display: flex;
			border: 1px solid #ccc;
			border-radius: 4px;
			overflow: hidden;
		}
		
		.amount_count input {
			position: relative;
			width: 80px;
			height: 40px;
			text-align: center;
			border: 1px solid;
			font-size: 18px;
			outline: none;
			padding-right: 20px;
		}
		
		.amount_controls {
			position: relative;
	    	right: 0; 
			width: 20px;
			display: flex;
			flex-direction: column;
   			justify-content: space-between;
		}
		
		.amount_plus, .amount_minus {
			width: 100%;
			height: 20px;
			background-color: #f0f0f0;
			border: none;
			font-size: 14px;
			cursor: pointer;
			display: flex;
			align-items: center;
			justify-content: center;
		}
		
		.amount_plus {
			border-bottom: 1px solid #ccc;
		}
		.amount_minus {
			border-top: 1px solid #ccc;
		}
		<!-- 구매, 장바구니, 찜하기 버튼 -->
		.button_row {
			display: flex;
			gap: 10px;
			margin-top: 10px;
		}
		
		.button_row button {
			width: 100px;
			height: 40px;
			border: none;
			border-radius: 5px;
			font-size: 16px;
			font-weight: bold;
			cursor: pointer;
		}
		
		.buy_button {
			background-color: #48d1cc;
			color: white;
		}
		
		.cart_button {
			background-color: white;
			color: black;
			border: 1px solid #ccc;
		}
		
		.wishlist_button {
			background-color: #ffd700;
			color: black;
		}
	</style>
</head>
<body>
	<script type="text/javascript">
	// bx슬라이더 
	$(function(){
		$('.bxslider').bxSlider({
			mode: 'fade',
		    captions: true,
		    slideWidth: 400,
		    adaptiveHeight: true,
		});
	});
	// 수량 증가 감소 버튼 
	$(document).ready(function() {
		let $amountInput = $('input[name="amount"]');
		let maxAmount = ${mealkit.amount};
		console.log(maxAmount);
		let minAmount = 1;

		$('.amount_plus').click(function() {
			let currentValue = parseInt($amountInput.val());
			if (currentValue < maxAmount) {
				$amountInput.val(currentValue + 1);
			}
		});

		$('.amount_minus').click(function() {
			let currentValue = parseInt($amountInput.val());
			if (currentValue > minAmount) {
				$amountInput.val(currentValue - 1);
			}
		});
	});
	  // 구매, 장바구니, 찜목록 버튼 
	$(document).ready(function() {
		let mealkitNo = ${mealkit.no};
		
		$(".buy_button").click(function() {
			// 구매하기 
		});
	
		$(".cart_button").click(function() {
			// 장바구니 type = 1
	        $.ajax({
	            url: "<%= contextPath %>/Mealkit/mypage.pro",
	            type: "POST",
	            async: true,
	            data: {
	                no: mealkitNo,
	                type: 1
	            },
	            success: function(response) {
	                alert("장바구니에 추가되었습니다.");
	            },
	            error: function(xhr, status, error) {
	                alert("정상적으로 처리되지 않았습니다. " + error);
	            }

		});
	
		$(".wishlist_button").click(function() {
			// 찜하기 type = 0
		});
	});
	</script>
	<div id="container">
		<div class="info_image">
			<ul class="bxslider">
	  			<li><img id="thumnail" src="<%= contextPath %>/images/recipe/test_thumbnail.png" title="image1" /></li>
	  			<li><img src="<%= contextPath %>/images/recipe/test_thumbnail.png" title="image2" /></li>
	  			<li><img src="<%= contextPath %>/images/recipe/test_thumbnail.png" title="image3" /></li>
			</ul>
		</div>
		
		<div class="info_text">
			<span>
				<h1>${mealkit.title }</h1>
				<hr>
				<strong>글쓴이: ${mealkit.id }</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>게시일: ${mealkit.postDate }</strong><br>
				<strong>평점: ${mealkit.rating }</strong><hr>
			</span>
			<h2>가격: ${mealkit.price }</h2><hr><br>
			<!-- 수량 정하는 박스 -->
			<div class="amount_count">
				<input type="text" name="amount" id="amount" value="1" readonly>
				<div class="amount_controls">
					<button class="amount_plus" type="button">&#9650;</button>
					<button class="amount_minus" type="button">&#9660;</button>
				</div>
			</div>
			<br>
			<div class="button_row">
				<button class="buy_button" type="button">구매</button>
				<button class="cart_button" type="button">장바구니</button>
				<button class="wishlist_button" type="button">찜하기</button>
			</div>
	    </div>
	    
	</div>
</body>
</html>