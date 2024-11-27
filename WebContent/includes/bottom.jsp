<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	request.setCharacterEncoding("UTF-8");
%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>

<body>
	<div id="bottom_container">
		<div id="bottomMenu">
			<table>
				<tr>
					<td>이용약관</td>
					<td>개인정보취급방침</td>
					<td>공지사항</td>
					<td>자주묻는질문</td>
				</tr>
				<div id="sns">
					<a href="#"><img src="${ contextPath }/images/bottom_image.png" alt=""></a>
				</div>
			</table>
		</div>
		<div id="company">
			<p>상호 : (주)푸드조아</p>
			<p>사업자 등록번호 : 123-45-6789</p>
			<p>통신판매업 신고 : 제 2024-부산-01호</p>
			<p>주소 : 부산광역시 부산진구 중앙대로 100 1동 101호 푸드조아</p>
			<p>전화번호 : 051-456-7890</p>
			<p>이메일 : foodjoa@foodjoa.com</p>
		</div>
	</div>
</body>

</html>