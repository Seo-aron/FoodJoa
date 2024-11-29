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
                    <오늘의 추천 요리>
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
</body>


</html>