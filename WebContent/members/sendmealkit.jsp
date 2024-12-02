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
<title>발송조회 페이지</title>
<style>
    /* 메인 컨테이너 스타일링 */
    #deliver-container {
        margin: 0 auto; /* 가로 중앙 정렬 */
        width: 90%; /* 화면 너비의 90% 사용 */
    }
    /* 제목 스타일링 */
    #deliver-container h1 {
        text-align: center; /* 텍스트 가운데 정렬 */
    }
    /* 테이블 스타일링 */
    table {
        width: 100%; /* 테이블 너비를 100%로 설정 */
        border-collapse: collapse; /* 테이블 셀 경계선 결합 */
        margin: 20px 0; /* 테이블 위아래 여백 */
    }
    /* 테이블 헤더 스타일링 */
    table th {
        background-color: #f2f2f2; /* 헤더 배경색 */
        color: #333; /* 텍스트 색상 */
        padding: 10px; /* 셀 내부 여백 */
        text-align: center; /* 텍스트 가운데 정렬 */
        border: 1px solid #ddd; /* 셀 경계선 */
    }
    /* 테이블 데이터 셀 스타일링 */
    table td {
        padding: 10px; /* 셀 내부 여백 */
        text-align: center; /* 텍스트 가운데 정렬 */
        border: 1px solid #ddd; /* 셀 경계선 */
    }
    /* 버튼 스타일링 */
    .button {
        background-color: #4CAF50; /* 버튼 배경색 (녹색) */
        border: none; /* 버튼 테두리 없음 */
        color: white; /* 버튼 텍스트 색상 (흰색) */
        padding: 10px 20px; /* 버튼 내부 여백 */
        text-align: center; /* 텍스트 가운데 정렬 */
        text-decoration: none; /* 텍스트 밑줄 제거 */
        display: inline-block; /* 인라인 블록 요소로 설정 */
        font-size: 16px; /* 텍스트 크기 */
        margin: 5px; /* 버튼 간격 */
        cursor: pointer; /* 포인터 커서 표시 */
        border-radius: 4px; /* 둥근 모서리 설정 */
    }
    /* 이미지 스타일링 */
    img {
        max-width: 100%; /* 이미지 최대 너비를 셀 너비에 맞춤 */
        height: auto; /* 이미지 비율을 유지하여 자동 높이 설정 */
        border-radius: 4px; /* 이미지 둥근 모서리 설정 */
    }
</style>
</head>

<body>
    <!-- 메인 컨테이너 -->
    <div id="deliver-container">
        <h1>발송조회 페이지</h1>
        <!-- 저장 버튼 추가를 위한 form 태그 -->
        <form action="<%= request.getContextPath() %>/Member/orderUpdate.me" method="post">
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
                        <th>제목</th>
                        <th>간단소개글</th>
                        <th>카테고리</th>
                        <th>가격</th>
                        <th>재고</th>
                        <th>사진</th>
                        <th>주소</th>
                        <th>수량</th>
                        <th>배송여부</th>
                        <th>환불여부</th>
                        <th>이름</th>
                        <th>사진</th>
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
                    	<td><%=mealkitVO.getTitle() %></td>
                    	<td><%=mealkitVO.getContents()%></td>
                    	<td>
						<% if(mealkitVO.getCategory() == 0 ){%> 한식요리 <%}%>
						<% if(mealkitVO.getCategory() == 1 ){%> 일식요리 <%}%>
						<% if(mealkitVO.getCategory() == 2 ){ %>중식요리 <%}%>
						<% if(mealkitVO.getCategory() == 3 ){ %>양식요리 <%}%>
						<% if(mealkitVO.getCategory() == 4 ){ %>자취요리 <%}%>
						</td>
                    	<td><%=mealkitVO.getPrice()%></td>
                    	<td><%=mealkitVO.getStock()%></td>
                        <td> <img src="<%=request.getContextPath()%>/images/member/userProfiles/profilePhoto/<%= mealkitVO.getPictures()%>" alt="사진없음"></td>
                        <td><%=memberVO.getAddress()%></td>
                        <td><%=orderVO.getQuantity()%></td>            
                        <td>
                        <select name="deliveryStatus_<%= orderVO.getNo() %>">
						    <option value="0" <% if(orderVO.getDelivered() == 0) { %>selected<% } %>>배송 전</option>
						    <option value="1" <% if(orderVO.getDelivered() == 1) { %>selected<% } %>>배송 중</option>
						    <option value="2" <% if(orderVO.getDelivered() == 2) { %>selected<% } %>>배송 완료</option>
						</select>

                      </td>
                      <td>
                         <select name="refundStatus">
                          <option value="0" <% if(orderVO.getDelivered() == 0) { %>selected<% } %>>환불 전</option>
                          <option value="1" <% if(orderVO.getDelivered() == 1) { %>selected<% } %>>환불 중</option>
                          <option value="2" <% if(orderVO.getDelivered() == 2) { %>selected<% } %>>환불 완료</option>
                        </select> 
                      </td>
                         <td><%=memberVO.getNickname()%></td>
                         <td><img src="<%=request.getContextPath()%>/images/member/userProfiles/profilePhoto/<%= memberVO.getProfile() %>" alt="판매자 프로필"></td>          
                    </tr>
                <%
                } // for 루프 종료
                %>
                </tbody>
            <%
            } // if-else 종료
            %>
        </table>
        </form>
    </div>
</body>
</html>