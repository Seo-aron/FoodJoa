<%@page import="VOs.MemberVO"%>
<%@page import="VOs.MealkitVO"%>
<%@page import="VOs.MealkitOrderVO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	String contextPath = request.getContextPath();
        
	String id = (String) session.getAttribute("id"); 
	
	ArrayList<HashMap<String, Object>> orderedMealkitList = 
			(ArrayList<HashMap<String, Object>>) request.getAttribute("orderedMealkitList");
%>
<!DOCTYPE html>
<html>

<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=contextPath%>/css/member/mydelivery.css">
</head>

<body>
	<div id="deliver-container">
		<h1>배송조회 페이지<h1>
		<table width="100%">
			<%
			if (orderedMealkitList == null || orderedMealkitList.size() == 0) {
				%>
				<tr>
					<td>주문 내역이 없습니다.</td>
				</tr>
				<%
			}
			else {
				for (int i = 0; i < orderedMealkitList.size(); i++) {
					MealkitOrderVO orderVO = (MealkitOrderVO) orderedMealkitList.get(i).get("orderVO");
					MealkitVO mealkitVO = (MealkitVO) orderedMealkitList.get(i).get("mealkitVO");
					MemberVO memberVO = (MemberVO) orderedMealkitList.get(i).get("memberVO");
					
					%>
					<tr>
						<td>
							
						</td>
					</tr>
					<%
				}
			}
			%>
		</table>
	</div>

		<%-- <h2><%=vo.getNickname()%>님의 소중한 배송조회 </h2>
			<img src="<%=contextPath%>/images/mealkit/<%=vo.getPictures()%>">
			주소:<%=vo.getAddress()%> 수량:<%=vo.getAmount()%>
			배송여부	<%=vo.getDelivered()%><br>
			환불여부	<%=vo.getRefund()%><br>
			
			
			
			  
 				
 		</div> --%>
</body>
</html>