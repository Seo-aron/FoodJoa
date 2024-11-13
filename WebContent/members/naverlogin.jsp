<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- 
1. 첫 화면 (로그인 버튼 화면)
이 JSP 페이지에서는 사용자가 네이버 로그인을 시작할 수 있는 버튼을 표시합니다.

client_id는 네이버 개발자 센터에서 발급받은 애플리케이션 ID입니다.
redirect_uri는 네이버 인증 후 리디렉션되는 콜백 URL입니다.
state는 CSRF 공격 방지를 위해 추가하는 고유값입니다.

-->

<%-- 네이버 로그인 버튼 --%>
<a href="https://nid.naver.com/oauth2.0/authorize?client_id=XhLz64aZjKhLJHJUdga6&response_type=code&redirect_uri=http://localhost:8090/FoodJoa/Member/naverlogin.me&state=YOUR_STATE">
    <img height="50" src="../images/member/naverlogin.png"/>
</a>


</body>
</html>