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
	
	<script>
		$(function() {
			$("#title").val('<%= recipe.getTitle() %>');
			$("#description").val('<%= recipe.getDescription() %>');
			$("#category").val('<%= recipe.getCategory() %>');
			
			decompressAndDisplay();
		});
		
		function decompressAndDisplay() {
		    var compressedData = "<%= compressedContents %>";
		    
	        try {
	            // Base64 디코딩
	            const binaryString = atob(compressedData);
	            const bytes = new Uint8Array(binaryString.length);
	            for (let i = 0; i < binaryString.length; i++) {
	                bytes[i] = binaryString.charCodeAt(i);
	            }

	            const decompressedBytes = pako.inflate(bytes);
	            
	            const decompressedText = new TextDecoder('utf-8').decode(decompressedBytes);
	            
	            tinymce.get('contentsArea').setContent(decompressedText);
	        } catch (error) {
	            console.error("압축 해제 중 오류 발생:", error);
	        }
	    }
	</script>
	
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
	</style>
</head>

<body>
	<div id="container">
		<form action="<%= contextPath %>/Recipe/updatePro" method="post" id="frmWrite" enctype="multipart/form-data">
			<table border="1" width="100%">
				<tr>
					<td colspan="2">
						<input type="button" class="write" value="레시피 수정" onclick="onSubmit(event)">
					</td>
				</tr>
				<tr>
					<td rowspan="3">
						<div class="input-container">
							<input type="file" name="file">
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
						<input type="button" class="write" value="레시피 작성" onclick="onSubmit(event)">
					</td>
				</tr>
			</table>
		</form>
	</div>
	
	
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
	    });
	</script>
</body>

</html>