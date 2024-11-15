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
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .container {
            width: 80%;
            margin: 0 auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 8px;
            background-color: #f9f9f9;
        }
        .header {
            font-size: 1.8em;
            text-align: center;
            margin-bottom: 20px;
            color: #333;
            font-weight: bold;
        }
        .item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #e0e0e0;
        }
        .item div {
            flex: 1;
            text-align: center;
            padding: 8px;
        }
        .item div:first-child {
            flex: 2;
            font-weight: bold;
        }
        .item:last-child {
            border-bottom: none;
        }
        .item button {
            background-color: #007bff;
            border: none;
            color: white;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .item button:hover {
            background-color: #0056b3;
        }
    </style>
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
