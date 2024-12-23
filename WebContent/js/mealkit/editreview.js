let originSelectedFileNames = [];
let selectedFileNames = [];
let selectedRealFiles = [];

function onSubmit(event, contextPath) {
	event.preventDefault();

	setPicturesString();

	let mealkitNo = $("#mealkit_no").val();
	let nickName = $("#nickname").val();

	const formData = new FormData();
	formData.append('mealkit_no', $("#mealkit_no").val());
	formData.append('review_no', $("#review_no").val());
	formData.append('pictures', $("#pictures").val());
	formData.append('origin_pictures', $("#origin_pictures").val());
	formData.append('origin_selected_pictures', combineStrings(originSelectedFileNames));
	formData.append('contents', $("#contents").val());
	formData.append('rating', $("#rating").val());

	selectedRealFiles.forEach((file, index) => {
		formData.append('file' + index, file);
	});

	$.ajax({
	    url: contextPath + '/Mealkit/reviewUpdate.pro',
	    type: "POST",
	    data: formData,
	    processData: false,
	    contentType: false,
	    success: function(responseData, status, jqxhr) {
			location.href = contextPath + '/Mealkit/info?no=' + mealkitNo + '&nickName=' + nickName;
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

	let isDuplicated = false;
	
	Array.from(files).forEach(file => {
		if (file.type.startsWith('image/')) {
			let fileName = file.name;
			
			if (!selectedFileNames.includes(fileName) && !originSelectedFileNames.includes(fileName)) {
				selectedFileNames.push(fileName);
				selectedRealFiles.push(file);
	
				const reader = new FileReader();
	
				reader.readAsDataURL(file);
	
				reader.onload = function(e) {
					const li = document.createElement('li');
					const img = document.createElement('img');
					img.src = e.target.result;
	
					img.dataset.filename = file.name;
					img.classList.add('preview_image');
	
					img.addEventListener('click', function() {
						imagePreview.removeChild(img.parentElement);
						removeSelectedFile(fileName);
						document.getElementById('pictureFiles').value = '';
					});
	
					img.style.cursor = 'pointer';
					
					li.appendChild(img);
					imagePreview.appendChild(li);
				}				
			}
			else {
				isDuplicated = true;
			}
		}
	});
	
	if (isDuplicated) {
		alert('동일한 파일명이 있습니다.');
	}

	document.getElementById('pictureFiles').value = '';
}

function removeSelectedFile(fileIdentifier) {
    //selectedFiles = selectedFiles.filter(item => item !== fileIdentifier);
	for (let i = 0; i < selectedFileNames.length; i++) {
		if (selectedFileNames[i] == fileIdentifier) {
			selectedFileNames.splice(i, 1);
			selectedRealFiles.splice(i, 1);
			break;
		}
	}
}

function setPicturesString() {
	let pictures = combineStrings(selectedFileNames);

	document.getElementsByName('pictures')[0].value = pictures;
}