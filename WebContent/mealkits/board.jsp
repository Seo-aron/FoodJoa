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
	response.setContentType("text/html; charset=utf-8");
	
	String contextPath = request.getContextPath();
	
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
				<strong>평점: ${ratingAvr }</strong><hr>
			</span>
			<h2>가격: ${mealkit.price }</h2><hr><br>
			
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
				<textarea style="border: 1px width: 100%; height: 150px; " readonly >
			        ${mealkit.contents}
			    </textarea>
			</div>
			
			<!-- 수정 삭제 버튼 -->
            <div class="edit_delete_buttons">
            	<c:if test="${'user1' == mealkit.id}">
                	<button class="edit_button" type="button" onclick="editMealkit()">수정</button>
                	<button class="delete_button" type="button"
                	 onclick="deleteMealkit(${mealkit.no})">삭제</button>
                </c:if>
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
			location.href = "<%=contextPath%>/Mealkit/update?no=${mealkit.no}";
		}
		
		// 저장 함수
		function save() {
		    const no = ${mealkit.no};
		    const title = $('#title').val();
		    const price = $('#price').val();
		    const origin = $('#origin').val();
		    const contents = $('textarea').val();
		    const orders = $('#orders').text().replace(/<br>/g, ',');
		    const stock = $('#stock').val();

		    const formData = new FormData();
		    formData.append('no', no);
		    formData.append('title', title);
		    formData.append('price', price);
		    formData.append('origin', origin);
		    formData.append('contents', contents);
		    formData.append('orders', orders);
		    formData.append('stock', stock);

		    const imageInputs = document.querySelectorAll('input[name="pictures[]"]');
		    imageInputs.forEach(input => {
		        if (input.files.length > 0) {
		            formData.append('pictures[]', input.files[0]);
		        }
		    });

		    $.ajax({
		        url: "<%=contextPath%>/Mealkit/update.pro",
		        type: "POST",
		        data: formData,
		        contentType: false, // multipart/form-data로 전송
		        processData: false, // 데이터를 자동으로 변환하지 않도록 설정
		        success: function(response) {
		            if (response === "1") {
		                alert("정보가 수정되었습니다.");
		                location.reload();
		            } else {
		                alert("수정에 실패했습니다.");
		            }
		        },
		        error: function() {
		            alert("서버 요청 중 에러가 발생했습니다.");
		        }
		    });
		}

		
	</script>
</body>
</html>