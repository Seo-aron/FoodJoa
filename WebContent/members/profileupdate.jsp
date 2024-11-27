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
<script src="../js/member/update.js"></script>
<link rel="stylesheet" href="<%=contextPath%>/css/member/profileupdate.css">
<script type="text/javascript">
document.addEventListener('DOMContentLoaded', function () {
    const fileInput = document.getElementById('fileInput');
    const previewContainer = document.getElementById('previewContainer');

    fileInput.addEventListener('change', function (event) {
        const file = event.target.files[0];

        // 기존 미리보기 초기화
        previewContainer.innerHTML = '';

        if (file && file.type.startsWith('image/')) {
            const reader = new FileReader();

            reader.onload = function (e) {
                const img = document.createElement('img');
                img.src = e.target.result;
                img.alt = '미리보기 이미지';
                img.style.maxWidth = '200px'; // 너비 제한
                img.style.maxHeight = '200px'; // 높이 제한
                previewContainer.appendChild(img);
            };

            reader.readAsDataURL(file);
        } else {
            previewContainer.innerHTML = '<span style="color: red;">이미지 파일만 선택 가능합니다.</span>';
        }
    });

    // jQuery 이벤트 등록
    $(".btn-submit").click(function(event){
        event.preventDefault();
        
        if ($("#name").val() == "" || 
            $("#nickname").val() == "" ||
            $("#phone").val() == "" ||
            $("#address").val() == ""){
             alert("모두 작성하여 주세요!"); // 경고창으로 메시지 표시
        } else {
             alert("수정 완료되었습니다!"); // 수정 완료 메시지 표시
            $(this).closest("form").submit();
        }
    });

    $(".btn-cancel").click(function(event) {
        event.preventDefault(); // 기본 클릭 이벤트 방지
        window.location.href = "<%=request.getContextPath()%>/Member/mypagemain.me";
    });
});
</script>
</head>
<body>
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
                <button type="button" class="btn-submit">제출</button>
                <button type="button" class="btn-cancel">취소</button>
            </div>
        </form>
    </div>

</body>
</html>
