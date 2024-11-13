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
<!DOCTYPE html>
<html lang="ko">
<head>
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
  	<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
  	<link rel="stylesheet" href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css">
    <meta charset="UTF-8">
    <link rel="stylesheet" href="<%=contextPath%>/css/member/myrecipe.css">
    <title>마이페이지</title>
 
</head>
<body>

<div class="container">
    <!-- Header Section -->
   <div class="header">
    <h1>내 레시피 관리</h1>
    <a href="<%=contextPath%>/main.jsp">
    <input type="button" class="logout-btn" value="로그아웃">
    </a>
	</div>
</div>
</body>
</html>
