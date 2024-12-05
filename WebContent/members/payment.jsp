<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=utf-8");

    // selectedItems를 세션에서 가져오기
    ArrayList<HashMap<String, Object>> selectedItems = (ArrayList<HashMap<String, Object>>) session.getAttribute("selectedItems");

    // selectedItems가 null이거나 비어있는 경우 처리
    if (selectedItems == null || selectedItems.isEmpty()) {
        out.print("<p>선택된 상품이 없습니다. 장바구니로 돌아가세요.</p>");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>결제 페이지</title>
    <style>
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
    </style>
</head>
<body>

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
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    // 우편번호 찾기 API 호출 후 hidden 필드에 값 설정
    function sample4_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                var roadAddr = data.roadAddress; // 도로명 주소

                // 우편번호와 주소 정보를 hidden 필드에 넣기
                document.getElementById('hiddenPostcode').value = data.zonecode;  // 우편번호
                document.getElementById("hiddenRoadAddress").value = roadAddr;    // 도로명 주소
                document.getElementById("hiddenDetailAddress").value = 
                    document.getElementById("sample4_detailAddress").value; // 상세 주소
            }
        }).open();
    }
</script>

</body>
</html>
