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
    //String id = "admin";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>회원 정보 수정</title>

<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<link rel="stylesheet" href="<%=contextPath%>/css/member/profileupdate.css">

<script type="text/javascript">    
    $(function() {
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
            
        $(".btn-submit").click(function(event){
            event.preventDefault();
            
            if ($("#name").val() == "" || 
                $("#nickname").val() == "" ||
                $("#phone").val() == "" ||
                $("#address").val() == ""){
                 alert("모두 작성하여 주세요!"); // 경고창으로 메시지 표시
            } else {
                // 성공적인 경우 폼 제출
                 alert("수정완료되었습니다!"); // 수정완료창으로 메시지 표시
                $(this).closest("form").submit();
            }
        });
        
        $(".btn-cancel").click(function(event) {
            event.preventDefault(); // 기본 클릭 이벤트 방지 (필요에 따라 추가)
            window.location.href = "<%=request.getContextPath()%>/Member/mypagemain.me";
        });
    });
</script>

</head>
<body>

    <div class="form-container">
        <h2>정보 수정</h2>
  
        <!-- JavaScript로 미리보기 기능 구현 -->
        <form action="<%=request.getContextPath()%>/Member/updatePro.me" method="post" enctype="multipart/form-data" >
        	<input type="hidden" id="origin-profile" name="origin-profile" value="<%= vo.getProfile() %>">
            <br>
            <br>
            <!-- 이미지 미리보기가 표시될 컨테이너 -->
            <div class="preview-container" id="previewContainer">
            </div>

            <!-- 파일 선택 버튼 -->
            <input type="file" accept=".jpg, .jpeg, .png" class="profile" id="fileInput" name="profile">
            <div class="form-group">
                <label for="name">이름</label> 
                <input type="text" id="name" name="name" value="<%=vo.getName()%>" placeholder="2자 이상 10자 미만으로 입력해주세요">
            </div>
            <div class="form-group">
                <label for="nickname">닉네임</label> 
                <input type="text" id="nickname" name="nickname" value="<%=vo.getNickname()%>" placeholder="2자 이상 10자 미만으로 입력해주세요">
            </div>
            <div class="form-group">
                <label for="phone">번호</label> 
                <input type="text" id="phone" name="phone" value="<%=vo.getPhone()%>" placeholder="-없이 입력해주세요">
            </div>
            <div class="form-group">
                <label for="address">주소</label> 
                <input type="text" id="address" name="address" value="<%=vo.getAddress()%>">
            </div>
            <div class="btn-container">
                <button type="button" class="btn-submit">제출</button>
                <button type="button" class="btn-cancel">취소</button>
            </div>
        </form>
    </div>

</body>
</html>
