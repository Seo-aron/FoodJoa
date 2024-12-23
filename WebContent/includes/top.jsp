<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
	
	String userId = (String) session.getAttribute("userId");
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>top</title>
	
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
	<link rel="stylesheet" href="<%= contextPath %>/css/includes/top.css">
</head>

<body>
	<div id="top_container">
		<div id="header">
			<!-- 사용자 메뉴 (로그인, 회원가입, 검색 버튼) -->
			<div id="userMenu">       
	       		<%
	       		if (userId != null) {
	       			%>
		            <form action="<%=request.getContextPath() + "/Member/logout.me"%>" method="POST">
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
			<a href="<%=contextPath%>/Main/home">
				<img src="<%=contextPath%>/images/mainpage/logo.png" alt="푸드조아 로고">
			</a>
		</div>
		
		<!-- 메뉴바 -->
		<nav class="top_nav">
			<ul id="topMenu">
				<li><a href="<%= contextPath %>/Main/home">홈</a></li>
				<li><a href="<%= contextPath %>/Recipe/list?category=0">레시피</a>
					<ul>
						<li><a href="<%= contextPath %>/Recipe/list?category=1">한식 요리</a></li>
						<li><a href="<%= contextPath %>/Recipe/list?category=2">일식 요리</a></li>
						<li><a href="<%= contextPath %>/Recipe/list?category=3">중식 요리</a></li>
						<li><a href="<%= contextPath %>/Recipe/list?category=4">양식 요리</a></li>
						<li><a href="<%= contextPath %>/Recipe/list?category=5">자취 요리</a></li>
					</ul>
				</li>
				<li>
					<a href="<%=contextPath%>/Mealkit/list?category=0">스토어</a>
					<ul>
						<li><a href="<%=contextPath%>/Mealkit/list?category=1">한식 제품</a></li>
						<li><a href="<%=contextPath%>/Mealkit/list?category=2">일식 제품</a></li>
						<li><a href="<%=contextPath%>/Mealkit/list?category=3">중식 제품</a></li>
						<li><a href="<%=contextPath%>/Mealkit/list?category=4">양식 제품</a></li>
					</ul>
				</li>
				<li>
					<a href="#">게시판</a>
					<ul>
						<li><a href="<%=contextPath%>/Community/noticeList">공지사항</a></li>
						<li><a href="<%=contextPath%>/Community/list">자유 게시판</a></li>
						<li><a href="<%=contextPath%>/Community/shareList">나눔/같이 먹어요</a></li>
					</ul>
				</li>
				<li><a href="<%= contextPath %>/Member/mypagemain.me">마이페이지</a></li>
			</ul>
		</nav>
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
