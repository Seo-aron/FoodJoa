
$(function() {
	$(".write").click(function(event) {
		event.preventDefault();
	});
    
    $(".add-ingredient").click(function() {
        var newIngredientHtml = `
            <p class="ingredient-row" border="1">
                <input type="text" class="name-ingredient" placeholder="음식 재료 이름을 적어주세요.">
                <input type="text" class="amount-ingredient" placeholder="재료의 수량을 단위로 적어주세요.">
                <button type="button" class="addrow-ingredient">추가</button>
                <button type="button" class="cancle-ingredient">취소</button>
            </p>
        `;
        
        $(this).parent().prev().append(newIngredientHtml);
    });

    $(document).on('click', '.addrow-ingredient', function() {
        var $row = $(this).closest('.ingredient-row');
        var name = $row.find('.name-ingredient').val();
        var amount = $row.find('.amount-ingredient').val();
        
        if (name && amount) {
        	var newIngredientHtml = 
                '<p class="added-ingredient">' +
				'<span class="added-ingredient-name">' + name + '</span>' + 
				'<span class="added-ingredient-amount">' + amount + '</span>' +
                '<button type="button" class="remove-ingredient">삭제</button>' +
                '</p>';
            
            $row.replaceWith(newIngredientHtml);
        }
		else {
            alert("재료명과 양을 모두 입력해주세요.");
        }
    });

    $(document).on('click', '.cancle-ingredient', function() {
        $(this).closest('.ingredient-row').remove();
    });

	$(document).on('click', '.remove-ingredient', function() {
	    $(this).closest('.added-ingredient').remove();
	});
	


	$(".add-orders").click(function() {
	    var newIngredientHtml = `
	        <p class="orders-row">
	            <input type="text" class="name-orders" placeholder="조리 순서를 간단히 적어주세요.">
	            <button type="button" class="addrow-orders">추가</button>
	            <button type="button" class="cancle-orders">취소</button>
	        </p>
	    `;
	    
	    $(this).parent().prev().append(newIngredientHtml);
	});

	$(document).on('click', '.addrow-orders', function() {
	    var $row = $(this).closest('.orders-row');
	    var name = $row.find('.name-orders').val();
	    
	    if (name) {
	    	var newIngredientHtml = 
	            '<p class="added-orders">' +
				'<span class="added-order">' + name + '</span>' + 
	            '<button type="button" class="remove-orders">삭제</button>' +
	            '</p>';
	        
	        $row.replaceWith(newIngredientHtml);
	    }
		else {
	        alert("조리 순서를 입력 해주세요.");
	    }
	});

	$(document).on('click', '.cancle-orders', function() {
	    $(this).closest('.orders-row').remove();
	});

	$(document).on('click', '.remove-orders', function() {
	    $(this).closest('.added-orders').remove();
	});
});

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

function setIngredientString() {
	
	let ingredients = $(".added-ingredient-name");
	let ingredientsString = [];
	
	ingredients.each(function(index, element) {
		ingredientsString.push($(element).text());
	});
	
	let combinedIngredientsString = combineStrings(ingredientsString);
	
	document.getElementsByName('ingredient')[0].value = combinedIngredientsString ;
	
	
		
	let amounts = $(".added-ingredient-amount");
	let amountsString = [];
		
	amounts.each(function(index, element) {
		amountsString.push($(element).text());
	});
	
	let combinedAmountString = combineStrings(amountsString);

	document.getElementsByName('ingredient_amount')[0].value = combinedAmountString;
	
}

function setOrdersString() {

	let orders = $(".added-order");
	let ordersString = [];
		
	orders.each(function(index, element) {
		ordersString.push($(element).text());
	});
	
	let combinedOrderString = combineStrings(ordersString);

	document.getElementsByName('orders')[0].value = combinedOrderString;	
}

function compressContent(editorContent) {
    const contentBytes = new TextEncoder().encode(editorContent);
    const compressedContent = pako.deflate(contentBytes);
    
    // 배열을 문자열로 변환하는 함수
    function arrayToBase64(array) {
        const chunk = 0xffff; // 최대 청크 크기
        let result = '';
        for (let i = 0; i < array.length; i += chunk) {
            result += String.fromCharCode.apply(null, array.subarray(i, i + chunk));
        }
        return btoa(result);
    }

    return arrayToBase64(compressedContent);
}