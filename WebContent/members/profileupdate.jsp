<%@page import="VOs.MemberVO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();

	MemberVO vo = (MemberVO) request.getAttribute("vo");

	String id = (String) session.getAttribute("id");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>
<script src="http://code.jquery.com/jquery-latest.min.js"> </script>

<link rel="stylesheet"
	href="<%=contextPath%>/css/member/profileupdate.css">
<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function () {
    const fileInput = document.getElementById('fileInput');
    const previewContainer = document.getElementById('previewContainer');

    fileInput.addEventListener('change', function (event) {
        const file = event.target.files[0];
        previewContainer.innerHTML = ''; // 기존 미리보기 초기화

        if (file && file.type.startsWith('image/')) {
            const reader = new FileReader();
            reader.onload = function (e) {
                const img = document.createElement('img');
                img.src = e.target.result;
                img.alt = '미리보기 이미지';
                img.style.maxWidth = '200px';
                img.style.maxHeight = '200px';
                previewContainer.appendChild(img);
            };
            reader.readAsDataURL(file);
        } else {
            previewContainer.innerHTML = '<span style="color: red;">이미지 파일만 선택 가능합니다.</span>';
        }
    });

<<<<<<< HEAD
    // jQuery 이벤트 등록
    $(".btn-submit").click(function(event){
    	 // 입력 필드 값 가져오기
=======
    // 제출 버튼 유효성 검사
    $(".btn-submit").click(function(event) {
        event.preventDefault();
>>>>>>> 30c3bd697da3097a3aa9b08cb2a9f0915623828c
        const name = document.getElementById('name').value.trim();
        const nickname = document.getElementById('nickname').value.trim();
        const phone = document.getElementById('phone').value.trim();
        const address = document.getElementById('address').value.trim();

        if (name.length < 2 || name.length > 10) {
            alert('이름은 2자 이상, 10자 이하로 입력해주세요.');
            return;
        }
        if (nickname.length < 2 || nickname.length > 10) {
            alert('닉네임은 2자 이상, 10자 이하로 입력해주세요.');
            return;
        }
        const phoneRegex = /^\d{10,11}$/;
        if (!phoneRegex.test(phone)) {
            alert('전화번호는 10~11자리 숫자로 입력해주세요.');
            return;
        }
        if (!address) {
            alert('주소를 입력해주세요.');
            return;
<<<<<<< HEAD
  
=======
        }
        alert('수정 완료되었습니다!');
        $(this).closest("form").submit();
    });

    // 취소 버튼 클릭 동작
>>>>>>> 30c3bd697da3097a3aa9b08cb2a9f0915623828c
    $(".btn-cancel").click(function(event) {
        event.preventDefault(); // 기본 클릭 이벤트 방지
        const confirmCancel = confirm('수정을 취소하시겠습니까?');
        if (confirmCancel) {
            window.location.href = "<%=request.getContextPath()%>/Member/mypagemain.me";
        }
    });
});

</script>
</head>
<body>
<<<<<<< HEAD
    <div class="form-container">
        <h2>정보 수정</h2>
        <!-- JavaScript로 미리보기 기능 구현 -->
        <form action="<%=contextPath%>/Member/updatePro.me" method="post" enctype="multipart/form-data" id="updateForm" >
           <input type="hidden" id="origin-profile" name="origin-profile" value="<%=vo.getProfile()%>">

            <br>
            <br>
            <!-- 이미지 미리보기가 표시될 컨테이너 -->
            <div class="preview-container" id="previewContainer">
            </div>

            <!-- 파일 선택 버튼 -->
            <input type="file" accept=".jpg, .jpeg, .png" class="profile" id="fileInput" name="profile">
            <div class="form-group">
                <label for="name">이름</label> 
                <input type="text" id="name" name="name" value="${vo.name}" placeholder="2자 이상 10자 미만으로 입력해주세요" required>
            </div>
            <div class="form-group">
                <label for="nickname">닉네임</label> 
                <input type="text" id="nickname" name="nickname" value="${vo.nickname}" placeholder="2자 이상 10자 미만으로 입력해주세요" required>
            </div>
            <div class="form-group">
                <label for="phone">번호</label> 
                <input type="text" id="phone" name="phone" value="${vo.phone}" placeholder="-없이 입력해주세요" required>
            </div>
            <div class="form-group">
                <label for="address">주소</label> 
                <input type="text" id="address" name="address" value="${vo.address}" required>
            </div>
            <div class="btn-container">
                <button type="button" class="btn-submit" id="updateForm()">제출</button>
                <button type="button" class="btn-cancel">취소</button>
            </div>
        </form>
    </div>
=======
	<div class="form-container">
		<h2>정보 수정</h2>
		<!-- JavaScript로 미리보기 기능 구현 -->
		<form action="<%=contextPath%>/Member/updatePro.me" method="post"
			enctype="multipart/form-data" id="updateForm">
			<input type="hidden" id="origin-profile" name="origin-profile"
				value="<%=vo.getProfile()%>"> <br> <br>
				
			<!-- 파일 선택 버튼 -->
			<input type="file" accept=".jpg, .jpeg, .png" class="profile"
				id="fileInput" name="profile">
			<!-- 미리보기 컨테이너 -->
			<div class="preview-container" id="previewContainer"></div>
>>>>>>> 30c3bd697da3097a3aa9b08cb2a9f0915623828c

			<div class="form-group">
				<label for="name">이름</label> <input type="text" id="name"
					name="name" value="${vo.name}" placeholder="2자 이상 10자 미만으로 입력해주세요"
					required>
			</div>
			<div class="form-group">
				<label for="nickname">닉네임</label> <input type="text" id="nickname"
					name="nickname" value="${vo.nickname}"
					placeholder="2자 이상 10자 미만으로 입력해주세요" required>
			</div>
			<div class="form-group">
				<label for="phone">번호</label> <input type="text" id="phone"
					name="phone" value="${vo.phone}" placeholder="-없이 입력해주세요" required>
			</div>
			<div class="form-group">
				<label for="address">주소</label> <input type="text" id="address"
					name="address" value="${vo.address}" required>
			</div>
			<div class="btn-container">
				<button type="submit" class="btn-submit" id="updateForm()">제출</button>
				<button type="submit" class="btn-cancel">취소</button>
			</div>
		</form>
	</div>
</body>
</html>
