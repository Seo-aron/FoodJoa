<%@page import="org.json.JSONObject"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!--
 5. 사용자 정보 표시 페이지
마지막 JSP 페이지에서는 가져온 사용자 프로필 정보를 표시합니다.
-->

<%
    JSONObject userProfile = (JSONObject) request.getAttribute("userProfile");
%>

<h2>네이버 사용자 프로필 정보</h2>
<p>이름: <%= userProfile.getString("name") %></p>
<p>아이디: <%= userProfile.getString("id") %></p>
<p>닉네임: <%= userProfile.getString("nickname") %></p>
<p>이메일: <%= userProfile.getString("email") %></p>
<p>성별: <%= userProfile.getString("gender") %></p>
<p>프로필 이미지: <img src="<%= userProfile.getString("profile_image") %>" alt="Profile Image"></p>

</body>
</html>