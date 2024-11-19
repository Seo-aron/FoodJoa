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
	
	<style>	
		* {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        a {
            text-decoration: none;
        }
        
        #center>table{
        	margin : 0 auto;
        }
        
		.rank {
            margin: 0 auto;
            padding: 20px;
            width: 1200px;
        }

        .rank table {
            border-spacing: 50px;
            margin: 0 auto;
        }

        td {
            vertical-align: top;
            width: 300px;
        }	
        
          /* 사이드바 스타일 */
        .sidebar {
            position: absolute; /* 초기에는 고정 위치 */
            top: 20px;
            right: 20px;
            width: 150px;
            padding: 10px;
            transition: top 0.3s ease; /* 부드러운 이동 효과 */
        }

        .sidebar h3 {
            margin-bottom: 15px;
            font-size: 1.2em;
            color: #333;
        }

        .sidebar .card {
            background-color: #fff;
            padding: 10px;
            margin-bottom: 10px;
            border-radius: 5px;
            box-shadow: 0px 1px 3px rgba(0, 0, 0, 0.2);
            text-align: center;
        }

        .sidebar .card a {
            display: block;
            color: #333;
            font-weight: bold;
        }

        .content-wrapper {
            display: flex;
            justify-content: center;
            gap: 20px;
            padding: 20px;
        }

        .main-content {
            flex: 1;
        }
        
        .bx-wrapper .bx-controls-direction a {
			z-index: 500;
		} 
	</style>
	
	<!-- BX slider -->
	<script>
        
		$(function() {
			$('.rank_slider').bxSlider({
				auto : true,
				pager : true
			});

			$('.market_slider').bxSlider({
				auto : true,
				pager : true
			});
		});

		// 사이드바 스크롤 효과
		window.addEventListener("scroll", function() {
			const sidebar = document.querySelector(".sidebar");
			const center = document.getElementById("center");

			// center 영역의 위치와 높이 가져오기
			const centerTop = center.offsetTop;
			const centerBottom = centerTop + center.offsetHeight;
			const offset = 20; // 상단 여백

			// 현재 스크롤 위치 계산
			const scrollY = window.scrollY;

			// 사이드바의 위치를 center 영역 내로 제한
			if (scrollY + offset < centerTop) {
				// center 위에 있을 때는 고정된 위치
				sidebar.style.top = centerTop + "px";
			} else if (scrollY + offset + sidebar.offsetHeight > centerBottom) {
				// center 아래에 있을 때는 bottom에 고정
				sidebar.style.top = (centerBottom - sidebar.offsetHeight)
						+ "px";
			} else {
				// center 안에서 스크롤을 따라 움직일 때
				sidebar.style.top = (scrollY + offset) + "px";
			}
		});
	</script>
    
   	<script type="text/javascript">   	
		function onWishList() {
			location.href = '<%= contextPath %>/Member/viewWishList.me';
		}
		
		function onRecently() {
			location.href = '<%= contextPath %>/Member/recently.me';
		}
		
		function onCart() {
			location.href = '<%= contextPath %>/Member/cart.me';
		}		
	</script>
    
</head>

<body>
	<div id="center">
		<table>
            <tr>
                <!-- 오늘의 레시피 랭킹 -->
                <td>
                	<img alt="" src="">
                    <오늘의 레시피 랭킹>
                    <ul class="rank_slider">
                        <li><img src="${contextPath}/images/mainpage/foodrank1.jpg" alt="레시피랭킹1"></li>
                        <li><img src="${contextPath}/images/mainpage/foodrank2.jpg" alt="레시피랭킹2"></li>
                        <li><img src="${contextPath}/images/mainpage/foodrank3.jpg" alt="레시피랭킹3"></li>
                    </ul>
                </td>

                <!-- 오늘 뭐 먹지? 데일리 추천 -->
                <td>
                	<img alt="" src="">
                    <오늘 뭐 먹지? 데일리 알고리즘 추천>
                    <a><img src="${contextPath}/images/mainpage//marketrank1.jpg" alt="첫번째 오른쪽" width="300px"></a>
                </td>
            </tr>
            <tr>
                <!-- 오늘의 마켓 랭킹 -->
                <td>
                	<img alt="" src="">
                    <오늘의 마켓 랭킹>
                    <ul class="market_slider">
                        <li><img src="${contextPath}/images/mainpage/marketrank1.jpg" alt="마켓랭킹1"></li>
                        <li><img src="${contextPath}/images/mainpage/marketrank2.jpg" alt="마켓랭킹2"></li>
                        <li><img src="${contextPath}/images/mainpage/marketrank3.jpg" alt="마켓랭킹3"></li>
                    </ul>
                </td>

                <!-- 오늘의 웰빙 요리 -->
                <td>
                	<img alt="" src=""> 
                    <오늘의 웰빙 요리>
                    <a><img src="${contextPath}/images/mainpage/wellbeing.jpg" alt="두번째 오른쪽" width="300px"></a>
                </td>
            </tr>
        </table>
	</div>
	
	<!-- 사이드바 영역 -->
	<div class="sidebar">
        <button class="button" onclick="onWishList()">위시리스트 <br> 레시피/상품</button>
        <button class="button" onclick="onRecently()">최근에 본 <br> 레시피/상품</button>
        <button class="button" onclick="onCart()">장바구니</button>
    </div>
</body>


</html>