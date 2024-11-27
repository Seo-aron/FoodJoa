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
		#container {
			width: 1200px;
		}
		
		#imageContainer {
			width: 128px;
			height: 128px;
			overflow: hidden;
		}
		
		#imageContainer img {
			width: 100%;
			height: 100%;
			object-fit: cover;
		}
	</style>
</head>

<body>
	<h1>재료 나눔 게시글 작성</h1>
	<div id="container">
		<form id="frmWrite" action="<%= contextPath %>/Community/shareWrite.pro" method="POST" enctype="multipart/form-data">
			<table width="100%">
	        	<tr>
	        		<td colspan="0">
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
				    <th>사진 추가</th>
				    <td>
				        <input type="file" name="thumbnail" accept=".png, .jpg, .jpeg" 
				        	required id="thumbnail" onchange="handleFileSelect(this.files)"><br>
				        <div id="imageContainer"></div>
				    </td>
				</tr>
                <tr>
                    <th>내용</th>
                    <td><textarea name="contents" rows="4" placeholder="내용을 입력하세요"required></textarea></td>
                </tr>
                <tr>
                    <th>지도</th>
                    <td>
                    	<input type="hidden" id="lat" name="lat">
                    	<input type="hidden" id="lng" name="lng">
						<input type="text" id="naverAddress" >
						<input type="button" id="naverSearch" value="검색">
                    	<div id="map" style="width:100%;height:400px;"></div>
					</td>
                </tr>
                <tr>
	                <td colspan="2">
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