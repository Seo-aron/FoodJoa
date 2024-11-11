<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>리뷰 관리</title>
    <style>
        /* 스타일을 추가하여 가독성을 높일 수 있습니다 */
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }
        .container {
            width: 60%;
            margin: 0 auto;
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 8px;
        }
        .header {
            font-size: 1.5em;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }
        .item div {
            width: 25%;
            text-align: center;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">내 리뷰 관리</div>
        <div class="item">
            <div><b>제목</b></div>
            <div><b>사진 설명</b></div>
            <div><button>수정</button></div>
            <div><button>삭제</button></div>
        </div>
        <div class="item">
            <div>리뷰 제목</div>
            <div>사진 설명 텍스트</div>
            
        </div>
        <div class="item">
            <div><b>공감수</b></div>
            <div>공감 수 데이터</div>
            <div></div>
            <div></div>
        </div>
    </div>
</body>
</html>