<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, org.json.*, java.net.*, java.io.*" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- 
2. 네이버 인증 후 콜백 URL 페이지 (Authorization Code 수신)
  인증을 마친 후 네이버는 redirect_uri로 지정된 콜백 페이지에 code와 state 값을 전달합니다. 
  이 code는 Access Token을 요청할 때 사용됩니다.
 -->
<%
    String code = request.getParameter("code");
    String state = request.getParameter("state");

    
    
    // code가 null이 아니면 토큰을 요청하는 Servlet으로 리디렉션
    if (code != null) {
    	response.sendRedirect("tokenRequestServlet?code=" + code + "&state=" + state);
    } else {
        out.println("인증 실패!");
    }
%>


</body>
</html>