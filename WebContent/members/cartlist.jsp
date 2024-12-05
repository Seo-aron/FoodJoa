<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=utf-8");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
    <title>장바구니</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
            font-family: "Noto Serif KR", serif;
        }
        table, th, td {
            border: 1px solid black;
            font-family: "Noto Serif KR", serif;
        }
        th, td {
            padding: 12px;
            text-align: center;
            font-family: "Noto Serif KR", serif;
        }

        th {
            background-color: #BF917E;
            font-family: "Noto Serif KR", serif;
        }

        .container {
            width: 1200px;
            margin: 0 auto; /* 가운데 정렬 */
            font-family: "Noto Serif KR", serif;
        }

        .btn {
            background-color: #BF917E;
            color: white;
            padding: 10px 15px;
            border: none;
            cursor: pointer;
            font-family: "Noto Serif KR", serif;
        }

        .btn:hover {
            background-color: #45a049;
        }

        .form-inline input[type="number"] {
            width: 60px;
            font-family: "Noto Serif KR", serif;
        }

        .checkbox {
            width: 20px;
            height: 20px;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>장바구니</h2>
    
    <c:if test="${not empty cart}">
        <table>
            <thead>
                <tr>
                    <th><input type="checkbox" id="selectAll" onclick="toggleSelectAll()"> 전체 선택</th>
                    <th>상품명</th>
                    <th>판매자</th>
                    <th>가격</th>
                    <th>수량</th>
                    <th>총액</th>
                    <th>삭제</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${cart}">
                    <tr>
                        <td><input type="checkbox" class="itemCheckbox" value="${item.mealkitVO.no}" onclick="calculateTotal()"></td>
                        <td><a href="<%= request.getContextPath() %>/Mealkit/info?no=${item.mealkitVO.no}"> 
                            <img src="<%= request.getContextPath() %>/images/mealkit/thumbnails/${item.mealkitVO.no}/${item.mealkitVO.id}/${item.mealkitVO.pictures.substring(4)}" 
                                 alt="${item.mealkitVO.title}"/>
                            </a><br>${item.mealkitVO.title}</td>
                        <td>${item.nickname}</td>
                        <td data-price="${item.mealkitVO.price}">${item.mealkitVO.price}</td>
                        <td>                        
                            <form action="<%= request.getContextPath() %>/Member/updateCartList.me" method="post">
							    <input type="number" name="quantity" value="${item.quantity}" min="1" onchange="calculateTotal()">
							    <input type="hidden" name="mealkitNo" value="${item.mealkitVO.no}">
							    <input type="hidden" name="userId" value="${sessionScope.userId}">
							    <input type="submit" value="수정" class="btn">
							</form>
                        </td>
                        <td class="itemTotal">${item.mealkitVO.price * item.quantity}</td>
                        <td>
                             <form action="<%= request.getContextPath() %>/Member/deleteCartList.me" method="post" onsubmit="return confirm('정말로 삭제하시겠습니까?');">
							    <input type="hidden" name="mealkitNo" value="${item.mealkitVO.no}">
							    <input type="hidden" name="userId" value="${sessionScope.userId}"> 
							    <input type="submit" value="삭제" class="btn" style="background-color: #BF917E;">
							</form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <h3>총 금액: <span id="totalAmount">${totalPrice}</span> | 총 수량: <span id="totalQuantity">0</span></h3>
        
        <!-- 결제 폼 -->
        <form id="checkoutForm" action="<%= request.getContextPath() %>/Member/sendPayMent.me" method="post">
            <!-- 선택된 아이템의 정보를 담을 영역 -->
            <div id="selectedItemsContainer"></div>

            <!-- selectedMealkitNos 추가 -->
            <input type="hidden" name="selectedMealkitNos" id="selectedMealkitNos"/>

            <input type="submit" value="결제하기" class="btn">
        </form>
    </c:if>

    <c:if test="${empty cart}">
        <p>장바구니에 상품이 없습니다.</p>
    </c:if>
</div>

<script>
    function toggleSelectAll() {
        var checkboxes = document.querySelectorAll('.itemCheckbox');
        var selectAllCheckbox = document.getElementById('selectAll');
        for (var checkbox of checkboxes) {
            checkbox.checked = selectAllCheckbox.checked;
        }
        calculateTotal();
    }

    function calculateTotal() {
        var checkboxes = document.querySelectorAll('.itemCheckbox:checked');
        var totalAmount = 0;
        var totalQuantity = 0;

        // 선택된 아이템들을 담을 배열
        var selectedItems = [];
        var selectedMealkitNos = [];  // 선택된 밀키트 번호 배열

        // 선택된 아이템 처리
        for (var checkbox of checkboxes) {
            var row = checkbox.closest('tr');
            var price = parseInt(row.cells[3].getAttribute('data-price'));
            var quantity = parseInt(row.cells[4].querySelector('input').value);
            totalAmount += price * quantity;
            totalQuantity += quantity;

            // 선택된 아이템 정보 추가
            selectedItems.push({
                mealkitNo: checkbox.value,
                quantity: quantity
            });

            // selectedMealkitNos 배열에 추가
            selectedMealkitNos.push(checkbox.value);
        }

        document.getElementById('totalAmount').innerText = totalAmount;
        document.getElementById('totalQuantity').innerText = totalQuantity;

        // 선택된 아이템들을 결제 폼에 추가
        var selectedItemsContainer = document.getElementById('selectedItemsContainer');
        selectedItemsContainer.innerHTML = '';  // 기존 필드를 지우고 새로 추가

        selectedItems.forEach(function(item, index) {
            var mealkitNoField = document.createElement('input');
            mealkitNoField.type = 'hidden';
            mealkitNoField.name = 'mealkitNo_' + index;
            mealkitNoField.value = item.mealkitNo;

            var quantityField = document.createElement('input');
            quantityField.type = 'hidden';
            quantityField.name = 'quantity_' + index;
            quantityField.value = item.quantity;

            selectedItemsContainer.appendChild(mealkitNoField);
            selectedItemsContainer.appendChild(quantityField);
        });

        // selectedMealkitNos 값을 결제 폼에 넣기
        document.getElementById('selectedMealkitNos').value = selectedMealkitNos.join(',');
    }

    window.onload = function() {
        calculateTotal();
    };
</script>

</body>
</html>
