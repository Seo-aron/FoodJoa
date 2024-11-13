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
<title>카카오 로그인</title>
</head>
<body>
    <!-- 이미지가 버튼처럼 클릭되도록 a 태그로 감싸기 -->
    <a href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=dfedef18f339b433884cc51b005f2b42&redirect_uri=http://localhost:8090/FoodJoa/members/join.jsp">
        <img src="../images/member/kakaologin.png" alt="Kakao Login Button">
    </a>
</body>
</html>
