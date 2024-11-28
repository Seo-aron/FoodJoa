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
	<script src="<%= contextPath %>/js/common/common.js"></script>
	
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">	
	<link rel="stylesheet" href="<%=contextPath%>/css/recipe/update.css">    
</head>

<body>
	<div id="recipe-container">
		<form action="<%= contextPath %>/Recipe/updatePro" method="post" id="frmWrite" enctype="multipart/form-data">
			<input type="hidden" id="no" name="no">
			<input type="hidden" id="views" name="views">
			<input type="hidden" id="thumbnail-origin" name="thumbnail-origin">
			
			<table width="100%">
				<tr>
					<td colspan="2" align="right">
						<input type="button" class="recipe-write-button" value="레시피 수정" onclick="onSubmit(event)">
						<input type="button" class="recipe-cancle-button" value="취소" onclick="onCancleButton(event)">
					</td>
				</tr>
				<tr>
					<td style="vertical-align: top;">
						<div class="recipe-label">
							음식 유형
						</div>
					</td>
					<td align="left">
						<div class="category-area">
							<select id="category" name="category">
								<option value="" disabled hidden selected>음식 유형을 선택하세요.</option>
								<option value="1">한식</option>
								<option value="2">일식</option>
								<option value="3">중식</option>
								<option value="4">양식</option>
								<option value="5">자취요리</option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<td style="vertical-align: top;">
						<div class="recipe-label">
							음식 사진
						</div>
					</td>
					<td align="center">
						<div class="thumbnail-area">
							<input type="file" name="file" id="imageInput" accept=".png,.jpeg,.jpg" style="display: none;">
							<img id="imagePreview" src="<%= contextPath %>/images/recipe/file_select_button.png"
								style="cursor: pointer;">
						</div>
					</td>
				</tr>
				<tr>
					<td style="vertical-align: top;">
						<div class="recipe-label">
							레시피 제목
						</div>
					</td>
					<td align="center">
						<div class="title-area">
							<input type="text" id="title" name="title" placeholder="제목 입력">
						</div>
					</td>
				</tr>
				<tr>
					<td style="vertical-align: top;">
						<div class="recipe-label">
							간단 소개글
						</div>
					</td>
					<td align="center">
						<div class="description-area">
							<input type="text" id="description" name="description" placeholder="간단 소개글 입력">
						</div>
					</td>
				</tr>
				<tr>
					<td style="vertical-align: top;">
						<div class="recipe-label">
							상세 내용
						</div>
					</td>
					<td align="center">
						<div class="contents-area">
							<textarea id="contents-field" width="100%"></textarea>
							<input type="hidden" name="contents" required>
						</div>
					</td>
				</tr>
				<tr>
					<td style="vertical-align: top;">
						<div class="recipe-label">
							사용한 재료
						</div>
					</td>
					<td align="center">
						<input type="hidden" id="ingredient" name="ingredient">
						<input type="hidden" id="ingredient_amount" name="ingredient_amount">
						
						<div class="ingredients-container">
							<table width="100%">
							</table>
						</div>
						<div class="ingredients-button-area">
							<button type="button" class="ingredient-new-button">재료 추가하기</button>
						</div>
					</td>
				</tr>
				<tr>
					<td style="vertical-align: top;">
						<div class="recipe-label">
							간단 조리 순서
						</div>
					</td>
					<td align="center">
						<input type="hidden" id="orders" name="orders">
						
						<div class="orders-container">
							<table width="100%">
							</table>
						</div>
						<div class="orders-button-area">
							<button type="button" class="orders-new-button">순서 추가하기</button>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2" align="right">
						<input type="button" class="recipe-write-button" value="레시피 수정" onclick="onSubmit(event)">
						<input type="button" class="recipe-cancle-button" value="취소" onclick="onCancleButton(event)">
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
		    
		    const editorContent = tinymce.get('contents-field').getContent();
			const base64Compressed = compressContent(editorContent);
 
			document.getElementsByName('contents')[0].value = base64Compressed;
 	
		    document.getElementById('frmWrite').submit();
		}
		
		function onCancleButton(e) {
		    e.preventDefault();
		    
		    history.go(-1);
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
	                '<tr class="ingredient-added-row">' + 
						'<td>' +
							'<div class="ingredient-added-name"><%= ingredients.get(i) %></div>' +
						'</td>' +
						'<td>' +
							'<div class="ingredient-added-amount"><%= amounts.get(i) %></div>' +
						'</td>' +
						'<td align="left">' +
							'<button type="button" class="ingredient-remove-button">삭제</button>' +
						'</td>' +
					'</tr>';
				
                $(".ingredients-container>table").append(newIngredientHtml);
				<%
			}
			
			for (int i = 0; i < orders.size(); i++) {
				%>
				var newOrderHtml = 
				    '<tr class="orders-added-row">' + 
						'<td>' +
							'<div class="orders-added-name"><%= orders.get(i) %></div>' +
						'</td>' +
						'<td align="left">' +
							'<button type="button" class="orders-remove-button">삭제</button>' +
						'</td>' +
					'</tr>';
					
				$(".orders-container>table").append(newOrderHtml);
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
	        selector: "#contents-field", // TinyMCE를 적용할 textarea 요소의 선택자를 지정
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
					tinymce.get('contents-field').setContent(decompressedText);
				});
			}
	    });
	</script>
</body>

</html>