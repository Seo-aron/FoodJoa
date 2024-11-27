<%@page import="VOs.DeliveryInfoVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	String contextPath = request.getContextPath();
        
	String id = (String) session.getAttribute("id"); 
	DeliveryInfoVO vo = new DeliveryInfoVO();
%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=contextPath%>/css/member/mydelivery.css">
</head>
<body>
	<a href="<%=contextPath%>/Member/viewMySend.me"></a>
	<h1>배송조회 페이지<h1><br>

		<h2><%=vo.getNickname()%>님의 소중한 배송조회 </h2>
			<img src="<%=contextPath%>/images/mealkit/<%=vo.getPictures()%>">
			주소:<%=vo.getAddress()%> 수량:<%=vo.getAmount()%>
			배송여부	<%=vo.getDelivered()%><br>
			환불여부	<%=vo.getRefund()%><br>
			
			
			
			  
 				
 		</div>
</body>
</html>