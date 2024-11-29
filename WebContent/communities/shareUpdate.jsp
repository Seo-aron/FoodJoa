<%@page import="VOs.CommunityShareVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	String contextPath = request.getContextPath();
	
	CommunityShareVO share = (CommunityShareVO) request.getAttribute("share");
	String nowBlock = (String)request.getAttribute("nowBlock");
	String nowPage = (String)request.getAttribute("nowPage");
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	
	<title>Insert title here</title>
	
    <script type="text/javascript" src="https://oapi.map.naver.com/openapi/v3/maps.js?ncpClientId=ug8ym1cpbw&submodules=geocoder"></script>
    <script src="http://code.jquery.com/jquery-latest.min.js"></script>
    
    <link rel="stylesheet" href="<%=contextPath%>/css/community/shareupdate.css">
</head>

<body>
	<h1>재료 나눔 게시글 작성</h1>
	<div id="container">
		<form id="frmUpdate" action="<%= contextPath %>/Community/shareUpdate.pro" method="POST" enctype="multipart/form-data">
			<input type="hidden" id="no" name="no">
			<input type="hidden" id="views" name="views">
			<input type="hidden" id="nowBlock" name="nowBlock">
			<input type="hidden" id="nowPage" name="nowPage">
			<table width="100%">
	        	<tr>
	        		<td colspan="2" align="right">
						<input type="button" class="write" value="수정" onclick="onSubmit(event, '<%= contextPath %>')">
						<input type="reset" class="write" value="취소" onclick="onCancle(event)">
					</td>
				</tr>	
	            <tr>
				    <th>게시글 종류</th>
				    <td>
				    	<select id="type" name="type">
				    		<option value="0">재료 나눔해요</option>
				    		<option value="1">같이 먹어요</option>
				    	</select>
				    </td>
				</tr>
                <tr>
                    <th>제목</th>
                    <td><input type="text" id="title" name="title" required placeholder="제목을 입력하세요"></td>
                </tr>
                <tr>
				    <th>사진 추가</th>
				    <td>
				    	<input type="hidden" id="origin-thumbnail" name="origin-thumbnail">
				        <input type="file" name="thumbnail" accept=".png, .jpg, .jpeg" 
				        	required id="thumbnail" onchange="handleFileSelect(this.files)"><br>
				        <div id="imageContainer"></div>
				    </td>
				</tr>
                <tr>
                    <th>내용</th>
                    <td><textarea id="contents" name="contents" rows="4" placeholder="내용을 입력하세요"required><%= share.getContents() %></textarea></td>
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
	                <td colspan="2" align="right">
						<input type="button" class="write" value="수정" onclick="onSubmit(event, '<%= contextPath %>')">
						<input type="reset" class="write" value="취소" onclick="onCancle(event)">
					</td>
				</tr>
            </table>
        </form>
    </div>
    
    
	<script src="<%=contextPath%>/js/community/shareUpdate.js"></script>
	<script>
		initialize();
	
		function initialize() {
			$("#no").val('<%= share.getNo() %>');
			$("#views").val('<%= share.getViews() %>');
			$("#nowPage").val('<%= nowPage %>');
			$("#nowBlock").val('<%= nowBlock %>');
			$("#type").val('<%= share.getType() %>');
			$("#title").val('<%= share.getTitle() %>');
			$("#origin-thumbnail").val('<%= share.getThumbnail() %>');
			
			var $img = $('<img>', {
			    src: '<%= contextPath %>/images/community/thumbnails/<%= share.getNo() %>/<%= share.getThumbnail() %>'
			});

			$('#imageContainer').append($img);
			
			let lat = '<%= share.getLat() %>';
			let lng = '<%= share.getLng() %>';
			
			$("#lat").val(lat);
			$("#lng").val(lng);
			
			point = new naver.maps.Point(Number(lng), Number(lat));
			
			searchCoordinateToAddress(point);
		}
		
		function onCancle(event){
			event.preventDefault();
			history.go(-1);			
		}
	</script>
</body>
</html>