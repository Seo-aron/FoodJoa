<%@ page import="java.util.List"%>
<%@ page import="Common.StringParser"%>
<%@ page import="VOs.MealkitVO"%>
<%@ page import="VOs.MemberVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html;charset=utf-8");
	String contextPath = request.getContextPath();
	
    String id = (String) session.getAttribute("userId");
	String bytePictures = request.getParameter("bytePictures");
	MealkitVO mealkitvo = (MealkitVO) request.getAttribute("mealkitvo");
	
	List<String> parsedOrders = StringParser.splitString(mealkitvo.getOrders());
%>
<c:set var="mealkit" value="${requestScope.mealkitvo}"/>

<!DOCTYPE html>
<html>
<head>
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
  	<script src="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.min.js"></script>
  	<link rel="stylesheet" href="https://cdn.jsdelivr.net/bxslider/4.2.12/jquery.bxslider.css">
  	<link rel="stylesheet" href="<%=contextPath%>/css/mealkit/board.css">
  	
  	<script src="https://cdn.iamport.kr/v1/iamport.js"></script>

	<meta charset="UTF-8">
	<title>Insert title here</title>
</head>
<body>
	<div id="container">
		<!-- editBoard.jsp로 넘길 데이터 -->
		<input type="hidden" id="mealkitNo" value="${mealkit.no}">
		<input type="hidden" id="bytePictures" value="<%=bytePictures%>">
		<div class="info_image">
			<%
			    List<String> pictures = StringParser.splitString(mealkitvo.getPictures());
			%>
			
			<ul class="bxslider">
			    <%
			        for (String picture : pictures) {
			    %>
			        <li>
			            <img src="<%= contextPath %>/images/mealkit/thumbnails/<%= mealkitvo.getNo() %>/<%= mealkitvo.getId() %>/<%= picture %>" title="<%= picture %>" />
			        </li>
			    <%
			        }
			    %>
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
				<button id="payment">구매하기</button>
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
            	<c:if test="${sessionScope.userId == mealkit.id}">
                	<button class="edit_button" type="button" onclick="editMealkit('<%=contextPath%>')">수정</button>
                	<button class="delete_button" type="button"
                	 onclick="deleteMealkit(${mealkit.no}, '<%=contextPath%>')">삭제</button>
                </c:if>
            </div>
	    </div>
	</div>
	
	<script src="<%= contextPath %>/js/mealkit/board.js"></script>
	
	<!-- 결제 api -->
	<script type="text/javascript">
	
	var userId = "<%=id%>";
	console.log("userId:", userId);
	
	// 고유한 결제 번호 생성
	var today = new Date();
	var hours = today.getHours();
	var minutes = today.getMinutes();
	var seconds = today.getSeconds();
	var milliseconds = today.getMilliseconds();
	var makeMerchantUid = '' + hours + '' + minutes + '' + seconds + '' + milliseconds;  // 결제 고유 번호
	
	// 결제 버튼 이벤트 연결
	const buyButton = document.getElementById('payment');
	
    buyButton.addEventListener('click', function () {
    	
        if (!userId || userId == 'null') {
            alert('로그인이 필요합니다!');
            return; // 로그인하지 않은 경우 결제 진행 차단
        }
        
        const title = "<%=mealkitvo.getTitle()%>";
        const price = "<%=mealkitvo.getPrice()%>";
        const quantity = parseInt($('#stock').val());
        const mealkitNo = "<%=mealkitvo.getNo()%>";
        
        // 하나의 주문에 대한 총 금액
        cartItems.forEach(item => {
            item.totalPrice = item.price * item.quantity;
        });

        // 여러개의 주문에 대한 총 금액
        var totalAmount = cartItems.reduce((sum, item) => sum + item.totalPrice, 0);

        kakaoPay(totalAmount, cartItems);
    });

	// 카카오페이 결제 함수
	function kakaoPay(totalAmount, cartItems) {
	    
		    if (confirm("구매 하시겠습니까?")) {
		    	
		        IMP.init("imp78768038");
		        // 결제 요청
		        IMP.request_pay({
		            pg: 'kakaopay.TC0ONETIME',  // PG사 코드
		            pay_method: 'card',          // 결제 방식
		            merchant_uid: "IMP" + makeMerchantUid, // 결제 고유 번호
		            name: "총 주문", // 결제 명칭
	                amount: totalAmount,
		        }, async function(rsp) { // 결제 요청 후 callback 처리
		            if (rsp.success) {  // 결제 성공 시
		                console.log(rsp); // 결제 성공 시 응답 로그            
                        alert('결제 완료!');
                    	// ajax로 데이터 넘기고 mealkit_order 테이블로 데이터 이동 후, 주문 조회 페이지로 이동
                    	cartItems.forEach(item => {
	                        $.ajax({
	                            url: "<%=contextPath%>/Mealkit/buyMealkit.pro",
	                            type: "POST",
	                            async: true,
	                            data: {
	                                id: "<%=id%>",
	                                mealkitNo: item.mealkitNo,
	                                quantity: item.quantity,
	                                delivered: 0,
	                                refund: 0
	                            },
	                    		success: function(response) {
	                    	        // 서버 응답 처리
	                    	        if (response) {
										console.log('결제가 성공적으로 완료되었습니다.');
										alert('결제가 성공적으로 완료되었습니다.');
										// 멤버 배송정보 뭐 이런 페이지로 이동 location.href =
	                    	        } else {
	                    	            alert('결제는 성공했지만 DB 저장 중 오류가 발생했습니다.');
	                    	        }
	                    	    }
	                    	});
                    	});
		            } else {  // 결제 실패 시
		                alert(rsp.error_msg);
		            }
		        });
		    } else {  // 구매 확인 취소 시
		        return false;
		    }
		});
	}

	</script>
</body>
</html>