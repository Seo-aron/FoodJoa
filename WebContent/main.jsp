<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	request.setCharacterEncoding("UTF-8");
	
	String pageTitle = (String) request.getAttribute("pageTitle");
%>

<c:set var="center" value="${requestScope.center}"/>

<c:if test="${center == null}">
	<c:set var="center" value="includes/center.jsp"/>
</c:if>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title><%= pageTitle %></title>
</head>

<body>
	<center>
		<table width="100%">
			<tr>
				<td><jsp:include page="includes/top.jsp"/></td>
			</tr>
			<tr>
				<td><jsp:include page="${center}"/></td>
			</tr>
			<tr>
				<td><jsp:include page="includes/bottom.jsp"/></td>
			</tr>
		</table>
	</center>
</body>

</html>