<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	
	String contextPath = request.getContextPath();
%>

<html>
  <head>
    <title>SNS 회원가입</title>
  </head>
  <body>
<center>
		<table width="100%">
			<tr>
				<td><jsp:include page="/members/naverlogin.jsp"/></td>
			</tr>
			
			<tr>
				<td><jsp:include page="/members/kakaologin.jsp"/></td>
			</tr>
		</table>
	</center>
  </body>
</html>