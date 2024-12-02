<%@ page import="java.util.HashMap" %>
<%@ page import="VOs.MealkitVO" %>
<%@ page import="VOs.MealkitCartVO" %>
<%@ page import="java.util.ArrayList" %>
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
                    <th><input type="checkbox" id="selectAll" onclick="toggleSelectAll()"> 전체 선택</th> <!-- 전체 선택 체크박스 -->
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
                        <td><input type="checkbox" class="itemCheckbox" value="${item.mealkitVO.no}" onclick="calculateTotal()"></td> <!-- 상품별 체크박스 -->
                        <td><a href="${pageContext.request.contextPath}/Mealkit/info?no=${item.mealkitVO.no}">
                     <img src="${pageContext.request.contextPath}/images/mealkit/thumbnails/${item.mealkitVO.no}/${item.mealkitVO.id}/${item.mealkitVO.pictures.substring(4)}" 
                             alt="${item.mealkitVO.title}">
                             </a><br>${item.mealkitVO.title}</td> <!-- 상품명 -->
                        <td>${item.nickname}</td>
                        <td data-price="${item.mealkitVO.price}">${item.mealkitVO.price}</td> <!-- 가격을 data-price에 저장 -->
                        <td>
                            <form class="form-inline" action="updateCart" method="post">
                                <input type="number" name="quantity" value="${item.quantity}" min="1" onchange="calculateTotal()">
                                <input type="hidden" name="mealkitNo" value="${item.mealkitVO.no}">
                                <input type="submit" value="수정" class="btn">
                            </form>
                        </td>
                        <td class="itemTotal">${item.mealkitVO.price * item.quantity}</td> <!-- 총액 -->
                        <td>
                            <form action="removeFromCart" method="post">
                                <input type="hidden" name="mealkitNo" value="${item.mealkitVO.no}">
                                <input type="submit" value="삭제" class="btn" style="background-color: #BF917E;">
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <h3>총액: <span id="totalAmount">${totalPrice}</span></h3> <!-- 총액 -->
        <form id="checkoutForm" action="checkout" method="post">
            <!-- 체크된 상품들만 전송될 수 있도록 hidden 필드에 저장 -->
            <input type="hidden" id="selectedItems" name="selectedItems">
            <input type="submit" value="결제하기" class="btn">
        </form>
    </c:if>

    <c:if test="${empty cart}">
        <p>장바구니에 상품이 없습니다.</p>
    </c:if>
</div>

<script>
    // 전체 선택 체크박스를 클릭하면 모든 체크박스를 선택/해제하는 함수
    function toggleSelectAll() {
        var checkboxes = document.querySelectorAll('.itemCheckbox');
        var selectAllCheckbox = document.getElementById('selectAll');
        for (var checkbox of checkboxes) {
            checkbox.checked = selectAllCheckbox.checked;
        }
        calculateTotal();  // 선택된 항목의 총액 계산
    }

    // 총액을 계산하는 함수
    function calculateTotal() {
        var checkboxes = document.querySelectorAll('.itemCheckbox:checked');
        var totalAmount = 0;
        for (var checkbox of checkboxes) {
            var row = checkbox.closest('tr');
            var price = parseInt(row.cells[3].getAttribute('data-price'));  // data-price 속성에서 가격을 가져옴
            var quantity = parseInt(row.cells[4].querySelector('input').value);  // 수량
            totalAmount += price * quantity;
        }
        document.getElementById('totalAmount').innerText = totalAmount;
        
        // 결제 폼에 선택된 상품들의 정보를 넣기
        var selectedItems = [];
        for (var checkbox of checkboxes) {
            var itemNo = checkbox.value;
            var quantity = checkbox.closest('tr').querySelector('input[name="quantity"]').value;
            selectedItems.push({mealkitNo: itemNo, quantity: quantity});
        }

        document.getElementById('selectedItems').value = JSON.stringify(selectedItems);
    }

    // 페이지 로드 시 총액 계산
    window.onload = function() {
        calculateTotal();
    };
</script>

</body>
</html>
