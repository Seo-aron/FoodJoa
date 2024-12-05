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
<style>
/* 메인 컨테이너 스타일링 */
#deliver-container {
    margin: 0 auto; /* 가로 중앙 정렬 */
    width: 1200px; /* 화면 너비의 90% 사용 */
}

/* 제목 스타일링 */
#deliver-container h1 {
    text-align: center; /* 텍스트 가운데 정렬 */
    color: #000000; /* 텍스트 색상 */
    font-size: 24px; /* 텍스트 크기 */
    margin-bottom: 20px; /* 하단 여백 */
}

/* 테이블 스타일링 */
table {
    width: 100%; /* 테이블 너비를 100%로 설정 */
    border-collapse: collapse; /* 테이블 셀 경계선 결합 */
    margin: 20px 0; /* 테이블 위아래 여백 */
    font-family:  "Noto Serif KR", serif; /* 폰트 스타일 설정 */
}

/* 테이블 헤더 스타일링 */
table th {
    background-color: #BF917E; /* 헤더 배경색 */
    color: #333; /* 텍스트 색상 */
    padding: 12px 15px; /* 셀 내부 여백 */
    text-align: center; /* 텍스트 가운데 정렬 */
    border: 1px solid #ddd; /* 셀 경계선 */
}

/* 테이블 데이터 셀 스타일링 */
table td {
    padding: 12px 15px; /* 셀 내부 여백 */
    text-align: center; /* 텍스트 가운데 정렬 */
    border: 1px solid #ddd; /* 셀 경계선 */
}

/* 테이블 행 스타일링 (홀수 행 배경색) */
table tr:nth-child(odd) {
    background-color: #f9f9f9; /* 홀수 행 배경색 */
}

/* 테이블 행 스타일링 (짝수 행 배경색) */
table tr:nth-child(even) {
    background-color: #ffffff; /* 짝수 행 배경색 */
}

/* 이미지 스타일링 */
img {
    max-width: 100%; /* 이미지 최대 너비를 셀 너비에 맞춤 */
    height: auto; /* 이미지 비율을 유지하여 자동 높이 설정 */
    border-radius: 4px; /* 이미지 둥근 모서리 설정 */
}
</style>
<link rel="stylesheet" href="<%=contextPath%>/css/member/mydelivery.css">
<title>배송조회 페이지</title>
</head>
<body>
    <!-- 메인 컨테이너 -->
    <div id="deliver-container">
        <h1>배송조회 페이지</h1>
        <!-- 테이블을 생성하여 가운데 정렬하고 100% 너비를 설정합니다. -->
        <table align="center">
            <%
            // 주문된 밀키트 리스트가 비어있는지 확인합니다.
            if (orderedMealkitList == null || orderedMealkitList.size() == 0) {
            %>
                <!-- 주문 내역이 없을 때 표시할 메시지 -->
                <tr>
                    <td colspan="13" align="center">주문 내역이 없습니다.</td>
                </tr>
            <%
            } else {
            %>
                <!-- 테이블 헤더 -->
                <thead>
                    <tr align="center">
                        <th>내 주소</th>
                        <th>수량</th>
                        <th>배송 여부</th>
                        <th>환불 여부</th>
                        <th>상품명</th>
                        <th>간단소개글</th>
                        <th>카테고리</th>
                        <th>상품가격(개당)</th>
                        <th>상품사진</th>
                        <th>판매자 닉네임</th>
                        <th>판매자 사진</th>
                      </tr>
                </thead>
                <tbody>
                <%
                // 주문된 밀키트 리스트를 반복하면서 각 주문의 정보를 출력합니다.
                for (int i = 0; i < orderedMealkitList.size(); i++) {
                    MealkitOrderVO orderVO = (MealkitOrderVO) orderedMealkitList.get(i).get("orderVO");
                    MealkitVO mealkitVO = (MealkitVO) orderedMealkitList.get(i).get("mealkitVO");
                    MemberVO memberVO = (MemberVO) orderedMealkitList.get(i).get("memberVO");
                %>
                    <!-- 각 주문의 데이터를 테이블 행으로 출력 -->
                    <tr align="center">
                        <td><%=orderVO.getAddress()%></td>
                        <td><%=orderVO.getQuantity()%></td> 
                        <td><%
                        if(orderVO.getDelivered()==0){
                        	%>배송 전<%
                       	 }else if(orderVO.getDelivered()==1){
                        	%>배송 중<% 
                         }else{
                        	%>배송 완료<%
                         }%></td>
                        <td><%
                        if(orderVO.getRefund()==0){
                        	%>환불 전<%
                       	 }else if(orderVO.getRefund()==1){
                        	%>환불 중<% 
                         }else{
                        	%>환불 완료<%
                         }%></td>
                       
                        <td><%=mealkitVO.getTitle() %></td>
                        <td><%=mealkitVO.getContents()%></td>
                        <td><% if(mealkitVO.getCategory() == 0 ){%> 한식요리 <%}%>
							<% if(mealkitVO.getCategory() == 1 ){%> 일식요리 <%}%>
							<% if(mealkitVO.getCategory() == 2 ){ %>중식요리 <%}%>
							<% if(mealkitVO.getCategory() == 3 ){ %>양식요리 <%}%>
							<% if(mealkitVO.getCategory() == 4 ){ %>자취요리 <%}%>
						</td>
                        <td><%=mealkitVO.getPrice()%></td>
                        <td>
                            <!-- 주문된 밀키트의 사진을 출력 -->
                            <img src="<%=request.getContextPath()%>/images/member/userProfiles/profilePhoto/<%= mealkitVO.getPictures()%>" alt="상품사진">
                        </td>
                        <td><%=memberVO.getNickname()%></td>
                        <td>
                            <!-- 판매자의 프로필 사진을 출력 -->
                            <img src="<%=request.getContextPath()%>/images/member/userProfiles/profilePhoto/<%= memberVO.getProfile() %>" alt="판매자 프로필">
                        </td>
                    </tr>
                <%
                } // for 루프 종료
                %>
                </tbody>
            <%
            } // if-else 종료
            %>
        </table>
    </div>
</body>
</html>
