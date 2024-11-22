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
<title>Insert title here</title>
<link rel="stylesheet" href="<%=contextPath%>/css/member/mydelivery.css">
</head>
<body>
	<a href="<%=contextPath%>/Member/viewMyDelivery.me"></a>
	<h1>배송조회 페이지<h1><br>

		<div>
			<h3>배송 준비중</h3><br>
				 <img src="../images/member/아래화살표.png"">제품 이름 , 사진, 수량
		</div>
		<div>
			<h3>배송중</h3><br> 
				<img src="../images/member/아래화살표.png"">제품 이름 , 사진, 수량
		</div>
		<div>
			<h3>배송완료</h3><br> 
				제품 이름 , 사진, 수량
				멤버,밀키트,밀키트오더 조인
				select A 
                              
 				
 		</div>
</body>
</html>