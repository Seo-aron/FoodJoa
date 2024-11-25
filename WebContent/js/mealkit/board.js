 let mealkitNo = parseInt($('#mealkitNo').val());
 let bytePictures = $('#bytePictures').val();

// bxslider 
$('.bxslider').bxSlider({
	mode: 'fade',
	captions: true,
	slideWidth: 400,
	adaptiveHeight: true
});

// 수량 증가 감소 버튼
let stockInput = $('input[name="stock"]');
let maxStock = parseInt($('#mealkitStock').val());
let minStock = 1;

$('.stock_plus').click(function() {
	let currentValue = parseInt(stockInput.val());
	if (currentValue < maxStock) {
		stockInput.val(currentValue + 1);
	}
});

$('.stock_minus').click(function() {
	let currentValue = parseInt(stockInput.val());
	if (currentValue > minStock) {
		stockInput.val(currentValue - 1);
	}
});

// 구매, 장바구니, 찜목록 버튼
function buyMealkit(contextPath) {

}

function cartMealkit(contextPath) {
	// 장바구니 type = 1
	$.ajax({
		url: contextPath + "/Mealkit/mypage.pro",
		type: "POST",
		async: true,
		data: {
			no: mealkitNo,
			type: 1
		},
		success: function(response) {
			if (response === "1") alert("장바구니에 추가되었습니다.");
			else alert("장바구니에 추가를 못 했습니다.");
		}
	});
}

function wishMealkit(contextPath) {
	// 찜하기 type = 0
	$.ajax({
		url: contextPath + "/Mealkit/mypage.pro",
		type: "POST",
		async: true,
		data: {
			no: mealkitNo,
			type: 0
		},
		success: function(response) {
			if (response === "1") alert("찜목록에 추가되었습니다.");
			else alert("찜목록에 추가를 못 했습니다.");
		}
	});
}


// 삭제 함수
function deleteMealkit(no, contextPath) {
	if (confirm('정말로 삭제하시겠습니까?')) {
		$.ajax({
			url: contextPath + "/Mealkit/delete.pro",
			type: "POST",
			async: true,
			data: { no: no },
			success: function(response) {
				if (response === "1") {
					alert("삭제되었습니다.");
					location.href = contextPath + "/Mealkit/list";
				} else {
					alert("삭제에 실패했습니다.");
				}
			}
		});
	}
}

// 수정 함수 
function editMealkit(contextPath) {
	location.href = contextPath + "/Mealkit/update?no=" + mealkitNo + "&bytePictures=" + encodeURIComponent(bytePictures);
}