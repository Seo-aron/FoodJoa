<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>마이페이지</title>
    <style>
        .manage-section {
            display: flex;
            gap: 30px;
            margin-top: 10px;
            justify-content: space-between;
        }
        .manage-section div {
            flex: 1;
            padding: 20px;
            text-align: center;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            cursor: pointer;
            font-weight: bold;
            color: #495057;
            transition: box-shadow 0.3s;
        }
        .manage-section div:hover {
            box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
        }
        .manage-section img {
            width: 200px;
            height: 200px;
            margin-top: -50px;
            border-radius: 8px;
        }
        .profile-wrapper {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .profile-section {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        .profile-image {
            width: 100px;
            height: 100px;
            background-color: #dee2e6;
            border-radius: 50%;
            margin-right: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9em;
            color: #adb5bd;
            overflow: hidden;
            position: relative;
        }
        .profile-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        .profile-info h2 {
            margin: 0;
            font-size: 24px;
            color: #495057;
        }
        .profile-info p {
            color: #6c757d;
            font-size: 16px;
        }
        .edit-btn {
            padding: 8px 16px;
            font-size: 0.9em;
            color: #fff;
            background-color: #007bff;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .edit-btn:hover {
            background-color: #0056b3;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }
        .header h1 {
            font-size: 1.5em;
            color: #343a40;
            margin: 0;
        }
        .logout-btn {
            padding: 8px 16px;
            font-size: 0.9em;
            color: #fff;
            background-color: #dc3545;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .logout-btn:hover {
            background-color: #c82333;
        }
        .info-section {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .info-section div {
            font-size: 1em;
            margin-bottom: 10px;
            color: #495057;
        }
        .info-section .more-btn {
            margin-top: 10px;
            padding: 8px 16px;
            font-size: 0.9em;
            color: #007bff;
            background-color: transparent;
            border: 1px solid #007bff;
            border-radius: 4px;
            cursor: pointer;
        }
        .info-section .more-btn:hover {
            background-color: #e2e6ea;
        }
    </style>
</head>
<body>

<div class="header">
    <h1>마이페이지</h1>
    <input type="button" class="logout-btn" value="로그아웃">
</div>

<div class="profile-wrapper">
    <div class="profile-section">
        <div class="profile-image">
            <img id="profilePreview" src="path/to/your/profile-image.jpg" alt="프로필 미리보기">
        </div>
        <div class="profile-info">
            <h2>김보노님!</h2>
            <p>푸드조아와 함께한지 999일째♥</p>
             <input type="button" class="edit-btn" value="정보수정" onclick="window.location.href='editProfilePage.html'">
        </div>
       
    </div>

    <div class="manage-section">
        <div>
            <p align="center">내 레시피 관리</p>
            <img src="../images/레시피.png" alt="레시피 이미지">
        </div>
        <div>
            <p align="center">내 상품 관리</p>
            <img src="../images/상품사진.png" alt="상품 이미지">
        </div>
        <div>
            <p align="center">내 리뷰 관리</p>
            <img src="../images/손모양.png" alt="리뷰 이미지">
        </div>
    </div>

    <!-- Info Sections -->
    <div class="info-section">
        <div>주문/배송조회</div>
        <div>
            <span>주문건수: 0</span> | 
            <span>배송준비중: 1</span> | 
            <span>배송중: 2</span> | 
            <span>배송완료: 0</span>
            <br>
            <input type="button" class="more-btn" value="더보기">
        </div>
    </div>

    <div class="info-section">
        <div>내 마켓상품 주문/배송조회</div>
        <div>
            <span>주문건수: 0</span> | 
            <span>배송준비중: 1</span> | 
            <span>배송중: 2</span> | 
            <span>배송완료: 0</span>
            <br>
            <input type="button" class="more-btn" value="더보기">
        </div>
    </div>

    <div class="info-section">
        <div>※ 개인정보처리방침</div>
    </div>
    <input type="button" class="more-btn" value="탈퇴">
</div>

<script>
    // 파일을 선택하면 미리보기 이미지를 표시
    function previewImage(event) {
        const reader = new FileReader();
        reader.onload = function(){
            const output = document.getElementById('profilePreview');
            output.src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    }
</script>
</body>
</html>
