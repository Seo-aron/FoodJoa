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
		#container {
			width: 1200px;
			margin: 0 auto;
		}
		
		#imageContainer{
			width: 400px;
			height : 100%;
		}
	
	</style>
</head>

<body>
	<h1>재료 나눔 게시글 읽기</h1>
	<div id="container">
		<table width="100%">
			<tr>
				<td colspan="4">
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
					<%=share.getTitle() %>
				</td>
				<td>
					<img src="<%= contextPath %>/images/member/userProfiles/<%= share.getId() %>/<%= member.getProfile() %>">
				</td>
				<td>
					<%=member.getNickname()%>
				</td>
				<td>
					<p>
						<%=share.getViews()%>
					</p>
					<p>
						<%= new SimpleDateFormat("yyyy-MM-dd").format(share.getPostDate()) %>
					</p>
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
					<div>
						<%=share.getContents()%>
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
				<td colspan="4">
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