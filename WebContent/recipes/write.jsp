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
	
	<style>
		input[type=button] {
			float: right !important;
		}
	</style>
</head>

<body>
	<div id="container">
		<table border="1">
			<tr>
				<td colspan="2">
					<input type="button" class="write" value="레시피 작성">
				</td>
			</tr>
			<tr>
				<td rowspan="2">
					<div class="input-container">
						<input type="text" id="thumbnail" name="thumbnail" class="thumbnail-control" placeholder="썸네일 사진을 넣어주세요" required readonly />
						<input type="file" name="thumbnailFile" class="thumbnail-input" id="thumbnailFile" onchange="updateFileName()" />
						<label for="thumbnailFile" class="thumbnail-button">파일 선택</label>
					</div>
				</td>
				<td>
					<input type="text" id="title" name="title" placeholder="제목 입력" required>
				</td>
			</tr>
			<tr>
				<td>
					<input type="text" id="description" name="description" placeholder="간단 소개글 입력" required>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<textarea id="contentsArea"></textarea>
					<input type="hidden" name="contents" required>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<p>사용한 재료 작성</p>
					<div class="ingredients-container">
        			</div>
					<p><input type="button" class="add-ingredient" value="재료 추가하기"></p>
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<p>간단 조리 순서 작성</p>
					<div class="orders-container">
        			</div>
					<p><input type="button" class="add-orders" value="순서 추가하기"></p>					
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="button" class="write" value="레시피 작성">
				</td>
			</tr>
		</table>
	</div>
	
	
	<script>
		function updateFileName() {
			var fileInput = document.getElementById("thumbnailFile");
			var thumbnailInput = document.getElementById("thumbnail");
	
			// 파일명이 있을 경우 input에 파일명 표시
			if (thumbnailInput.files.length > 0) {
				profileInput.value = thumbnailInput.files[0].name;
			}
		}
	
		function onSubmit(e) {
		    e.preventDefault();

		    const editorContent = tinymce.get('contentsArea').getContent();
			const base64Compressed = compressContent(editorContent);
 
			document.getElementsByName('contents')[0].value = base64Compressed;
 	
		    document.getElementById('frmWrite').submit();
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
	
		tinymce.init({
	        selector: "#contentsArea", // TinyMCE를 적용할 textarea 요소의 선택자를 지정
	        statusbar: false,
	        height: 500,
	        width: 900,
	        toolbar: "undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | outdent indent | bullist numlist",
	        paste_data_images: true, // 이미지 붙여넣기 설정 활성화
	        plugins: "paste image imagetools advlist lists", // 'paste', 'image', 'imagetools' 플러그인 추가
	        menubar: false,
	        advlist_bullet_styles: 'square',
	        advlist_number_styles: 'lower-alpha,lower-roman,upper-alpha,upper-roman'
	        
	        
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