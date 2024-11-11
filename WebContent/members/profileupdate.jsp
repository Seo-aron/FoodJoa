
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
            width: 1000px;
            padding: 30px;
            border-radius: 10px;
            background-color: #fff;
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
            height: 700px;
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
    <script>
    /* 이미지 미리보기 구현 */
    document.getElementById('fileInput').addEventListener('change', function(event) {
        const previewContainer = document.getElementById('previewContainer');
        const file = event.target.files[0];
        
        if (file && file.type.startsWith('image/')) {
            const reader = new FileReader();
            
            reader.onload = function(e) {
                // 선택된 이미지로 미리보기 업데이트
                previewContainer.innerHTML = `<img src="${e.target.result}" alt="미리보기 이미지">`;
            };
            
            reader.readAsDataURL(file);
        } else {
            previewContainer.innerHTML = '<span>유효한 이미지 파일을 선택하세요.</span>';
        }
    });
    
    
        function checkConditionAndProceed() {
            // 조건 설정 (예: 특정 값 확인)
            var condition = true; // 이 부분을 원하는 조건으로 설정

            // if 문으로 조건 확인
            if (condition&&<%=request.getContextPath()%>){
                alert("정보수정이 완료되었습니다.");
                window.location.href = 'mypagemain.jsp'; // 조건 충족 시 이동할 페이지
            } else {
                alert("정보수정이 실패했습니다.");
            }
        }
    </script>
    
</head>
<body>
<!-- 
name
nickname
phone
address
profile -->


<div class="form-container">
    <h2>정보 수정</h2>
    <!-- 이미지 미리보기가 표시될 컨테이너 -->
    <div class="preview-container" id="previewContainer">
    </div>

    <!-- 파일 선택 버튼 -->
    <input type="file" accept="image/*" class="file-input" id="fileInput">

    <!-- JavaScript로 미리보기 기능 구현 -->
    <form action="mypagemain.jsp" method="post"><br><br>
        <div class="form-group">
            <label for="name">이름</label>
            <input type="text" id="name" name="name" required>
        </div>
         <div class="form-group">
            <label for="name">닉네임</label>
            <input type="text" id="nickname" name="nickname" required>
        </div>
        <div class="form-group">
            <label for="phone">번호</label>
            <input type="text" id="phone" name="phone" required>
        </div>
        <div class="form-group">
            <label for="address">주소</label>
            <input type="text" id="address" name="address" required>
        </div>
        <div class="btn-container">
            <button type="submit" class="btn btn-submit">제출</button>
            <button type="button" class="btn btn-update">수정완료</button>
             
        </div>
    </form>
</div>

</body>
</html>
