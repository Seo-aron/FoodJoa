<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>top</title>
	
	<style type="text/css">
		* {
			margin: 0;
			padding: 0;
			box-sizing: border-box;
		}
		
		a {
			text-decoration: none;
		}
		
		#container {
			width: 100%;
			margin: 0 auto;
		}
		
		/* 헤더 섹션 */
		#header {
			position: relative;
			text-align: center;
			padding-top: 20px;
			margin-bottom: 20px;
			width: 100%;
		}
		
		/* 사용자 메뉴 (로그인, 회원가입, 검색 버튼) */
		#userMenu {
			position: absolute;
			top: 20px;
			margin-right: 150px;
			right: 1px;
			display: flex;
			gap: 10px;
		}
		
		#userMenu button {
			background-color: #fff;
			border: 1px solid black;
			border-radius: 5px;
			padding: 5px 10px;
			font-size: 14px;
			cursor: pointer;
			color: #4d4d4d;
		}
		
		#userMenu button:hover {
			background-color: #99ff99;
			color: #fff;
		}
		
		/* 로고 스타일 */
		#logo {
			width: 500px;
			height: 200px;
			margin: 0 auto;
		}
		
		#logo img {
			width: 100%;
			height: 100%;
			object-fit: cover;
			display: block;
			margin: 0 auto;
		}
		
		/* 메뉴바 스타일 */
		#topMenu {
			height: 60px;
			background-color: #99ff99;
			list-style: none;
			display: flex;
			justify-content: center;
			margin: 20px 0;
		}
		
		#topMenu>li {
			position: relative;
		}
		
		#topMenu>li>a {
			display: block;
			color: black;
			font-weight: 600;
			padding: 20px 50px;
			transition: background-color 0.2s;
		}
		
		#topMenu>li:hover>a {
			background-color: #99ff99;
			color: #fff;
		}
		
		/* 서브메뉴 스타일 */
		#topMenu>li>ul {
			display: none;
			position: absolute;
			top: 60px;
			left: 0;
			background-color: #fff;
			list-style: none;
			padding: 10px 0;
			width: 160px;
			z-index: 1000;
		}
		
		#topMenu>li>ul>li>a {
			padding: 10px;
			display: block;
			color: #4d4d4d;
			text-align: center;
		}
		
		#topMenu>li:hover>ul {
			display: block;
		}
		
	</style>
</head>

<body>
	<div>
		<div id="header">
			<!-- 사용자 메뉴 (로그인, 회원가입, 검색 버튼) -->
			  <div id="userMenu">
       
        <%
            String userId = (String) session.getAttribute("userId");
        %>
        <%
            if (userId != null) {
        %>
            <form action="<%= request.getContextPath() + "/Member/logout.me" %>" method="POST">
                <button type="submit">로그아웃</button>
            </form>
        <%
            } else {
        %>
            <button onclick="onLoginButton()">로그인</button>
            <button onclick="onJoinButton()">회원가입</button>
        <% 
            }
        %>        
    </div>
			<!-- 로고 -->
			<div id="logo">
				<a href="#"> <img
					src="<%=contextPath%>/images/mainpage/logo.jpg" alt="푸드조아 로고">
				</a>
			</div>
		</div>

		<!-- 메뉴바 -->
		<nav>
			<ul id="topMenu">
				<li><a href="#">홈</a></li>
				<li><a href="<%= contextPath %>/Recipe/list?category=0">레시피 공유<span> ▼ </span></a>
					<ul>
						<li><a href="<%= contextPath %>/Recipe/list?category=1">한식 요리</a></li>
						<li><a href="<%= contextPath %>/Recipe/list?category=2">일식 요리</a></li>
						<li><a href="<%= contextPath %>/Recipe/list?category=3">중식 요리</a></li>
						<li><a href="<%= contextPath %>/Recipe/list?category=4">양식 요리</a></li>
						<li><a href="<%= contextPath %>/Recipe/list?category=5">자취 요리</a></li>
					</ul></li>
				<li><a href="#">나만의 음식 판매<span> ▼ </span></a>
					<ul>
						<li><a href="<%=contextPath%>/Mealkit/list">1</a></li>
						<li><a href="#">2</a></li>
						<li><a href="#">3</a></li>
						<li><a href="#">4</a></li>
					</ul></li>
				<li><a href="#">자유게시판<span> ▼ </span></a>
					<ul>
						<li><a href="<%=contextPath%>/Community/list">지역별 게시판</a></li>
						<li><a href="<%=contextPath%>/Community/shareList">재료 나눔 게시판</a></li>
						<li><a href="#">같이 먹어요</a></li>
					</ul></li>
				<li><a href="<%= contextPath %>/Member/mypagemain.me">마이페이지</a></li>
			</ul>
		</nav>
	</div>
	
	
	<script type="text/javascript">
		function onJoinButton() {
			location.href = '<%= contextPath %>/Member/join.me';
		}
		
		function onLoginButton(){
			location.href = '<%= contextPath %>/Member/login.me';
		}
		
	</script>
</body>

</html>
