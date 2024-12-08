<%@page import="Common.StringParser"%>
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

ArrayList<HashMap<String, Object>> orderedMealkitList = (ArrayList<HashMap<String, Object>>) request
		.getAttribute("orderedMealkitList");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet"
	href="<%=contextPath%>/css/member/sendmealkit.css">
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
            url: "<%=request.getContextPath()%>/Member/orderUpdate.me",
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
			<table align="center">
				<%
				// 주문된 밀키트 리스트가 비어있는지 확인합니다.
				if (orderedMealkitList == null || orderedMealkitList.size() == 0) {
				%>
				<!-- 주문 내역이 없을 때 표시할 메시지 -->
				<tr>
					<td class="no">주문 내역이 없습니다.</td>
				</tr>
				<%
				} else {
				%>
				<!-- 테이블 헤더 -->
				<thead>
					<tr>
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
						<th>구매자 <br> 사진
						</th>
						<th>저장</th>
					</tr>
				</thead>
				<tbody>
					<%
					// 주문된 밀키트 리스트를 반복하면서 각 주문의 정보를 출력합니다.
					for (int i = 0; i < orderedMealkitList.size(); i++) {
						MealkitOrderVO orderVO = (MealkitOrderVO) orderedMealkitList.get(i).get("orderVO");
						MealkitVO mealkitVO = (MealkitVO) orderedMealkitList.get(i).get("mealkitVO");
						MemberVO memberVO = (MemberVO) orderedMealkitList.get(i).get("memberVO");
						
						String thumbnail = StringParser.splitString(mealkitVO.getPictures()).get(0);
					%>
					<!-- 각 주문의 데이터를 테이블 행으로 출력 -->
					<tr data-order-no="<%=orderVO.getNo()%>">
						<td><p><%=mealkitVO.getTitle()%></p></td>
						<td><p><%=mealkitVO.getContents()%></p></td>
						<td><p>
								<%
								if (mealkitVO.getCategory() == 0) {
								%>
								한식요리
								<%
								}
								%>
								<%
								if (mealkitVO.getCategory() == 1) {
								%>
								일식요리
								<%
								}
								%>
								<%
								if (mealkitVO.getCategory() == 2) {
								%>중식요리
								<%
								}
								%>
								<%
								if (mealkitVO.getCategory() == 3) {
								%>양식요리
								<%
								}
								%>
								<%
								if (mealkitVO.getCategory() == 4) {
								%>자취요리
								<%
								}
								%>
							</p></td>
						<td><p><%=mealkitVO.getPrice()%></p></td>
						<td>
							<div class="thumbnail-area">
								<img src="<%= request.getContextPath() %>/images/mealkit/thumbnails/<%=mealkitVO.getNo()%>/<%= thumbnail %>">
							</div>
						</td>
						<td><p><%=orderVO.getAddress()%></p></td>
						<td><p><%=orderVO.getQuantity()%></p></td>
						<td>
							<p>
								<select name="deliveredStatus" class="deliveredStatus">
									<option value="0" <%=orderVO.getDelivered() == 0 ? "selected" : ""%>>
										배송 전
									</option>
									<option value="1" <%=orderVO.getDelivered() == 1 ? "selected" : ""%>>
										배송 중
									</option>
									<option value="2" <%=orderVO.getDelivered() == 2 ? "selected" : ""%>>
										배송 완료
									</option>
								</select>
							</p>
						</td>
						<td>
							<p>
								<select name="refundStatus" class="refundStatus">
									<option value="0" <%=orderVO.getRefund() == 0 ? "selected" : ""%>>
										환불 전
									</option>
									<option value="1" <%=orderVO.getRefund() == 1 ? "selected" : ""%>>
										환불 중
									</option>
									<option value="2" <%=orderVO.getRefund() == 2 ? "selected" : ""%>>
										환불 완료
									</option>
								</select>
							</p>
						</td>
						<td><p><%=memberVO.getNickname()%></p></td>
						<td>
							<div class="profile-area">
								<img src="<%=request.getContextPath()%>/images/member/userProfiles/<%= orderVO.getId() %>/<%=memberVO.getProfile()%>" >
							</div>
						</td>
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
	</div>
</body>
</html>