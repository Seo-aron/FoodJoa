
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
    let result = '';
    for (let str of strings) {
        // 문자열 길이를 2바이트로 변환
        let length = str.length;
        let lengthBytes = String.fromCharCode(length >> 8, length & 0xFF);
        // 길이 + 문자열 추가
        result += lengthBytes + str;
    }
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
	
	/*
	let str = "";
	
	let ingredients = $(".added-ingredient-name");
	
	ingredients.each(function(index, element) {
		console.log($(element).text());
		
		str += $(element).text() + '@';
	});		

	document.getElementsByName('ingredient')[0].value = str;
	
	let ingredientAmounts = $(".added-ingredient-amount");
	
	ingredientAmounts.each(function(index, element) {
		console.log($(element).text());
		
		str += $(element).text() + '@';
	});
	

	document.getElementsByName('ingredient_amount')[0].value = str;
	*/
}

function setOrdersString() {

	let orders = $(".added-order");
	let ordersString = [];
		
	orders.each(function(index, element) {
		ordersString.push($(element).text());
	});
	
	let combinedOrderString = combineStrings(ordersString);

	document.getElementsByName('orders')[0].value = combinedOrderString;
	
	/*
	let str = "";
	
	let ingredients = $(".added-order");
	
	ingredients.each(function(index, element) {
		console.log($(element).text());
		
		str += $(element).text() + '@';
	});		

	document.getElementsByName('orders')[0].value = str;
	*/
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