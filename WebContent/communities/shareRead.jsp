<%@page import="java.text.SimpleDateFormat"%>
<%@page import="VOs.MemberVO"%>
<%@page import="VOs.CommunityShareVO"%>
<%@page import="java.util.HashMap"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>  
<%
	String contextPath = request.getContextPath();

	HashMap<String, Object> shareMap = (HashMap<String, Object>) request.getAttribute("share");

	CommunityShareVO share = (CommunityShareVO) shareMap.get("share");
	MemberVO member = (MemberVO) shareMap.get("member");
	
	String nowBlock = (String)request.getAttribute("nowBlock");
	String nowPage = (String)request.getAttribute("nowPage");
	
	String id = (String)session.getAttribute("userId");
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Share Read</title>

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

    td {
        padding: 10px;
        vertical-align: top;
    }

    td[colspan="4"] {
        padding-top: 20px;
    }

    #imageContainer {
        width: 100%;
        max-height: 600px;
        margin-top: 10px;
        overflow: hidden;
        border-radius: 10px;
    }

    #imageContainer img {
        width: 100%;
        object-fit: cover;
        border-radius: 10px;
    }

    #map {
        margin-top: 20px;
        width: 100%;
        height: 400px;
        border: 1px solid #cccccc;
        border-radius: 10px;
    }

    input[type="button"] {
    	background-color: #BF817E;
	    border: none;
	    border-radius: 5px;
	    padding: 8px 16px;
	    font-size: 1rem;
	    color: white;
	    cursor: pointer;
	    transition: background-color 0.3s ease;
    }

    input[type="button"]:hover {
        background-color: #f5f5f5;
    }

    input[type="button"]:active {
        background-color: #e0e0e0;
    }

	
    .image_profile {
        border-radius: 50%;
        width: 100px;
        height: 100px;
        margin-right: 10px;
        overflow: hidden;
    }

	.image_profile img {
		width: 100%;
		height: 100%;
		object-fit: cover;
	}
	
    .content {
        padding: 20px;
        background-color: #f9f9f9;
        border: 1px solid #e0e0e0;
        border-radius: 5px;
    }

    .meta {
        font-size: 12px;
        color: #777777;
    }

    .actions {
        text-align: right;
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
		<p class="community_p2">나눔 / 같이 먹어요</p>
		<p>자유롭게 글을 작성해보세요</p>
	</div>
	<div id="container">
		<table width="100%">
			<tr>
				<td colspan="4" align="right">
					<input type="button" value="목록" onclick="onListButton()">
					<%
					if(id != null && id.equals(share.getId())){
						%>
						<input type="button" value="수정" onclick="onUpdateButton()">
						<input type="button" value="삭제" onclick="onDeleteButton()">
						<%
					}
					%>
				</td>
			</tr>
			<tr>
				<td>
					<div class="image_profile">
						<img src="<%= contextPath %>/images/member/userProfiles/<%= share.getId() %>/<%= member.getProfile() %>">
					</div>
				</td>
				<td>
					제목 : <%=share.getTitle() %>
				</td>
				<td>
					작성자 : <%=member.getNickname()%>
				</td>
				<td>
					<p>
						조회수 : <%=share.getViews()%>
					</p>
					<p>
						작성날짜 : <%= new SimpleDateFormat("yyyy-MM-dd").format(share.getPostDate()) %>
					</p>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<div>
						<%=share.getContents()%>
					</div>	
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<div id="imageContainer">
						<img src="<%=contextPath%>/images/community/thumbnails/<%=share.getNo()%>/<%=share.getThumbnail()%>">
					</div>
				</td>
			</tr>
			<tr>
				<td colspan="4">
					<input type="hidden" id="lat" value="<%=share.getLat()%>">
					<input type="hidden" id="lng" value="<%=share.getLng()%>">
				
					<div id="map" style="width:100%;height:400px;"></div>
				</td>
			</tr>
			<tr>
				<td colspan="4" align="right">
					<input type="button" value="목록" onclick="onListButton()">		
				</td>
			</tr>
		</table>
	</div>
	
	<script src="<%=contextPath%>/js/community/shareRead.js"></script>

	<script>
		let lat = $("#lat").val();
		let lng = $("#lng").val();

		initialize();
		
		function initialize(){
			point = new naver.maps.Point(Number(lng), Number(lat));
			
			searchCoordinateToAddress(point);
		}
		
		function onListButton(){
			location.href='<%=contextPath%>/Community/shareList?nowBlock=<%=nowBlock%>&nowPage=<%=nowPage%>';
		}
		
		function onUpdateButton(){
			location.href='<%=contextPath%>/Community/shareUpdate?no=<%=share.getNo()%>&nowBlock=<%=nowBlock%>&nowPage=<%=nowPage%>';
		}
		
		function onDeleteButton() {
			location.href='<%=contextPath%>/Community/shareDeletePro?no=<%=share.getNo()%>';
		}
	</script>
</body>

</html>