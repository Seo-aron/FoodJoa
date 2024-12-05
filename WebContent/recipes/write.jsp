<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
%>
    
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script src="<%= contextPath %>/js/recipe/write.js"></script>
	<script src="https://cdn.tiny.cloud/1/dvxu8ag2amp0f6jzdha1igxdgal2cpo0waqtixb0z64yirx7/tinymce/5/tinymce.min.js" referrerpolicy="origin"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pako/2.1.0/pako.min.js"></script>
	<script src="<%= contextPath %>/js/common/common.js"></script>
	
	<link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">	
	<link rel="stylesheet" href="<%=contextPath%>/css/recipe/write.css">    
</head>

<body>
	<div id="recipe-container">
		<form action="<%= contextPath %>/Recipe/writePro" method="post" id="frmWrite" enctype="multipart/form-data">
			<table width="100%">
				<tr>
					<td colspan="2" align="right">
						<input type="button" class="recipe-write-button" value="레시피 작성" onclick="onSubmit(event)">
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
							<select name="category">
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
							<img id="imagePreview" src="<%= contextPath %>/images/recipe/addImage.png"
								style="cursor: pointer; width: auto; height: 100px;">
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
						<input type="button" class="recipe-write-button" value="레시피 작성" onclick="onSubmit(event)">
						<input type="button" class="recipe-cancle-button" value="취소" onclick="onCancleButton(event)">
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
		    
		    const editorContent = tinymce.get('contents-field').getContent();
			const base64Compressed = compressContent(editorContent);
 
			document.getElementsByName('contents')[0].value = base64Compressed;
 	
		    document.getElementById('frmWrite').submit();
		}
		
		function onCancleButton(e) {
		    e.preventDefault();
		    
		    history.go(-1);
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
	        
	        
	        
	        /*	        
	        formats: {
	            alignleft: { selector: 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img,audio,video', classes: 'left' },
	            aligncenter: { selector: 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img,audio,video', classes: 'center' },
	            alignright: { selector: 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img,audio,video', classes: 'right' },
	            alignjustify: { selector: 'p,h1,h2,h3,h4,h5,h6,td,th,div,ul,ol,li,table,img,audio,video', classes: 'full' },
	            bold: { inline: 'span', 'classes': 'bold' },
	            italic: { inline: 'span', 'classes': 'italic' },
	            underline: { inline: 'span', 'classes': 'underline', exact: true },
	            strikethrough: { inline: 'del' },
	            forecolor: { inline: 'span', classes: 'forecolor', styles: { color: '%value' } },
	            hilitecolor: { inline: 'span', classes: 'hilitecolor', styles: { backgroundColor: '%value' } },
	            custom_format: { block: 'h1', attributes: { title: 'Header' }, styles: { color: 'red' } }
	        },
			skin: 'oxide-dark',
			content_css: 'dark'
	        
	        file_picker_types: 'image', // TinyMCE에서 이미지를 선택할 때, 이미지 파일만 선택 (옵션 : media, file 등)
	        images_upload_handler(blobInfo, success) { // 이미지를 업로드하는 핸들러 함수
	            // blobInfo : TinyMCE에서 이미지 업로드 시 사용되는 정보를 담고 있는 객체
	            const file = new File([blobInfo.blob()], blobInfo.filename());
	            const fileName = blobInfo.filename();
	 
	            if (fileName.includes("blobid")) {
	                success(URL.createObjectURL(file));
	            } else {
	                imageFiles.push(file);
	                success(URL.createObjectURL(file)); // Blob 객체의 임시 URL을 생성해 이미지 미리보기 적용
	            }
	        } */
	    });
	</script>
</body>

</html>