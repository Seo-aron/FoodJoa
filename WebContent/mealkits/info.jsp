<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="VOs.MealkitVO" %>
<%@ page import="Services.MealkitService" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>${mealkitvo.title }</title>
	
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>	
	<style type="text/css">
		#container{
			width: 1200px;
		}
	</style>
</head>
<body>
	<div id="container">
		<table>
			<tr>
				<td><jsp:include page="board.jsp" flush="true" /></td>
			</tr>
			<tr>
				<td><jsp:include page="review.jsp" flush="true" /></td>
			</tr>
			<tr>
				<%-- <td><jsp:include page="recent.jsp" /></td> --%>
			</tr>
		</table>
	</div>
</body>
</html>