<%@ page import="java.util.Enumeration" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // request에서 userId 값 가져오기
     String userId = (String) request.getAttribute("userId");

    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=utf-8");

    String contextPath = request.getContextPath();
%>
<% 
    String alertMessage = (String) request.getAttribute("alertMessage");
    if (alertMessage != null) {
%>
<script>
    alert("<%= alertMessage %>");
</script>
<%
    }
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<title>푸드조아 회원 가입</title>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css"
	integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
<style>
    .login { text-align: center; }
    .container { width: 1000px; margin: 0 auto; padding: 20px; }
    .input-container { display: flex; flex-direction: column; align-items: center; gap: 10px; }
    .input-container input { width: 300px; height: 40px; padding: 10px; font-size: 16px; border: 1px solid #ccc; border-radius: 5px; }
    .input-container input:focus { border-color: #FFB84D; outline: none; }
    .joinButton { background-color: #FFB84D; border: none; padding: 8px 16px; font-size: 14px; color: white; cursor: pointer; width: 90px; height: 30px; }
    .joinButton:hover { background-color: #FF9F2F; }
    .add { margin-top: 30px; }
    .file-input { display: none; }
    .file-button { background-color: #FFB84D; border: none; padding: 4px 8px; font-size: 14px; color: white; cursor: pointer; height: 30px; margin-left: 10px; }
    .file-button:hover { background-color: #FF9F2F; }
</style>
</head>
<body>
	<div id="container">

		<!-- 회원가입 폼 -->
		<form action="<%= request.getContextPath() %>/Member/joinPro.me" class="login" method="post" enctype="multipart/form-data">
			<h2 class="loginHeading">푸드조아 회원 가입</h2>

			<div class="add">
				<h2>추가 정보 입력</h2>
			</div>

			<!-- 사용자 정보 입력 폼 -->
			<div class="form-container">
				<!-- 프로필 사진 선택 -->
				<div class="input-container">
					<input type="text" id="profile" name="profile" class="form-control" placeholder="프로필 사진을 넣어주세요" required readonly />
					<input type="file" name="profileFile" class="file-input" id="profileFile" onchange="updateFileName()" />
					<label for="profileFile" class="file-button">파일 선택</label>
				</div>

				<!-- 나머지 사용자 정보 입력 -->
				<div class="input-container">
					<input type="text" id="name" name="name" class="form-control" placeholder="이름을 입력해주세요" required />
					<input type="text" id="nickname" name="nickname" class="form-control" placeholder="닉네임을 입력해주세요" required />
					<input type="text" id="phone" name="phone" class="form-control" placeholder="휴대폰번호 입력해주세요" required />
					
					<p id="addressInput"></p> 
					<input type="text" id="sample4_postcode" name="address1" class="form-control" placeholder="우편번호">
					<input type="button" onclick="sample4_execDaumPostcode()" value="우편번호 찾기" class="form-control"><br>					
					<input type="text" id="sample4_roadAddress" name="address2" placeholder="도로명주소" class="form-control">
					<input type="text" id="sample4_detailAddress" placeholder="상세주소" name="address3" class="form-control">
						
					
				</div>

				<!-- 숨겨진 필드로 userId 전달 -->
				<input type="hidden" name="userId" value="<%= userId %>" /> 
				<br><br>
				<button class="joinButton" type="submit">회원가입</button>
			</div>
		</form>
	</div>

	<script>
		// 파일을 선택했을 때 input에 파일명 표시
		function updateFileName() {
			var fileInput = document.getElementById("profileFile");
			var profileInput = document.getElementById("profile");

			// 파일명이 있을 경우 input에 파일명 표시
			if (fileInput.files.length > 0) {
				profileInput.value = fileInput.files[0].name;
			}
		}
	</script>

	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    //본 예제에서는 도로명 주소 표기 방식에 대한 법령에 따라, 내려오는 데이터를 조합하여 올바른 주소를 구성하는 방법을 설명합니다.
    function sample4_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var roadAddr = data.roadAddress; // 도로명 주소 변수
                var extraRoadAddr = ''; // 참고 항목 변수
              
                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample4_postcode').value = data.zonecode;
                document.getElementById("sample4_roadAddress").value = roadAddr;
                
                // 참고항목 문자열이 있을 경우 해당 필드에 넣는다.
                if(roadAddr !== ''){
                    document.getElementById("sample4_extraAddress").value = extraRoadAddr;
                } else {
                    document.getElementById("sample4_extraAddress").value = '';
                }
  
            }
        }).open();
    }
</script>	
</body>
</html>
