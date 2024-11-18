<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	
	String contextPath = request.getContextPath();
    // ID가 일치할 경우 수정 기능
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
		                <img src="<%= contextPath %>/images/mealkit/thumbnails/${mealkit.no}/${picture}" title="${picture}" />
		            </li>
		        </c:forEach>
		    </ul>
			<div class="orders_text">
				<h3>조리 순서</h3>
				<!-- 나중에 갈아엎어야함 StringParser.java 이용해서 값 불러와야댐  -->
				<p id="orders">${mealkit.orders }</p> <!-- id="orders" 추가 -->
				<script>
					var orders = document.getElementById("orders").innerText;
					var formattedOrders = orders.replace(/,/g, '<br>'); // ','를 <br>로 교체
					document.getElementById("orders").innerHTML = formattedOrders;
				</script>
			</div>
					
			<div class="origin_text">
				<h3>원산지</h3>
				<input type="text" name="origin" id="origin" value="${mealkit.origin }" disabled>
			</div>	
		</div>
		
		<div class="info_text">
			<span>
				<input type="text" name="title" id="title" value="${mealkit.title}" disabled>
				<hr>
				<strong>글쓴이: ${mealkit.id }</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<strong>게시일: ${mealkit.postDate }</strong><br>
				<!-- 나중에 평점 수정 -->
				<strong>평점: </strong><hr>
			</span>
			<input type="text" name="price" id="price" value="${mealkit.price }" disabled><hr><br>
			
			<!-- 수량 정하는 박스 -->
			<div class="stock_count">
				<input type="text" name="stock" id="stock" value="1" readonly>
				<div class="stock_controls">
					<button class="stock_plus" type="button">&#9650;</button>
					<button class="stock_minus" type="button">&#9660;</button>
				</div>
			</div>
			<br>
			<div class="button_row">
				<button class="buy_button" type="button">구매</button>
				<button class="cart_button" type="button">장바구니</button>
				<button class="wishlist_button" type="button">찜하기</button>
			</div>
			
			<!-- 간단 소개글  -->
			<div class="contents_text">
				<textarea style="border: 1px width: 100%; height: 150px; " readonly>
			        ${mealkit.contents}
			    </textarea>
			</div>
			
			<!-- 수정 삭제 수정후 저장 버튼 -->
            <div class="edit_delete_buttons">
            	<c:if test="${'user1' == mealkit.id}">
                	<button class="edit_button" type="button" onclick="editMealkit()">수정</button>
                	<button class="delete_button" type="button" onclick="deleteMealkit(${mealkit.no})">삭제</button>
                </c:if>
                <button class="save_button" type="button" onclick="saveChanges()" style="display:none;">저장</button>
            </div>
	    </div>
	</div>
	
	<script type="text/javascript">
		$(document).ready(function() {
			// 사진 첨부 관련 
			let pictureCount = 1;
            const maxPictures = 5;

            $('#addImage').click(function() {
                if (pictureCount < maxPictures) {
                    const newInput = `
                        <div class="image-row">
                            <input type="file" name="pictures[]" accept="image/*" class="additionalInput">
                            <button type="button" class="removeImage">삭제</button>
                        </div>
                    `;
                    $('#imageContainer').append(newInput);
                    pictureCount++;
                } else {
                    alert("최대 5장의 사진만 추가할 수 있습니다.");
                }
            });

            // 추가된 사진 삭제 기능
            $(document).on('click', '.removeImage', function() {
                $(this).closest('.image-row').remove();
                pictureCount--;
            });
			
            // bxslider 
		    $('.bxslider').bxSlider({
		        mode: 'fade',
		        captions: true,
		        slideWidth: 400,
		        adaptiveHeight: true
		    });
		
		    // 수량 증가 감소 버튼
		    let $stockInput = $('input[name="stock"]');
		    let maxStock = ${mealkit.stock};
		    let minStock = 1;
		
		    $('.stock_plus').click(function() {
		        let currentValue = parseInt($stockInput.val());
		        if (currentValue < maxStock) {
		            $stockInput.val(currentValue + 1);
		        }
		    });
		
		    $('.stock_minus').click(function() {
		        let currentValue = parseInt($stockInput.val());
		        if (currentValue > minStock) {
		            $stockInput.val(currentValue - 1);
		        }
		    });
		
		    // 구매, 장바구니, 찜목록 버튼 
		    let mealkitNo = ${mealkit.no};
		
		    $(".buy_button").click(function() {
		        // 구매하기 
		    });
		
		    $(".cart_button").click(function() {
		        // 장바구니 type = 1
		        $.ajax({
		            url: "<%= contextPath %>/Mealkit/mypage.pro",
		            type: "POST",
		            async: true,
		            data: {
		                no: mealkitNo,
		                type: 1
		            },
		            success: function(response) {
		                if(response === "1") alert("장바구니에 추가되었습니다.");
		                else alert("장바구니에 추가를 못 했습니다.");
		            }
		        });
		    });
		
		    $(".wishlist_button").click(function() {
		        // 찜하기 type = 0
		        $.ajax({
		            url: "<%= contextPath %>/Mealkit/mypage.pro",
		            type: "POST",
		            async: true,
		            data: {
		                no: mealkitNo,
		                type: 0
		            },
		            success: function(response) {
		                if(response === "1") alert("찜목록에 추가되었습니다.");
		                else alert("찜목록에 추가를 못 했습니다.");
		            }
		        });
		    });
		});
		
		// 삭제 함수
		function deleteMealkit(no) {
		    if (confirm('정말로 삭제하시겠습니까?')) {
		        $.ajax({
		            url: "<%= contextPath %>/Mealkit/delete.pro",
		            type: "POST",
		            async: true,
		            data: { no: no },
		            success: function(response) {
		                if (response === "1") {
		                    alert("삭제되었습니다.");
		                    location.href = "<%= contextPath %>/Mealkit/list";
		                } else {
		                    alert("삭제에 실패했습니다.");
		                }
		            }
		        });
		    }
		}
		// 수정 함수 
		function editMealkit() {
			
		}
	</script>
</body>
</html>