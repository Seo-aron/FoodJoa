<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
%>

<c:set var="center" value="${requestScope.center}"/>
<%-- <c:set var="contextPath" value="${requestScope['javax.servlet.forward.request_uri']}" /> --%>

<c:if test="${center == null}">
	<c:set var="center" value="./includes/center.jsp"/>
</c:if>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>

<body>
	<table>
		<tr>
			<td><jsp:include page="./includes/top.jsp"/></td>
		</tr>
		<tr>
			<td height="500"><jsp:include page="${center}"/></td>
		</tr>
		<tr>
			<td><jsp:include page="./includes/bottom.jsp" /><td>
		</tr>
	</table>
</body>

</html>