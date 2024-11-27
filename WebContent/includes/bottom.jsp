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

<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
<style>
	#bottom_container {
		margin: 0 auto;
		width: 1200px;
		font-family: "Noto Serif KR", serif;
	    font-optical-sizing: auto;
	}
	
	/* 기본 폰트 설정 */
body {
    font-family: "Noto Serif KR", serif;
    margin: 0;
    padding: 0;
    background-color: #ffffff; /* 배경색: 화이트 */
    color: #333333; /* 기본 글자색: 다크 그레이 */
}

#bottom_container {
    margin: 0 auto;
    width: 1200px;
    text-align: center;
    padding: 20px 0;
    border-top: 1px solid #e0e0e0; /* 상단 경계선 */
}

#bottomMenu {
    margin-bottom: 20px;
}

#bottomMenu table {
    width: 100%;
    border-collapse: collapse;
}

#bottomMenu td {
    font-size: 14px;
    padding: 10px;
    color: #666666; /* 텍스트 색상 */
    cursor: pointer;
    transition: color 0.3s ease;
}

#bottomMenu td:hover {
    color: #000000; /* 호버 시 검정색 강조 */
}

#sns {
    margin-top: 20px;
}

#sns a img {
    width: 300px; /* 아이콘 크기 */
    height: 100px;
    object-fit: contain;
    transition: transform 0.3s ease;
}

#sns a img:hover {
    transform: scale(1.1); /* 호버 시 확대 효과 */
}

#company {
    font-size: 12px;
    line-height: 1.6;
    color: #888888; /* 텍스트 색상 */
}

#company p {
    margin: 5px 0;
}
	
</style>
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
					<a href="#">
						<img src="${contextPath}/images/mainpage/bottom_image.png" alt="하단이미지">
					</a>
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