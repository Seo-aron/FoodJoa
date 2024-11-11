<%@ page import="java.util.Enumeration" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 세션에서 userId 값 가져오기
    String userId = (String) session.getAttribute("userId");
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
    .input-container { display: flex; flex-direction: column; align-items: center; gap: 20px; }
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
	<div class="container">
		<!-- 회원가입 폼 -->
		<form class="login" action="<%= request.getContextPath() %>/Member/joinPro.me" method="post" enctype="multipart/form-data">
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
					<input type="text" id="address" name="address" class="form-control" placeholder="주소를 입력해주세요" required />
				</div>

				<!-- 숨겨진 필드로 userId 전달 -->
				<input type="hidden" name="userId" value="<%= userId %>" />

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

	<script src="https://code.jquery.com/jquery-3.5.1.min.js"
		integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy5I5t+QpX/0v9zJ0p6z20QGyZYyFZndxFyD1J37"
		crossorigin="anonymous"></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"
		integrity="sha384-pzjw8f+ua7Kw1TIq0U5W9coI4h2f9B5gM5rZnnmLqlF6VTXGg7y69th7iCxg7pR"
		crossorigin="anonymous"></script>
</body>
</html>
