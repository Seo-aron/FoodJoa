
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




let selectedFiles = [];
let selectedRealFiles = [];

function onSubmit(event, contextPath) {
	event.preventDefault();

	setPicturesString();

	const formData = new FormData();
	formData.append('recipe_no', $("#recipe_no").val());
	formData.append('pictures', $("#pictures").val());
	formData.append('contents', $("#contents").val());
	formData.append('rating', $("#rating").val());

	selectedRealFiles.forEach((file, index) => {
		formData.append('file' + index, file);
	});

	$.ajax({
	    url: contextPath + '/Recipe/reviewWrite',
	    type: "POST",
	    data: formData,
	    processData: false,
	    contentType: false,
	    success: function(responseData, status, jqxhr) {
	        console.log("success", responseData);
	    },
	    error: function(xhr, status, error) {
	        console.log("error", error);
	    }
	});
}

function onCancleButton(event) {
	event.preventDefault();

	history.back();
}

function handleFileSelect(files) {
	const imagePreview = document.getElementById('imagePreview');

	Array.from(files).forEach(file => {
		if (file.type.startsWith('image/')) {
			let fileIdentifier = `${file.name}-${file.size}`;
			
			if (!selectedFiles.includes(fileIdentifier)) {
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