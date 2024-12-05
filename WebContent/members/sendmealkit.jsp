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
<head>
<meta charset="UTF-8">
<title>발송조회 페이지</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(document).ready(function() {
    $(".save-button").click(function() {
        // 현재 행의 데이터를 가져옴
        const row = $(this).closest("tr");
        const orderNo = row.data("order-no");
        const deliveredStatus = row.find(".deliveredStatus").val();
        const refundStatus = row.find(".refundStatus").val();

        // Ajax 요청
        $.ajax({
            url: "<%= request.getContextPath() %>/Member/orderUpdate.me",
            type: "POST",
            data: {
                orderNo: orderNo,
                deliveredStatus: deliveredStatus,
                refundStatus: refundStatus
            },
            success: function(response) {
                alert("저장되었습니다.");
                // 필요한 경우 DOM 업데이트를 추가
            },
            error: function() {
                alert("저장에 실패했습니다.");
            }
        });
    });
});
</script>
</head>

<body>
    <!-- 메인 컨테이너 -->
    <div id="deliver-container">
        <h1>발송조회 페이지</h1>
        <% String message = (String) request.getAttribute("message"); 
        if (message != null){
        %><script> alert("<%= message %>");</script> 
        <% 
        }
        %>
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
                        <th>상품명</th>
                        <th>간단소개글</th>
                        <th>카테고리</th>
                        <th>상품가격(개당)</th>
                        <th>상품사진</th>
                        <th>주소지</th>
                        <th>수량</th>
                        <th>배송 여부</th>
                        <th>환불 여부</th>
                        <th>구매자 닉네임</th>
                        <th>구매자 사진</th>
                        <th>저장하기</th>
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
                    <tr align="center" data-order-no="<%= orderVO.getNo() %>">
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
                        <td><img src="<%= request.getContextPath() %>/images/mealkit/thumbnails/<%=mealkitVO.getNo()%>/<%=mealkitVO.getId()%>/<%=mealkitVO.getPictures().substring(4) %>" 
                             alt="${item.mealkitVO.title}"></td>
                        <td><%=orderVO.getAddress()%></td>
                        <td><%=orderVO.getQuantity()%></td>            
                       <td>
					    <select name="deliveredStatus" class="deliveredStatus">
					        <option value="0" <%= orderVO.getDelivered() == 0 ? "selected" : "" %>>배송 전</option>
					        <option value="1" <%= orderVO.getDelivered() == 1 ? "selected" : "" %>>배송 중</option>
					        <option value="2" <%= orderVO.getDelivered() == 2 ? "selected" : "" %>>배송 완료</option>
					    </select>
					  </td>
					  <td>
					    <select name="refundStatus" class="refundStatus">          	
					        <option value="0" <%= orderVO.getRefund() == 0 ? "selected" : "" %>>환불 전</option>
					        <option value="1" <%= orderVO.getRefund() == 1 ? "selected" : "" %>>환불 중</option>
					        <option value="2" <%= orderVO.getRefund() == 2 ? "selected" : "" %>>환불 완료</option>
					    </select>
					  </td>
                      <td><%=memberVO.getNickname()%></td>
                      	<td><img src="<%=request.getContextPath()%>/images/member/userProfiles/profilePhoto/<%= memberVO.getProfile() %>" alt="판매자 프로필"></td>          
                      	<td>
                      		<button type="button" class="save-button">저장</button>
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
          <div>
    </div>
        </form>
    </div>
</body>
</html>