
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
                name + ' : ' + amount +
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
	            name +
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