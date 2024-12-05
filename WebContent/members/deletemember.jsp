<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>탈퇴하기</title>
    <style>
body {
    font-family: 'Noto Serif KR', serif;
    background-color: #f9f6f2; /* 따뜻한 배경색 */
    margin: 0;
    padding: 0;
    color: #000000; /* 텍스트 색상 */
}

#container {
    text-align: center;
    padding: 30px;
    border-radius: 10px;
    width: 50%;
    margin: 100px auto;
    background-color: #fff; /* 흰색 배경 */
    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1); /* 부드러운 그림자 */
    border: 1px solid #eaeaea;
}

h3 {
    font-size: 24px;
    color: #000000; /* 따뜻한 갈색 톤 */
    margin-bottom: 10px;
}

p {
    font-size: 16px;
    color: #616161;
    margin-bottom: 20px;
}

label {
    display: block;
    font-size: 14px;
    color: #000000;
    font-weight: bold;
    margin-bottom: 5px;
}

input {
    margin: 10px 0;
    padding: 10px;
    width: 80%;
    border: 1px solid #ddd;
    border-radius: 5px;
    font-size: 14px;
    background-color: #fefdfc; /* 부드러운 흰색 배경 */
    box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05); /* 입력 필드 안쪽 그림자 */
}

input:focus {
    outline: none;
    border: 1px solid #d9b89c; /* 따뜻한 갈색 */
    box-shadow: 0 0 5px rgba(217, 184, 156, 0.5);
}

button {
    background-color: #BF917E; /* 따뜻한 황금빛 갈색 */
    color:#000000;
    }
#readonlyId, #inputId {
	corlor:#616161;	
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
