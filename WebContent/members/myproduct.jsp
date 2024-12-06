<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <title>상품 관리</title>
    <link rel="stylesheet" href="<%=contextPath%>/css/member/myproduct.css">
</head>
<body>
    <div class="container">
        <div class="header">내 상품 관리</div>
        
        <!-- Header row -->
        <div class="item">
            <div>제목</div>
            <div>사진 설명</div>
            <div>수정</div>
            <div>삭제</div>
        </div>

        <!-- Review row -->
        <div class="item">
            <div>리뷰 제목</div>
            <div>사진 설명 텍스트</div>
            <div><button>수정</button></div>
            <div><button>삭제</button></div>
        </div>

        <!-- Reactions row -->
        <div class="item">
            <div>공감수</div>
            <div>공감 수 데이터</div>
            <div></div>
            <div></div>
        </div>
    </div>
</body>
</html>
