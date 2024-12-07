<%@page import="Common.StringParser"%>
<%@page import="VOs.MealkitVO"%>
<%@page import="VOs.MemberVO"%>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=utf-8");
    
    String contextPath = request.getContextPath();

    // selectedItems를 세션에서 가져오기
    //ArrayList<HashMap<String, Object>> selectedItems = (ArrayList<HashMap<String, Object>>) session.getAttribute("selectedItems");

    // selectedItems가 null이거나 비어있는 경우 처리
    /*if (selectedItems == null || selectedItems.isEmpty()) {
        out.print("<p>선택된 상품이 없습니다. 장바구니로 돌아가세요.</p>");
        return;
    }*/
    
    ArrayList<HashMap<String, Object>> orders = (ArrayList<HashMap<String, Object>>) request.getAttribute("orders");
    MemberVO myInfo = (MemberVO) request.getAttribute("myInfo");
    
    int purchasePrice = 0;
    
    String isCart = (String) request.getAttribute("isCart");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제 페이지</title>
    
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="<%=contextPath%>/css/member/payment.css">
    
    <!-- <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
        }

        .container {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        .content {
            display: flex;
            justify-content: space-between;
            gap: 20px;
        }

        .left, .right {
            flex: 1;
        }

        .left table {
            width: 70%;
            border-collapse: collapse;
        }

        .left table, .left th, .left td {
            border: 1px solid #BF917E;
        }

        .left th, .left td {
            padding: 10px;
            text-align: center;
        }

        .left th {
            background-color: #BF917E;
        }

        .right {
            border-left: 2px solid #BF917E;
            padding-left: 20px;
        }

        .form-container {
            margin-top: 20px;
        }

        .form-container input {
            width: 70%;
            padding: 10px;
            margin: 5px 0;
            border: 1px solid #BF917E;
            border-radius: 5px;
        }

        .form-container button {
            width: 70%;
            padding: 10px;
            background-color: #BF917E;
            color: white;
            font-size: 16px;
            cursor: pointer;
            border: none;
            border-radius: 5px;
        }

        .form-container button:hover {
            background-color: #BF917E;
        }

        .divider {
            border-bottom: 2px solid #BF917E;
            margin: 30px 0;
        }

        .btn-container {
            text-align: center;
        }

        .btn {
            background-color: #BF917E;
            color: white;
            padding: 15px 30px;
            border: none;
            cursor: pointer;
            font-size: 16px;
            border-radius: 5px;
        }

        .btn:hover {
            background-color: #BF917E;
        }
    </style> -->
</head>

<body>
	<div class="payment-container">
		<div class="left-area">
			<h1>결제 내용</h1>
			<table width="100%">
				<%
				if (orders == null || orders.size() <= 0) {
					%>
					<tr>
						<td>
							선택한 물품이 없습니다.
						</td>
					</tr>
					<%
				}
				else {
					for (int i = 0; i < orders.size(); i++) {
						MealkitVO mealkitVO = (MealkitVO) orders.get(i).get("mealkitVO");
						MemberVO memberVO = (MemberVO) orders.get(i).get("memberVO");
						String quantity = (String) orders.get(i).get("quantity");
						String thumbnail = StringParser.splitString(mealkitVO.getPictures()).get(0);
						
						int totalPrice = Integer.parseInt(quantity) * Integer.parseInt(mealkitVO.getPrice());
						purchasePrice += totalPrice;
						
						int category = mealkitVO.getCategory();
						String categoryStr = (category == 1) ? "[한식]" : 
								(category == 2) ? "[일식]" : 
								(category == 3) ? "[중식]" : "[양식]";
						%>
						<tr>
							<td><div class="purchase-cell">
								<table width="100%">
									<tr>
										<td rowspan="4" width="200px">
											<div class="thumbnail-area">
												<img src="<%= contextPath %>/images/mealkit/thumbnails/<%= mealkitVO.getNo() %>/<%= thumbnail %>">
											</div>
										</td>
										<td>
											<div class="title-area">
												<%= categoryStr %>&nbsp;<%= mealkitVO.getTitle() %>
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div class="nickname-area">
												<%= memberVO.getNickname() %>
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div class="price-area">
												개당&nbsp;
												<fmt:formatNumber value="<%= mealkitVO.getPrice() %>" 
													type="number" 
													groupingUsed="true" 
													maxFractionDigits="0" />
												원
											</div>
											<div class="quantity-area">
												주문 수량 : <%= quantity %>
											</div>
										</td>
									</tr>
									<tr>
										<td>
											<div class="total-price">
												총
												<span>
												    <fmt:formatNumber value="<%= totalPrice %>" 
														type="currency" 
														currencySymbol="₩" 
														groupingUsed="true" 
														maxFractionDigits="0" />
												</span> 원
											</div>
										</td>
									</tr>
								</table>
							</div></td>
						</tr>
						<%	
					}
				}
				%>
			</table>
		</div>
		<div class="right-area">
			<h1>구매자 정보</h1>
			<h3>이름</h3>
			<input type="text" value="<%= myInfo.getName() %>" placeholder="이름" required>
			<h3>연락처</h3>
			<input type="text" value="<%= myInfo.getPhone() %>" placeholder="연락처" required>
			<br>
			<h3>배송지</h3>
			<input type="text" id="sample4_postcode" name="zipcode" value="<%= myInfo.getZipcode() %>"
				placeholder="우편번호" class="form-control" required>
			<br>
			
			<input type="text" id="sample4_roadAddress" name="address1" value="<%= myInfo.getAddress1() %>"
				placeholder="도로명 주소" class="form-control" required>
			<br>
				
			<button type="button" onclick="sample4_execDaumPostcode()" class="form-control">우편번호 찾기</button><br>
			
			<input type="text" id="sample4_detailAddress" name="address2" value="<%= myInfo.getAddress2() %>"
				placeholder="상세 주소" class="form-control" required>
			<br>
			
			<div class="purchase-area">
				<div class="purchase-price">
					<h2>결제 금액</h2>
					<span>
					    <fmt:formatNumber value="<%= purchasePrice %>" 
							type="currency" 
							currencySymbol="₩" 
							groupingUsed="true" 
							maxFractionDigits="0" />
					</span>
				</div>
				<div class="purchase-button-area">
					<input type="button" value="구매" onclick="onPurchase(event)">
					<input type="button" value="취소" onclick="onCancle(event)">
				</div>
			</div>
		</div>
	</div>	
<%-- 
<div class="container">
    <h2>결제 페이지</h2>

    <div class="content">
        <!-- 왼쪽: 상품 목록 -->
        <div class="left">
            <table>
                <thead>
                    <tr>
                        <th>상품명</th>
                        <th>판매자</th>
                        <th>수량</th>
                        <th>가격</th>
                        <th>총액</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${selectedItems}">
                        <tr>
                            <td><a href="<%= request.getContextPath() %>/Mealkit/info?no=${item['mealkitVO'].no}">
                                <img src="<%= request.getContextPath() %>/images/mealkit/thumbnails/${item['mealkitVO'].no}/${item['mealkitVO'].id}/${item['mealkitVO'].pictures.substring(4)}"
                                     alt="${item['mealkitVO'].title}" width="50" />
                                </a><br>${item['mealkitVO'].title}</td>
                            <td>${item['nickname']}</td>
                            <td>${item['quantity']}</td>
                            <td>${item['mealkitVO'].price}</td>
                            <td class="itemTotal">${item['mealkitVO'].price * item['quantity']}</td>
                        </tr>

                        <!-- 각 항목을 개별 hidden 필드로 전달 -->
                        <input type="hidden" name="mealkitNo" value="${item['mealkitVO'].no}">
                        <input type="hidden" name="quantity" value="${item['quantity']}">
                        <input type="hidden" name="price" value="${item['mealkitVO'].price}">
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- 오른쪽: 배송지 입력 폼 -->
        <div class="right">
            <div class="form-container">
                <h3>배송지 입력</h3>
                <label for="sample4_postcode"></label>
                <input type="text" id="sample4_postcode" name="address1" placeholder="우편번호" class="form-control" required><br>

                <label for="sample4_roadAddress"></label>
                <input type="text" id="sample4_roadAddress" name="address2" placeholder="도로명 주소" class="form-control" required><br>
					
				<button type="button" onclick="sample4_execDaumPostcode()" class="form-control">우편번호 찾기</button><br>
				
                <label for="sample4_detailAddress"></label>
                <input type="text" id="sample4_detailAddress" name="address3" placeholder="상세 주소" class="form-control" required><br>

                
            </div>	
        </div>
    </div>

    <div class="divider"></div>

    <!-- 결제 버튼 -->
    <div class="btn-container">
    <!-- 수정된 form -->
    <form action="<%= request.getContextPath() %>/Member/updateOrderList.me" method="post">
        <!-- hidden 필드로 데이터 전달 -->
        <c:forEach var="item" items="${selectedItems}">
            <input type="hidden" name="mealkitNo" value="${item['mealkitVO'].no}">
            <input type="hidden" name="quantity" value="${item['quantity']}">
        </c:forEach>


		<!-- hidden 필드로 userId 전달 -->
		<input type="hidden" name="userId" value="<%= (String) session.getAttribute("userId") %>">



        <!-- 주소 데이터 전달 -->
        <input type="hidden" name="address1" id="hiddenPostcode">
        <input type="hidden" name="address2" id="hiddenRoadAddress">
        <input type="hidden" name="address3" id="hiddenDetailAddress">

        <!-- 결제하기 버튼 -->
        <input type="submit" value="결제하기" class="btn">
    </form>
</div> 
</div>--%>

	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script>
		function onCancle(e) {
			e.preventDefault();
			
			if (confirm('결제를 취소하시겠습니까?')) {			
				history.go(-1);				
			}
		}
	
		function onPurchase(e) {
			e.preventDefault();
			
			if (confirm("구매 하시겠습니까?")) {
				// 고유한 결제 번호 생성
				var today = new Date();
				var hours = today.getHours();
				var minutes = today.getMinutes();
				var seconds = today.getSeconds();
				var milliseconds = today.getMilliseconds();
				var makeMerchantUid = '' + hours + '' + minutes + '' + seconds + '' + milliseconds;  // 결제 고유 번호
				
				IMP.init("imp78768038");
				
				IMP.request_pay({
					pg: 'kakaopay.TC0ONETIME',  // PG사 코드
		            pay_method: 'card',          // 결제 방식
		            merchant_uid: "IMP" + makeMerchantUid, // 결제 고유 번호
		            name: "총 주문", // 결제 명칭
	                amount: <%= purchasePrice %>,
				}, async function(rsp) {
					if (rsp.success) {
						console.log(rsp); // 결제 성공 시 응답 로그   
		                
                        let initNos = [<c:forEach items="${orders}" var="item" varStatus="status">'${item.mealkitVO.no}'${!status.last ? ',' : ''}</c:forEach>];
                    	let initQuantities = [<c:forEach items="${orders}" var="item" varStatus="status">'${item.quantity}'${!status.last ? ',' : ''}</c:forEach>];
                    	let address = $("#sample4_postcode").val() + $("#sample4_roadAddress").val() + $("#sample4_detailAddress").val();
		                
                    	$.ajax({
			        		url: '<%=contextPath%>/Mealkit/buyMealkit.pro',
			                type: "POST",
			                async: true,
			                data: {
			                	'mealkitNos[]': initNos,
			                    'quantities[]': initQuantities,
			                    address: address,
			                    isCart: '<%= isCart %>'
			                },
			                dataType: "text",
			        		success: function(response) {
			        	        // 서버 응답 처리
			        	        if (response > 0) {
									console.log('결제가 성공적으로 완료되었습니다.');
									alert('결제가 성공적으로 완료되었습니다.');
									location.href = '<%= contextPath %>/Main/home';
			        	        }
			        	        else {
			        	            alert('결제는 성공했지만 DB 저장 중 오류가 발생했습니다.');
			        	        }
			        	    },
			        	    error: function(xhr, status, error) {
			        	        console.error("AJAX 요청 실패: " + status + ", " + error);
			        	        alert('결제 처리 중 오류가 발생했습니다.');
			        	    }
			        	});
					}
				});
			}
		}
	
	    // 우편번호 찾기 API 호출 후 hidden 필드에 값 설정
	    function sample4_execDaumPostcode() {
	    	new daum.Postcode({
	            oncomplete: function(data) {
	                // 도로명 주소 변수
	                var roadAddr = data.roadAddress; // 도로명 주소
	                var extraRoadAddr = ''; // 참고 항목 (예: 건물명, 아파트 동 등)

	                // 우편번호와 주소 정보를 해당 필드에 넣는다.
	                document.getElementById('sample4_postcode').value = data.zonecode;  // 우편번호
	                document.getElementById("sample4_roadAddress").value = roadAddr;    // 도로명 주소
	            }
	        }).open();
	    }
	</script>
</body>

</html>
