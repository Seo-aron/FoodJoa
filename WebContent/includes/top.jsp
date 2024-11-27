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
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
	<title>top</title>
	
	<style type="text/css">
		/* 전역 초기화 */
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

#header {
	padding-top: 10px;
	padding-bottom: 50px;
    position: relative;
    text-align: center;
    width: 100%;
    margin-bottom: 10px; /* 메뉴바와 로고 간 여백 조정 */
}

/* 사용자 메뉴 (로그인, 회원가입 버튼) */
#userMenu {
	top: 30px;
    position: absolute;
    right: 280px;
    display: flex;
    gap: 15px;
    
}

#userMenu button {
    background-color: #ffffff;
    border: 1px solid #cccccc;
    border-radius: 20px;
    padding: 5px 15px;
    font-size: 14px;
    cursor: pointer;
    color: #666666;
    transition: all 0.3s ease;
}

#userMenu button:hover {
    background-color: #f5f5f5;
    color: #333333;
    border-color: #bf917e;
}

#userMenu button:active {
    background-color: #bf917e;
    color: #ffffff;
}

/* 로고 스타일 */
#logo {
	position: absolute;
    width: 240px;
    height: 80px;
    top: 60px; 
    left: 330px; 
    z-index: 1000; /* 다른 요소들 위에 표시 */
}

#logo img {
    width: 100%;
    height: 100%;
    object-fit: contain;
    display: block;
}

.top_nav{
	padding-left: 600px; 
}

#topMenu {
    height: 70px;
    background-color: #ffffff;
    list-style: none;
    display: flex;
    font-family: "Noto Serif KR", serif;
    padding: 0;
}

#topMenu > li {
    position: relative;
}

#topMenu > li > a {
    display: block;
    color: #BF917E; /* 기본 글씨 색상 */
    font-weight: 600;
    font-size: 16px;
    padding: 20px 50px;
    transition: color 0.3s ease, background-color 0.3s ease;
}

#topMenu > li:hover > a {
    color: #bf917e; /* 호버 시 강조 색상 */
    background-color: #f9f9f9; /* 배경 색상 추가 */
}

#topMenu > li > a:active {
    color: #616161; /* 클릭 시 글씨 색상 */
}

/* 서브메뉴 스타일 */
#topMenu > li > ul {
    display: none;
    position: absolute;
    top: 70px;
    left: 0;
    background-color: #fff;
    list-style: none;
    padding: 10px 0;
    width: 160px;
    z-index: 1000;
    border: 1px solid #ddd;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
}

#topMenu > li > ul > li > a {
    padding: 10px;
    display: block;
    color: #4d4d4d;
    text-align: center;
}

#topMenu > li:hover > ul {
    display: block;
}

/* 상단 여백 */
.top_empty {
    height: 20px;
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
		</div>
		
		<div id="logo">
			<a href="<%= contextPath %>/main.jsp">
				<img src="<%=contextPath%>/images/mainpage/logo.png" alt="푸드조아 로고">
			</a>
		</div>
		
		<!-- 메뉴바 -->
		<nav class="top_nav">
			<ul id="topMenu">
				<li><a href="<%= contextPath %>/main.jsp">홈</a></li>
				<li><a href="<%= contextPath %>/Recipe/list?category=0">레시피 공유</a>
					<ul>
						<li><a href="<%= contextPath %>/Recipe/list?category=1">한식 요리</a></li>
						<li><a href="<%= contextPath %>/Recipe/list?category=2">일식 요리</a></li>
						<li><a href="<%= contextPath %>/Recipe/list?category=3">중식 요리</a></li>
						<li><a href="<%= contextPath %>/Recipe/list?category=4">양식 요리</a></li>
						<li><a href="<%= contextPath %>/Recipe/list?category=5">자취 요리</a></li>
					</ul></li>
				<li><a href="#">나만의 음식 판매</a>
					<ul>
						<li><a href="<%=contextPath%>/Mealkit/list">1</a></li>
						<li><a href="#">2</a></li>
						<li><a href="#">3</a></li>
						<li><a href="#">4</a></li>
					</ul></li>
				<li><a href="#">자유게시판</a>
					<ul>
						<li><a href="<%=contextPath%>/Community/list">자유 게시판</a></li>
						<li><a href="<%=contextPath%>/Community/shareList">나눔/번개 게시판</a></li>
					</ul></li>
				<li><a href="<%= contextPath %>/Member/mypagemain.me">마이페이지</a></li>
			</ul>
		</nav>
		<hr>
		<div class="top_empty">
		</div>
		
	</div>
	
	
	<script type="text/javascript">
		function onJoinButton() {
			location.href = '<%= contextPath %>/Member/snsjoin.me';
		}
		
		function onLoginButton(){
			location.href = '<%= contextPath %>/Member/login.me';
		}
		
	</script>
</body>

</html>
