<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>회원 정보 수정</title>
    <style>
        * {
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #e9ecef;
        }
        .form-container {
            width: 380px;
            padding: 30px;
            border-radius: 10px;
            background-color: #fff;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }
        .form-container h2 {
            text-align: center;
            color: #495057;
            margin-bottom: 25px;
        }
        .form-group {
            margin-bottom: 20px;
            position: relative;
        }
        .form-group label {
            position: absolute;
            top: 0;
            left: 10px;
            font-size: 0.85em;
            color: #6c757d;
            background-color: #fff;
            padding: 0 5px;
            transform: translateY(-50%);
        }
        .form-group input {
            width: 100%;
            padding: 12px 10px;
            border: 1px solid #ced4da;
            border-radius: 6px;
            font-size: 1em;
            transition: border-color 0.3s;
        }
        .form-group input:focus {
            outline: none;
            border-color: #80bdff;
            box-shadow: 0 0 5px rgba(0, 123, 255, 0.3);
        }
        .btn-container {
            display: flex;
            gap: 10px;
        }
        .btn {
            flex: 1;
            padding: 12px;
            border: none;
            border-radius: 6px;
            font-size: 1em;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .btn-submit {
            background-color: #28a745;
            color: #fff;
        }
        .btn-submit:hover {
            background-color: #218838;
        }
        .btn-update {
            background-color: #007bff;
            color: #fff;
        }
        .btn-update:hover {
            background-color: #0069d9;
        }
    </style>
</head>
<body>

<div class="form-container">
    <h2>회원 정보 수정</h2>
    <form action="updateMember.jsp" method="post">
        <div class="form-group">
            <label for="name">회원 이름</label>
            <input type="text" id="name" name="name" required>
        </div>
        <div class="form-group">
            <label for="region">지역</label>
            <input type="text" id="region" name="region" required>
        </div>
        <div class="form-group">
            <label for="email">이메일 주소</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="dob">생년월일</label>
            <input type="date" id="dob" name="dob" required>
        </div>
        <div class="form-group">
            <label for="newPassword">새로운 비밀번호</label>
            <input type="password" id="newPassword" name="newPassword" required>
        </div>
        <div class="form-group">
            <label for="confirmPassword">비밀번호 재확인</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>
        </div>
        <div class="btn-container">
            <button type="submit" class="btn btn-submit">제출</button>
            <button type="button" class="btn btn-update">수정완료</button>
        </div>
    </form>
</div>

</body>
</html>
