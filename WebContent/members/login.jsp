<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=utf-8");

String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>푸드조아 로그인</title>
	
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
	<style>
		#login-container {
			display: flex;
			margin: 0 auto;
			height: 600px;
			align-items: center;
		}
		
		#login-container table {
			border-spacing: 0px 20px;
		}
		
		.login-label {
			font-family: "Noto Serif KR", serif;
		}
		
		.login-label p:nth-child(1) {
			font-size: 2rem;
			margin-bottom: 20px;
		}
		
		.login-label p:nth-child(2) {
			font-size: 1.5rem;
			margin-bottom: 40px;
		}
		
		.login-button {
			position: relative;
			width: 400px;
			height: 70px;
			padding: 10px;
			border: 1px solid #BF917E;
			border-radius: 5px;
			color: #BF917E;
			box-shadow: 5px 5px 10px rgba(0, 0, 0, 0.3);
		}
		
		.login-logo {
			position: absolute;
			width: 50px;
			height: 50px;
			overflow: hidden;
			left: 10px;
		}
		
		.login-logo img {
			width: 100%;
			height: 100%;
			object-fit: cover;
		}
		
		.login-button-label {
			font-family: "Noto Serif KR", serif;
			font-size: 1rem;
			width: 100%;
			height: 48px;
			line-height: 48px;
			margin-left: 30px;
		}
	</style>
</head>

<body>
	<div id="login-container">		
		<table width="100%">
			<tr>
				<td align="center">
					<div class="login-label">
						<p>FoodJoa 로그인</p>
						<p>FoodJoa에 오신 것을 환영합니다.</p>
					</div>
				</td>
			</tr>
			<tr>
				<td align="center">
					<div class="login-button">
						<a href="https://nid.naver.com/oauth2.0/authorize?client_id=XhLz64aZjKhLJHJUdga6&response_type=code&redirect_uri=http://localhost:8090/FoodJoa/Member/naverlogin.me&state=YOUR_STATE">
							<div class="login-logo">
								<img src="<%=contextPath%>/images/member/naverlogo.png" />
							</div>
							<div class="login-button-label">
								네이버 아이디로 로그인하기
							</div>
						</a>
					</div>
				</td>
			</tr>

			<tr>
				<td align="center">
					<div class="login-button">
						<a href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=dfedef18f339b433884cc51b005f2b42&redirect_uri=http://localhost:8090/FoodJoa/Member/kakaologin.me">
							<div class="login-logo">
								<img src="<%=contextPath%>/images/member/kakaologo.png">
							</div>
							<div class="login-button-label">
								카카오 아이디로 로그인하기
							</div>
						</a>
					</div>
				</td>
			</tr>
		</table>
	</div>
</body>

</html>