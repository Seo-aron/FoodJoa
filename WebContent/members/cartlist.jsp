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
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        table, th, td {
            border: 1px solid black;
        }
        th, td {
            padding: 8px;
            text-align: center;
     
        }
        
        .container {
        width: 1200px;
        margin: 0 auto; /* 가운데 정렬 */
    }
    </style>
</head>
<body>

	<div id="container">
    <h2>장바구니</h2>
    
    <c:if test="${not empty cart}">
        <table>
            <thead>
                <tr>
                    <th>상품명</th>
                    <th>가격</th>
                    <th>수량</th>
                    <th>총액</th>
                    <th>삭제</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${cart}">
                    <tr>
                        <td>${item.productName}</td>
                        <td>${item.price}</td>
                        <td>
                            <form action="updateCart" method="post">
                                <input type="number" name="quantity" value="${item.quantity}" min="1">
                                <input type="hidden" name="productId" value="${item.productId}">
                                <input type="submit" value="수정">
                            </form>
                        </td>
                        <td>${item.price * item.quantity}</td>
                        <td>
                            <form action="removeFromCart" method="post">
                                <input type="hidden" name="productId" value="${item.productId}">
                                <input type="submit" value="삭제">
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <h3>총액: ${totalPrice}</h3>
        <form action="checkout" method="get">
            <input type="submit" value="결제하기">
        </form>
    </c:if>

    <c:if test="${empty cart}">
        <p>장바구니에 상품이 없습니다.</p>
    </c:if>
</div>
</body>
</html>
