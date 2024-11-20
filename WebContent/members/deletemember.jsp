<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>탈퇴하기</title>
    <style>
        #container {
            text-align: center;
            padding: 20px;
            border-radius: 10px;
            width: 50%;
            margin: 100px auto;

        }

        input {
            margin: 10px 0;
            padding: 10px;
            width: 80%;
            border: 1px solid #ddd;
            border-radius: 5px;
        }

        button {
            background-color: #f44336;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
        }

        button:hover {
            background-color: #d32f2f;
        }
    </style>
</head>
<body>
    <div id="container">
        <h3>정말로... 탈퇴하시겠어요...?</h3>
        <p>탈퇴를 원하신다면 아래의 본인 아이디를 다시 입력해주세요...</p>
        <form action="<%= request.getContextPath() %>/Member/deleteMemberPro.me" method="post">
            <!-- 로그인된 아이디를 input 태그에 readonly로 표시 -->
            <label for="readonlyId">로그인된 아이디</label>
            <input type="text" id="readonlyId" name="readonlyId" value="<%= session.getAttribute("userId") %>" readonly />
            <br><br>
            
            <label for="inputId">아이디를 다시 입력해주세요</label>
            <input type="text" id="inputId" name="inputId" required />
            <br><br>

            <button type="submit">탈퇴하기</button>
        </form>
    </div>
</body>
</html>
