<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	String contextPath = request.getContextPath();
        
	String id = (String) session.getAttribute("id"); 
%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=contextPath%>/css/member/mydelivery.css">
</head>
<body>
	
</body>
</html>