<%@page import="VOs.MemberVO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="VOs.CommunityVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
	
	HashMap<String, Object> community = (HashMap<String, Object>)request.getAttribute("community");
	
	CommunityVO communityVO = (CommunityVO)community.get("communityVO");
	MemberVO memberVO = (MemberVO)community.get("memberVO");
	
	String id = (String) session.getAttribute("userId");
%>
    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>작성글 읽기 및 글 수정, 삭제, 목록</title>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>	
	<link rel="stylesheet" href="<%=contextPath%>/css/community/read.css">
</head>

<body>
	<div id="commnunity-container">
		<div id="community-header" align="center">
			<p class="community_p1">COMMUNITY</p>
			<p class="community_p2">자유게시판</p>
			<p>자유롭게 글을 작성해보세요</p>
		</div>
		
		<div id="community-body">
			<table width="100%">
				<tr>
					<td colspan="4" align="right">
						<div class="community-button-area">
							<input type="button" value="목록" id="list" onclick="onListButton()">
							<%
							if (id != null && id.equals(communityVO.getId())) {
								%>
								<input type="button" value="수정" id="update" onclick="onUpdateButton()">
								<input type="button" value="삭제" id="delete" onclick="onDeleteButton()">
								<%
							}
							%>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<div class="community_title">
							<%= communityVO.getTitle() %>
						</div>
					</td>
				</tr>
				<tr>
					<td width="50px" rowspan="2">
						<div class="image_profile">
							<img src="<%= contextPath %>/images/member/userProfiles/<%= communityVO.getId() %>/<%= memberVO.getProfile() %>">
						</div>
					</td>
					<td>
						<div class="community_nickname">
							<%= memberVO.getNickname()%>
						</div>
					</td>	
				<tr>
					<td>
						<div class="community_date">
							<span><%=new SimpleDateFormat("yyyy-MM-dd").format(communityVO.getPostDate())%></span>
							<span>&nbsp;조회 <%= communityVO.getViews()%></span>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<div class="community_contents">
							<%= communityVO.getContents() %>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4" align="right">
						<div class="community-button-area">
							<input type="button" value="목록" id="list" onclick="onListButton()">
							<%
							if (id != null && id.equals(communityVO.getId())) {
								%>
								<input type="button" value="수정" id="update" onclick="onUpdateButton()">
								<input type="button" value="삭제" id="delete" onclick="onDeleteButton()">
								<%
							}
							%>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<form name="frmUpdate" method="post">
		<input type="hidden" name="no">
		<input type="hidden" name="title">
		<input type="hidden" name="contents">
		<input type="hidden" name="views">
	</form>
	
	<script>
		function onListButton() {
			location.href = '<%= contextPath %>/Community/list';
			
		}
	
		function onUpdateButton() {
			document.frmUpdate.action = "<%= contextPath %>/Community/update";
			
			document.frmUpdate.no.value = "<%= communityVO.getNo()%>";
			document.frmUpdate.title.value = "<%= communityVO.getTitle() %>";
			document.frmUpdate.contents.value = `<%= communityVO.getContents() %>`;
			document.frmUpdate.views.value = <%= communityVO.getViews()%>;
			
			document.frmUpdate.submit();
		}
		
		function onDeleteButton() {
			$.ajax({
				url: "<%= contextPath%>/Community/deletePro",
				type: "post",
				data : {
					no: <%= communityVO.getNo()%>
				},
				dataType: "text",
				success: function(responsedData){
					
					if(responsedData == "삭제 완료"){
						location.href ='<%= contextPath %>/Community/list';
					}
					else {
						alert('삭제되지 않았습니다.');
					}
				},
				error: function(error){
					console.log(error);
				}				
			});
		}
	</script>
</body>

</html>
