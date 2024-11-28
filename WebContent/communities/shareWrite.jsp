<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ug8ym1cpbw&submodules=geocoder"></script>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
	
<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: "Noto Serif KR", serif;
    }

    body {
        background-color: #ffffff;
        color: #333333;
        line-height: 1.6;
        padding: 20px;
    }

    h1 {
        font-size: 24px;
        font-weight: bold;
        text-align: center;
        color: #333333;
        margin-bottom: 30px;
    }

    #container {
        width: 1200px;
        margin: 0 auto;
        padding: 20px;
        background-color: #ffffff;
        border: 1px solid #e0e0e0;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
    }

    table {
        width: 100%;
        border-spacing: 0 15px;
    }

    th {
        text-align: center;
        font-size: 16px;
        font-weight: bold;
        color: #555555;
        vertical-align: inherit;
    }

    input[type="text"], textarea, select {
        width: calc(100% - 20px);
        padding: 10px;
        border: 1px solid #cccccc;
        border-radius: 5px;
        font-size: 14px;
        color: #333333;
        background-color: #ffffff;
    }

    input[type="text"]:focus, textarea:focus, select:focus {
        border-color: #007bff;
	    box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
    }

	form input[type="text"]:focus {
	    border-color: #007bff;
	    box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
	}
	
	form input[type="submit"],
	form input[type="button"],
	form input[type="reset"]
		  					{
	    background-color: #BF817E;
	    border: none;
	    border-radius: 5px;
	    padding: 8px 16px;
	    font-size: 1rem;
	    color: white;
	    cursor: pointer;
	    transition: background-color 0.3s ease;
	}
	
	form input[type="submit"]:hover,
	form input[type="button"]:hover {
	    background-color: #e9ecef;
	}
	
	form input[type="submit"]:disabled,
	form input[type="button"]:disabled {
	    background-color: #adb5bd;
	    cursor: not-allowed;
	}
    textarea {
        resize: vertical;
        height: 100px;
    }

    select {
        cursor: pointer;
    }

    input[type="file"] {
        font-size: 14px;
        color: #555555;
    }

    #imageContainer {
        width: 100%;
        height: 200px;
        border: 1px dashed #cccccc;
        border-radius: 5px;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-top: 10px;
    }

    #imageContainer img {
        max-width: 100%;
        max-height: 100%;
        object-fit: cover;
    }

    #map {
        margin-top: 10px;
        width: 100%;
        height: 400px;
        border: 1px solid #cccccc;
        border-radius: 5px;
    }

    input[type="button"]:hover, input[type="reset"]:hover {
        background-color: #f5f5f5;
        color: #000000;
    }

    input[type="button"]:active, input[type="reset"]:active {
        background-color: #e0e0e0;
        color: #000000;
    }

    .write {
        margin-top: 10px;
    }

    #naverAddress {
        width: calc(80% - 10px);
        display: inline-block;
    }

    #naverSearch {
        width: calc(20% - 10px);
        display: inline-block;
        margin-left: 10px;
    }

    form input [type="button"]{
    	margin-right:50px;
    }
    
    .community_p1{
    	font-size: 40px;
    }
    
    .community_p2{
    	font-size: 30px;
    }
    
</style>
		
</head>

<body>
	<div id="top_container" align="center">
		<p class="community_p1">COMMUNITY</p>
		<p class="community_p2">재료 나눔/같이 먹어요 게시판</p>
		<p>자유롭게 글을 작성해보세요</p>
	</div>
	<div id="container">
		<form id="frmWrite" action="<%= contextPath %>/Community/shareWrite.pro" method="POST" enctype="multipart/form-data">
			<table width="100%">
	        	<tr>
	        		<td colspan="2" align="right">
						<input type="button" class="write" value="작성" onclick="onSubmit(event)">
					</td>
				</tr>	
	            <tr>
				    <th>게시글 종류</th>
				    <td>
				    	<select name="type">
				    		<option value="" disabled hidden selected>게시글 유형을 선택해주세요</option>
				    		<option value="0">재료 나눔해요</option>
				    		<option value="1">같이 먹어요</option>
				    	</select>
				    </td>
				</tr>
                <tr>
                    <th>제목</th>
                    <td><input type="text" name="title" required placeholder="제목을 입력하세요"></td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td><textarea name="contents" rows="4" placeholder="내용을 입력하세요"required></textarea></td>
                </tr>
				<tr>
				    <th>사진 추가</th>
				    <td>
				        <input type="file" name="thumbnail" accept=".png, .jpg, .jpeg" 
				        	required id="thumbnail" onchange="handleFileSelect(this.files)"><br>
				        <div id="imageContainer"></div>
				    </td>
				</tr>
                <tr>
                    <th>지도</th>
                    <td>
                    	<input type="hidden" id="lat" name="lat">
                    	<input type="hidden" id="lng" name="lng">
						<input type="text" id="naverAddress" placeholder="도로명 주소를 입력해주세요">
						<input type="button" id="naverSearch" value="검색">
                    	<div id="map" style="width:100%;height:400px;"></div>
					</td>
                </tr>
                <tr>
	                <td colspan="2" align="right">
						<input type="button" class="write" value="작성" onclick="onSubmit(event)">
						<input type="reset" class="write" value="취소">
					</td>
				</tr>
            </table>
        </form>
    </div>
    
    <script src="<%=contextPath%>/js/community/shareWrite.js"></script>
	<script>
		function onSubmit(event) {
			event.preventDefault();
			
			if ($("#lat").val() == "" || $("#lng").val() == "") {
				alert('지도 좌표를 선택해주세요');
				return;
			}
			
			$("#frmWrite").submit();
		}
	</script>
</body>
</html>