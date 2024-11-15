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
  	<link rel="stylesheet" href="<%=contextPath%>/css/mealkit/board.css">
  	
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<body>
	<script type="text/javascript">
	$(document).ready(function(){
		$('.bxslider').bxSlider({
			mode: 'fade',
			captions: true,
			slideWidth: 400,
			adaptiveHeight: true
		});
	});
	// 수량 증가 감소 버튼
	$(document).ready(function() {
		let $stockInput = $('input[name="stock"]');
		let maxStock = ${mealkit.stock};
		let minStock = 1;

		$('.stock_plus').click(function() {
			let currentValue = parseInt($stockInput.val());
			if (currentValue < maxStock) {
				$stockInput.val(currentValue + 1);
			}
		});

		$('.stock_minus').click(function() {
			let currentValue = parseInt($stockInput.val());
			if (currentValue > minStock) {
				$stockInput.val(currentValue - 1);
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
	                if(response === "1") alert("장바구니에 추가되었습니다.");
	                else alert("장바구니에 추가를 못 했습니다.");
	            }
	        });
		});
	
		$(".wishlist_button").click(function() {
			// 찜하기 type = 0
			$.ajax({
	            url: "<%= contextPath %>/Mealkit/mypage.pro",
	            type: "POST",
	            async: true,
	            data: {
	                no: mealkitNo,
	                type: 0
	            },
	            success: function(response) {
	                if(response === "1") alert("찜목록에 추가되었습니다.");
	                else alert("찜목록에 추가를 못 했습니다.");
	            }
	        });
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
			<!--간단 소개글 추가 해야함 -->
			
			<div class="orders_text">
			    <h3>조리 순서</h3>
			    <!-- 나중에 갈아엎어야함 StringParser.java 이용해서 값 불러와야댐  -->
			    <p id="orders">${mealkit.orders }</p> <!-- id="orders" 추가 -->
			    <script>
			        var orders = document.getElementById("orders").innerText;
			        var formattedOrders = orders.replace(/,/g, '<br>'); // ','를 <br>로 교체
			        document.getElementById("orders").innerHTML = formattedOrders;
			    </script>
			</div>

				
			<div class="origin_text">
			   	<h3>원산지</h3> 
			   	<p>${mealkit.origin }</p>
		    </div>
		</div>
		
		<div class="info_text">
			<span>
				<h1>${mealkit.title }</h1>
				<hr>
				<strong>글쓴이: ${mealkit.id }</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>게시일: ${mealkit.postDate }</strong><br>
				<!-- 나중에 평점 수정 -->
				<strong>평점: </strong><hr>
			</span>
			<h2>가격: ${mealkit.price }</h2><hr><br>
			
			<!-- 수량 정하는 박스 -->
			<div class="stock_count">
				<input type="text" name="stock" id="stock" value="1" readonly>
				<div class="stock_controls">
					<button class="stock_plus" type="button">&#9650;</button>
					<button class="stock_minus" type="button">&#9660;</button>
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