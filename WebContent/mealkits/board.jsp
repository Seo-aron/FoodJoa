<%@page import="java.util.List"%>
<%@page import="Common.StringParser"%>
<%@page import="VOs.MealkitVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html;charset=utf-8");
	
	String contextPath = request.getContextPath();
	
	MealkitVO mealkitvo = (MealkitVO) request.getAttribute("mealkitvo");
	
	List<String> parsedOrders = StringParser.splitString(mealkitvo.getOrders());
	
	String bytePictures = request.getParameter("bytePictures");
    System.out.println("board.jsp bytePictures: " + bytePictures);
%>
<c:set var="mealkit" value="${requestScope.mealkitvo}"/>

<!DOCTYPE html>
<html>
<head>
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
  	<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
  	<link rel="stylesheet" href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css">
  	<link rel="stylesheet" href="<%=contextPath%>/css/mealkit/board.css">
  	
	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<body>
	<div id="container">
		<!-- editBoard.jsp로 넘길 데이터 -->
		<input type="hidden" id="mealkitNo" value="${mealkit.no}">
		<input type="hidden" id="bytePictures" value="<%=bytePictures%>">
		<div class="info_image">
			<div class="image_upload" style="display: none;">
			    <h3>이미지 업로드</h3>
			     	<input type="file" name="pictures[]" accept="image/*" required id="thumbnail"><br>
				    <div id="imageContainer"></div>
				    <button type="button" id="addImage">추가 사진</button>
			</div>
		
		    <ul class="bxslider">
		        <c:forEach var="picture" items="${fn:split(mealkit.pictures, ',')}">
		            <li>
		                <img src="<%= contextPath %>/images/mealkit/thumbnails/${mealkit.no}/${mealkit.id }/${picture}" title="${picture}" />
		            </li>
		        </c:forEach>
		    </ul>

			<div class="orders_text">
				<p>조리 순서</p>
				<%
					for (int i = 0; i < parsedOrders.size(); i++) {
					String orders = parsedOrders.get(i);
				%>
					<p>
						<span><%=orders%></span>
					</p>
					<%
				}
				%>
			</div>
					
			<div class="origin_text">
				<h3>원산지</h3>
				<p>${mealkit.origin }</p>
			</div>	
		</div>
		
		<div class="info_text">
			<span>
				<h1>${mealkit.title }</h1>
				<hr>
				<strong>글쓴이: ${mealkit.id }</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>게시일: ${mealkit.postDate }</strong><br>
				<!-- 나중에 평점 수정 -->
				<strong>평점: <fmt:formatNumber value="${ratingAvr}" pattern="#.#" /></strong><hr>
			</span>
			<h2>가격: ${mealkit.price }</h2><hr><br>
			
			<!-- 수량 정하는 박스 -->
			<div class="stock_count">
				<input type="text" name="stock" id="stock" value="1" readonly>
				<input type="hidden" id="mealkitStock" value="${mealkit.stock}">
				<div class="stock_controls">
					<button class="stock_plus" type="button">&#9650;</button>
					<button class="stock_minus" type="button">&#9660;</button>
				</div>
			</div>
			<br>
			<div class="button_row">
				<button class="buy_button" type="button" onclick="buyMealkit('<%=contextPath%>')">구매</button>
				<button class="cart_button" type="button" onclick="cartMealkit('<%=contextPath%>')">장바구니</button>
				<button class="wishlist_button" type="button" onclick="wishMealkit('<%=contextPath%>')">찜하기</button>
			</div>
			
			<!-- 간단 소개글  -->
			<div class="contents_text">
				<textarea style="border: 1px width: 100%; height: 150px; " readonly >
			        ${mealkit.contents}
			    </textarea>
			</div>
			
			<!-- 수정 삭제 버튼 -->
            <div class="edit_delete_buttons">
            	<c:if test="${'user1' == mealkit.id}">
                	<button class="edit_button" type="button" onclick="editMealkit('<%=contextPath%>')">수정</button>
                	<button class="delete_button" type="button"
                	 onclick="deleteMealkit(${mealkit.no}, '<%=contextPath%>')">삭제</button>
                </c:if>
            </div>
	    </div>
	</div>
	
	<script src="<%= contextPath %>/js/mealkit/board.js"></script>
</body>
</html>