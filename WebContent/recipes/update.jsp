<%@page import="java.util.List"%>
<%@page import="Common.StringParser"%>
<%@page import="VOs.RecipeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
	
	RecipeVO recipe = (RecipeVO) request.getAttribute("recipe");
	
	String compressedContents = recipe.getContents();
%>
    
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script src="<%= contextPath %>/js/recipe/update.js"></script>
	<script src="https://cdn.tiny.cloud/1/dvxu8ag2amp0f6jzdha1igxdgal2cpo0waqtixb0z64yirx7/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pako/2.1.0/pako.min.js"></script>
	
	<style>
		#container {			
			margin: 0 auto;
			border: 2px solid black;
			width: 1200px;
		}
	
		input[type=button] {
			float: right !important;
		}
		
		select option[value=""] {
			display: none;
		}
		
		.tox-toolbar-overlord {
			width: 100%;
		}
		
		.thumbnail-container {
			width: 256px;
			height: 256px;
		}
		
		.thumbnail-container div {
			width: 100%;
			height: 100%;
			overflow: hidden;
		}
		
		.thumbnail-container img {
			width: 100%;
			height: 100%;
			object-fit: cover;
		}
	</style>
</head>

<body>
	<div id="container">
		<form action="<%= contextPath %>/Recipe/updatePro" method="post" id="frmWrite" enctype="multipart/form-data">
			<input type="hidden" id="no" name="no">
			<input type="hidden" id="views" name="views">
			<input type="hidden" id="thumbnail-origin" name="thumbnail-origin">
			
			<table border="1" width="100%">
				<tr>
					<td colspan="2">
						<input type="button" class="write" value="레시피 수정" onclick="onSubmit(event)">
					</td>
				</tr>
				<tr>
					<td rowspan="3" class="thumbnail-container">
						<div>
							<input type="file" name="file" id="imageInput" accept=".png,.jpeg,.jpg" style="display: none;">
							<img id="imagePreview" src="<%= contextPath %>/images/recipe/file_select_button.png"
							 style="cursor: pointer;">
						</div>
					</td>
					<td>
						<input type="text" id="title" name="title" placeholder="제목 입력">
					</td>
				</tr>
				<tr>
					<td>
						<input type="text" id="description" name="description" placeholder="간단 소개글 입력">
					</td>
				</tr>
				<tr>
					<td>
						<select id="category" name="category">
							<option value="" disabled hidden selected>음식 종류를 선택하세요.</option>
							<option value="1">한식</option>
							<option value="2">일식</option>
							<option value="3">중식</option>
							<option value="4">양식</option>
							<option value="5">자취요리</option>
						</select>
					</td>					
				</tr>
				<tr>
					<td colspan="2">
						<textarea id="contentsArea" width="100%"></textarea>
						<input type="hidden" name="contents">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<p>사용한 재료 작성</p>
						<div class="ingredients-container">
	        			</div>
						<p><input type="button" class="add-ingredient" value="재료 추가하기"></p>
						<input type="hidden" id="ingredient" name="ingredient">
						<input type="hidden" id="ingredient_amount" name="ingredient_amount">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<p>간단 조리 순서 작성</p>
						<div class="orders-container">
	        			</div>
						<p><input type="button" class="add-orders" value="순서 추가하기"></p>
						<input type="hidden" id="orders" name="orders">
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="button" class="write" value="레시피 수정" onclick="onSubmit(event)">
					</td>
				</tr>
			</table>
		</form>
	</div>
	
	<%
	List<String> ingredients = StringParser.splitString(recipe.getIngredient());
	List<String> amounts = StringParser.splitString(recipe.getIngredientAmount());
	List<String> orders = StringParser.splitString(recipe.getOrders());
	%>
	<script>
		function onSubmit(e) {
		    e.preventDefault();
		    
		    setIngredientString();
		    setOrdersString();
		    
		    const editorContent = tinymce.get('contentsArea').getContent();
			const base64Compressed = compressContent(editorContent);
 
			document.getElementsByName('contents')[0].value = base64Compressed;
 	
		    document.getElementById('frmWrite').submit();
		}
		
		let decompressedText;
		
		initialize();		
		
		function initialize() {
			$("#no").val('<%= recipe.getNo() %>');
			$("#views").val('<%= recipe.getViews() %>');
			$("#thumbnail-origin").val('<%= recipe.getThumbnail() %>');
			
			$("#imagePreview").attr('src','<%= contextPath %>/images/recipe/thumbnails/<%= recipe.getNo() %>/<%= recipe.getThumbnail() %>');
			$("#title").val('<%= recipe.getTitle() %>');
			$("#description").val('<%= recipe.getDescription() %>');
			$("#category").val('<%= recipe.getCategory() %>');
			decompressContents();
			<%
			for (int i = 0; i < ingredients.size(); i++) {
				%>
				var newIngredientHtml = 
	                '<p class="added-ingredient">' +
					'<span class="added-ingredient-name"><%= ingredients.get(i) %></span>' + 
					'<span class="added-ingredient-amount"><%= amounts.get(i) %></span>' +
	                '<button type="button" class="remove-ingredient">삭제</button>' +
	                '</p>';
	                
                $(".ingredients-container").append(newIngredientHtml);
				<%
			}
			
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
		}
		
		const imageInput = document.getElementById('imageInput');
		const imagePreview = document.getElementById('imagePreview');

		imagePreview.addEventListener('click', () => {
		  imageInput.click();
		});

		imageInput.addEventListener('change', (event) => {
		  const file = event.target.files[0];
		  if (file) {
		    const reader = new FileReader();
		    reader.onload = (e) => {
		      imagePreview.src = e.target.result;
		    };
		    reader.readAsDataURL(file);
		  }
		});

		function decompressContents() {
		    var compressedData = "<%= compressedContents %>";
		    
	        try {
	            // Base64 디코딩
	            const binaryString = atob(compressedData);
	            const bytes = new Uint8Array(binaryString.length);
	            for (let i = 0; i < binaryString.length; i++) {
	                bytes[i] = binaryString.charCodeAt(i);
	            }

	            const decompressedBytes = pako.inflate(bytes);
	            
	            decompressedText = new TextDecoder('utf-8').decode(decompressedBytes);
	        } catch (error) {
	            console.error("압축 해제 중 오류 발생:", error);
	        }
		}
		
		tinymce.init({
	        selector: "#contentsArea", // TinyMCE를 적용할 textarea 요소의 선택자를 지정
	        statusbar: false,
	        height: 500,
	        toolbar: "undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | outdent indent | bullist numlist",
	        paste_data_images: true, // 이미지 붙여넣기 설정 활성화
	        plugins: "paste image imagetools advlist lists", // 'paste', 'image', 'imagetools' 플러그인 추가
	        menubar: false,
	        advlist_bullet_styles: 'square',
	        advlist_number_styles: 'lower-alpha,lower-roman,upper-alpha,upper-roman',
			setup : function(editor) {
				editor.on('init', function() {
					// 에디터가 초기화된 후 실행될 코드
					tinymce.get('contentsArea').setContent(decompressedText);
				});
			}
	    });
	</script>
</body>

</html>