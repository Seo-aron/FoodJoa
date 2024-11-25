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
    
    // String updatePictures = (String) request.getAttribute("updatePictures");	// 파일명 (이미지 로드용)
    // String bytePictures = (String) request.getAttribute("bytePictures");		// 0000파일명
%>
<c:set var="mealkit" value="${requestScope.mealkitvo}"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>밀키트 판매 게시글 수정</title>
    <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/mealkit/write.css">
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
    <div id="container">
        <h2>밀키트 게시글 수정</h2>
        <form action="<%=contextPath%>/Mealkit/update.pro" method="post" id="frmWrite" enctype="multipart/form-data">
            <table border="1">
	            <tr>
				    <th>ID</th>
				    <td>
				    	<!-- 로그인정보를 세션에 저장해야 쓸 수 있음 -->
				    	<!--<input type="text" name="id" value="${sessionScope.userId}" readonly>-->
				    	<input type="text" name="id" value="admin" readonly>
				    	<input type="hidden" name="no" value="${mealkit.no }">
				    </td>
				</tr>
                <tr>
                    <th>글 제목</th>
                    <td><input type="text" name="title" value="${mealkit.title }" required></td>
                </tr>
                <tr>
				    <th>사진 추가</th>
				    <td>
				        <div id="imagePreview"></div>
   						<input type="file" id="pictureFiles" name="pictureFiles" 
							accept=".jpg,.jpeg,.png" multiple onchange="handleFileSelect(this.files)">
						<button type="button" id="addFileBtn" onclick="triggerFileInput()">사진 추가</button>
						<input type="hidden" id="pictures" name="pictures" value="">
					</td>
				</tr>
                <tr>
                    <th>카테고리</th>
					<td>
					    <select name="category" required>
					        <option value="" <c:if test="${empty mealkit.category}">selected</c:if>>선택하세요</option>
					        <option value="0" <c:if test="${mealkit.category == 0}">selected</c:if>>한식</option>
					        <option value="1" <c:if test="${mealkit.category == 1}">selected</c:if>>중식</option>
					        <option value="2" <c:if test="${mealkit.category == 2}">selected</c:if>>일식</option>
					        <option value="3" <c:if test="${mealkit.category == 3}">selected</c:if>>양식</option>
					        <option value="4" <c:if test="${mealkit.category == 4}">selected</c:if>>분식</option>
					    </select>
					</td>
                </tr>
                <tr>
                    <th>간단 소개글</th>
                    <td><textarea name="contents" rows="4" required>${mealkit.contents }</textarea></td>
                </tr>
                <tr>
					<th>가격</th>
				    <td><input type="text" name="price" value="${mealkit.price }" quired min="0">원</td>
				</tr>
                <tr>
                    <th>재고 수량</th>
                    <td><input type="number" name="stock" value="${mealkit.stock }" required min="0">개</td>
                </tr>
                <tr>
					<td colspan="2">
						<p>간단 조리 순서 작성</p>
						<div class="orders-container"></div>
						<p><input type="button" class="add-orders" value="순서 추가하기"></p>
						<input type="hidden" id="orders" name="orders">
					</td>
				</tr>
                <tr>
                    <th>원산지 표기</th>
                    <td><input type="text" name="origin" value="${mealkit.origin }" required></td>
                </tr>
                <tr>
                <td colspan="2">
					<input type="button" class="write" value="수정 완료" onclick="onSubmit(event)">
				</td>
			</tr>
            </table>
        </form>
    </div>
    <% 
    	List<String> orders = StringParser.splitString(mealkitvo.getOrders()); 
	    String pictures = mealkitvo.getPictures();
	    String[] pictureArray = pictures.split(",");
    %>
   <script type="text/javascript">
   	let selectedFiles = [];
   	let selectedRealFiles = [];

    $(function() {
    	$(".write").click(function(event) {
    		event.preventDefault();
    	});
    	
    	$(".add-orders").click(function() {
    	    var newOrderHtml = `
    	        <p class="orders-row">
    	            <input type="text" class="name-orders" placeholder="조리 순서를 간단히 적어주세요.">
    	            <button type="button" class="addrow-orders">추가</button>
    	            <button type="button" class="cancle-orders">취소</button>
    	        </p>
    	    `;
    	    
    	    $(this).parent().prev().append(newOrderHtml);
    	});
    	
		// 추가 버튼을 눌렀을 때 
    	$(document).on('click', '.addrow-orders', function() {
    	    var $row = $(this).closest('.orders-row');
    	    var name = $row.find('.name-orders').val();
    	    
    	    if (name) {
    	    	var newOrderHtml = 
    	            '<p class="added-orders">' +
    				'<span class="added-order">' + name + '</span>' + 
    	            '<button type="button" class="remove-orders">삭제</button>' +
    	            '</p>';
    	        
    	        $row.replaceWith(newOrderHtml);    
    	    }
    		else {
    	        alert("조리 순서를 입력 해주세요.");
    	    }
    	});
		// 조리 순서 취소 버튼 
    	$(document).on('click', '.cancle-orders', function() {
    	    $(this).closest('.orders-row').remove();
    	});
		// 조리 순서 삭제 버튼 
    	$(document).on('click', '.remove-orders', function() {
    	    $(this).closest('.added-orders').remove();
    	});
    });

	// 전송버튼 
	function onSubmit(e, contextPath) {
		e.preventDefault();
	
		setOrdersString();
		setPicturesString();
	
		const formData = new FormData();
		formData.append('no', $("input[name='no']").val());
		formData.append('id', $("input[name='id']").val());
		formData.append('title', $("input[name='title']").val());
		formData.append('pictures', $("#pictures").val());
		formData.append('category', $("select[name='category']").val());
		formData.append('contents', $("textarea[name='contents']").val());
		formData.append('price', $("input[name='price']").val());
		formData.append('stock', $("input[name='stock']").val());
		formData.append('origin', $("input[name='origin']").val());
		formData.append('orders', $("#orders").val());
	
		selectedRealFiles.forEach((file, index) => {
			formData.append('file' + index, file);
		});
	
		$.ajax({
			url: "<%=contextPath%>/Mealkit/update.pro",
			type: "POST",
			data: formData,
			processData: false,
			contentType: false,
			success: function(response) {
				if (response > 0) {
					alert("글 작성이 성공적으로 완료되었습니다.");
					location.href = "<%=contextPath%>/Mealkit/info?no=" + response;
				} else {
					alert("글 작성에 실패했습니다. 다시 시도해주세요.");
				}
			},
			error: function() {
				alert("서버 요청 중 에러가 발생했습니다.");
			}
		});
	}
	
	// 받은 조리 순서를 하나의 배열로 만드는 함수 
	function setOrdersString() {

		let orders = $(".added-order");
		let ordersString = [];
				
		orders.each(function(index, element) {
			ordersString.push($(element).text());
		});
			
		let combinedOrderString = combineStrings(ordersString);
		
		document.getElementsByName('orders')[0].value = combinedOrderString;
	}
				
	// 문자열을 합치는 함수
	function combineStrings(strings) {
		
		let result = strings.map(str => {
	        const length = str.length;
	        // 길이를 4자리로 포맷하고 0으로 패딩
	        const lengthStr = String(length).padStart(4, '0');
	        return lengthStr + str; // 길이와 문자열을 합침
	    }).join(''); // 모든 요소를 하나의 문자열로 결합
		
		console.log("result : " + result);
		return result;
	}
	
	initialize();		
	
	function initialize() {
		<%
		for (int i = 0; i < orders.size(); i++) {
			%>
			var newOrderHtml = 
	            '<p class="added-orders">' +
				'<span class="added-order"><%= orders.get(i) %></span>' + 
	            '<button type="button" class="remove-orders">삭제</button>' +
	            '</p>';
	            
            $(".orders-container").append(newOrderHtml);
			<%
		}
		%>
		
		let initialPictures = "<%=mealkitvo.getPictures()%>";
		
		const mealkitNo = $("input[name='no']").val();
	    const mealkitId = $("input[name='id']").val();

	    if (initialPictures) {
	        const picturesArray = initialPictures.split(',');
	        const imagePreview = document.getElementById('imagePreview');

	        picturesArray.forEach(picture => {
	            const img = document.createElement('img');
	            img.src = "<%=contextPath%>" + "/images/mealkit/thumbnails/" + mealkitNo + "/" + mealkitId + "/" + picture; 
	            console.log(img.src);
	            img.dataset.filename = picture;
	            img.classList.add('preview_image');

	            img.addEventListener('click', function () {
	                imagePreview.removeChild(img);
	                removeSelectedFile(picture);
	            });

	            imagePreview.appendChild(img);
	        });

	        document.getElementsByName('pictures')[0].value = combineStrings(picturesArray);
	    }
		
	}
	
	// 사진 관련 
	function triggerFileInput() {
		if (selectedFiles.length >= 5) {
			alert("사진은 최대 5장까지 추가할 수 있습니다.");
			return;
		}
		document.getElementById('pictureFiles').click();
	}
	
	function handleFileSelect(files) {
		const imagePreview = document.getElementById('imagePreview');
	
		Array.from(files).forEach(file => {
			if (file.type.startsWith('image/')) {
				let fileIdentifier = file.name + '-' + file.size;
	
				if (!selectedFiles.includes(fileIdentifier)) {
					if (selectedFiles.length >= 5) {
						alert("사진은 최대 5장까지 추가할 수 있습니다.");
						return;
					}
	
					selectedFiles.push(fileIdentifier);
					selectedRealFiles.push(file);
	
					const reader = new FileReader();
	
					reader.readAsDataURL(file);
	
					reader.onload = function(e) {
						const img = document.createElement('img');
						img.src = e.target.result;
	
						img.dataset.filename = file.name;
						img.classList.add('preview_image');
	
						img.addEventListener('click', function() {
							imagePreview.removeChild(img);
							removeSelectedFile(fileIdentifier);
							document.getElementById('pictureFiles').value = '';
						});
	
						img.style.cursor = 'pointer';
	
						imagePreview.appendChild(img);
					}
				}
			}
		});
	
		document.getElementById('pictureFiles').value = '';
	}
	
	// 선택한 파일 제거
	function removeSelectedFile(fileIdentifier) {
		for (let i = 0; i < selectedFiles.length; i++) {
			if (selectedFiles[i] == fileIdentifier) {
				selectedFiles.splice(i, 1);
				selectedRealFiles.splice(i, 1);
				break;
			}
		}
	}
	
	function removeSelectedFile(fileIdentifier) {
		//selectedFiles = selectedFiles.filter(item => item !== fileIdentifier);
		for (let i = 0; i < selectedFiles.length; i++) {
			if (selectedFiles[i] == fileIdentifier) {
				selectedFiles.splice(i, 1);
				selectedRealFiles.splice(i, 1);
				break;
			}
		}
	}
	
	function setPicturesString() {
		let strings = [];
	
		selectedFiles.forEach(fileIdentifier => {
			// fileIdentifier는 "파일이름-파일크기" 형식
			let fileName = fileIdentifier.split('-')[0]; // 파일 이름 부분만 추출
			strings.push(fileName);
		});
	
		let pictures = combineStrings(strings);
	
		document.getElementsByName('pictures')[0].value = pictures;
	}
    </script>
</body>
</html>
