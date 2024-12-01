<%@page import="java.util.ArrayList"%>
<%@page import="VOs.MemberVO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ page import="java.time.LocalDate"%>
<%@ page import="java.time.temporal.ChronoUnit"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.sql.Timestamp"%>
<%@ page import="java.time.ZoneId"%>
<%@ page import="DAOs.MemberDAO"%>

<%
request.setCharacterEncoding("UTF-8");
response.setContentType("text/html; charset=utf-8");

String contextPath = request.getContextPath();

String userId = (String) session.getAttribute("userId");   

MemberDAO memberDAO = new MemberDAO();

ArrayList<Integer> orderCounts = (ArrayList<Integer>) request.getAttribute("orderCounts");

int totalOrderCount = 0;

for(int i = 0; i < orderCounts.size(); i++) {
	totalOrderCount  += orderCounts.get(i);
}

// 가입 날짜 가져오기
Timestamp joinDate = memberDAO.selectJoinDate(userId);

// Timestamp를 LocalDate로 변환
LocalDate receivedDate = joinDate.toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate();

// 현재 날짜
LocalDate currentDate = LocalDate.now();

// 두 날짜 사이의 일 수 차이 계산
long daysBetween = ChronoUnit.DAYS.between(receivedDate, currentDate)+1;

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
      <a href="<%=contextPath%>/mypagemain.me">
         <input type="button" class="logout-btn" value="로그아웃">
      </a>
   </div>

	<div class="profile-wrapper">
		<div class="profile-section">
			<div class="profile-image">
				<img src="<%=contextPath%>/images/member/userProfiles/${member.id}/${member.profile}" alt="Profile Image">
			</div>
			<div class="profile-info">
				<h2>${member.nickname}</h2>
				<%
				if (joinDate != null) {
					%>
					<p>
						${member.nickname}님은 푸드조아와 함께한지 <strong><%=daysBetween%></strong>일째입니다!
					</p>
					<%
				} else {
					%>
					<p>가입 정보를 가져올 수 없습니다. 관리자에게 문의하세요.</p>
					<%
				}
				%>
				<button id="updateButton">정보수정</button>
			</div>
		</div>

      <div class="manage-section">
         <div>
            <a href="<%=contextPath%>/Recipe/myRecipes">
               <p align="center">내 레시피 관리</p>
               <img src="../images/member/receipe.png" alt="레시피 이미지">
            </a>
         </div>
         <div>
            <a href="<%=contextPath%>/members/myproduct.jsp">
               <p align="center">내 상품 관리</p>
               <img src="../images/member/product.png" alt="상품 이미지">
            </a>
         </div>
         <div>
            <a href="<%=contextPath%>/members/myreview.jsp">
               <p align="center">내 리뷰 관리</p>
               <img src="../images/member/hand.png" alt="리뷰 이미지">
            </a>

         </div>
      </div>
      
      <!-- Info Sections -->
      <div class="info-section">
         <div>주문/배송조회</div>
         <div style="display: flex;">
            <span>주문건수 : <%= totalOrderCount %></span> &nbsp;&nbsp; | &nbsp;&nbsp;   
            <span>배송준비중 : <%= orderCounts.get(0) %></span> &nbsp;&nbsp; | &nbsp;&nbsp;
            <span>배송중 : <%= orderCounts.get(1) %></span> &nbsp;&nbsp; | &nbsp;&nbsp;
            <span>배송완료 : <%= orderCounts.get(2) %></span>
            <a href="<%=contextPath%>/Member/viewMyDelivery.me" style="margin-left: auto;">더보기</a>
         </div>
      </div>

      <div class="info-section">
         <div>내 마켓 발송 현황</div>
        <div style="display: flex;">
            <span>주문건수 : <%= totalOrderCount %></span> &nbsp;&nbsp; | &nbsp;&nbsp;   
            <span>배송준비중 : <%= orderCounts.get(0) %></span> &nbsp;&nbsp; | &nbsp;&nbsp;
            <span>배송중 : <%= orderCounts.get(1) %></span> &nbsp;&nbsp; | &nbsp;&nbsp;
            <span>배송완료 : <%= orderCounts.get(2) %></span>
            <a href="<%=contextPath%>/Member/viewMySend.me" style="margin-left: auto;">더보기</a>
         </div>
      </div>

      <div class="info-section">
         <div>
            <a href="<%=contextPath%>/members/processingpolicy.jsp">※
               개인정보처리방침</a>
         </div>
      </div>

      <div>
         <a href="<%=contextPath%>/Member/deleteMember.me">
            <button>탈퇴하기</button>
         </a>
      </div>

 
   </div>

   <script>
      document.getElementById('updateButton').onclick = function() {
         location.href = '<%=contextPath%>/Member/update.me';
      };

      // 파일을 선택하면 미리보기 이미지를 표시
      function previewImage(event) {
         const reader = new FileReader();
         reader.onload = function() {
            const output = document.getElementById('profilePreview');
            output.src = reader.result;
         };
         reader.readAsDataURL(event.target.files[0]);
      }

    
   </script>
</head>

</body>
</html>
