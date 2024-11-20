<%@page import="VOs.MemberVO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
 
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	
	String contextPath = request.getContextPath();
	
	MemberVO vo = (MemberVO) request.getAttribute("vo");
	
	//String loginedid = (String) session.getAttribute("id");	
	String id = "admin";
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<link rel="stylesheet" href="<%=contextPath%>/css/member/mypagemain.css">

</head>
<body>

	<div class="header">
		<h1>마이페이지</h1>
		<a href="<%=contextPath%>/main.jsp"> <input type="button"
			class="logout-btn" value="로그아웃">
		</a>
	</div>

	<div class="profile-wrapper">
		<div class="profile-section">
			<div class="profile-image">
				<img alt="없음" src="../images/member/admin.png">
			</div>
			<div class="profile-info">
				<h2>김보노님!</h2>
				<p>푸드조아와 함께한지 999일째♥</p>
				<form action="profileupdate.jsp" method="get">
					<button onclick="checkConditionAndProceed()">정보수정</button>
				</form>
			</div>


		</div>

		<div class="manage-section">
			<div>
				<a href="<%=contextPath%>/members/myreceipe.jsp">
					<p align="center">내 레시피 관리</p> <img src="../images/레시피.png"
					alt="레시피 이미지">
				</a>
			</div>
			<div>
				<a href="<%=contextPath%>/members/myproduct.jsp">
					<p align="center">내 상품 관리</p> <img src="../images/상품사진.png"
					alt="상품 이미지">
				</a>
			</div>
			<div>
				<a href="<%=contextPath%>/members/myreview.jsp">
					<p align="center">내 리뷰 관리</p> <img src="../images/손모양.png"
					alt="리뷰 이미지">
				</a>

			</div>
		</div>

		<!-- Info Sections -->
		<div class="info-section">
			<div>주문/배송조회</div>
				<div style="display: flex;">
				<span>주문건수 : 0</span> | <span>배송준비중 : 1</span> | <span>배송중 : 2</span> |
				<span>배송완료 : 0</span>
				 <a href="<%=contextPath%>/Member/myorder.me" style="margin-left: auto;">더보기</a>
			</div>
		</div>

		<div class="info-section">
			<div>내 마켓 발송 현황</div>
				<div style="display: flex;">
			    <span>주문건수 : 0 </span> | <span>배송준비중 : 1 </span> | <span>배송중 : 2 </span> |
			    <span>배송완료 : 0 </span>
			    <a href="<%=contextPath%>/Member/sendMyMealkit.me" style="margin-left: auto;">더보기</a>
		</div>
		</div>

		<div class="info-section">
			<div><a href="<%=contextPath%>/members/processingpolicy.jsp">※ 개인정보처리방침</a></div>
		</div>

		<div>
		<a href="<%=contextPath%>/Member/deleteMember.me">
		<button>탈퇴하기</button>
		</a>
		</div>

</head>

</body>
</html>
