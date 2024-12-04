<%@page import="VOs.NoticeVO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="VOs.CommunityVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
	
	NoticeVO noticeVO = (NoticeVO) request.getAttribute("noticeVO");
	
	String id = (String) session.getAttribute("userId");
	String adminId = "tQi32Qj0iONPLRZ16-5sX4-Gq_p8Jg_T33r-HdtLEFE";
	
	String nowPage = (String) request.getAttribute("nowPage");
	String nowBlock = (String) request.getAttribute("nowBlock");
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
			<p class="community_p1">NOTICE</p>
			<p class="community_p2">공지 사항</p>
		</div>
		
		<div id="community-body">
			<table width="100%">
				<tr>
					<td colspan="4" align="right">
						<div class="community-button-area">
							<input type="button" value="목록" id="list" onclick="onListButton()">
							<%
							if (id != null && id.length() > 0 && id.equals(adminId)) {
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
					<td width="80%">
						<div class="community_title">
							<%= noticeVO.getTitle() %>
						</div>
					</td>
					<td width="20%">
						<div class="community_date">
							<span><%=new SimpleDateFormat("yyyy-MM-dd").format(noticeVO.getPostDate())%></span>
							<span>&nbsp;조회 <%= noticeVO.getViews()%></span>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<div class="community_contents">
							<%= noticeVO.getContents() %>
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="4" align="right">
						<div class="community-button-area">
							<input type="button" value="목록" id="list" onclick="onListButton()">
							<%
							if (id != null && id.length() > 0 && id.equals(adminId)) {
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
		<input type="hidden" name="nowPage" value="<%= nowPage %>">
		<input type="hidden" name="nowBlock" value="<%= nowBlock %>">
	</form>
	
	<script>
		function onListButton() {
			<%
			if (nowPage != null && nowBlock != null) {
				%>location.href = '<%= contextPath %>/Community/noticeList?nowPage=<%=nowPage%>&nowBlock=<%=nowBlock%>';<%
			}
			else {
				%>location.href = '<%= contextPath %>/Community/noticeList';<%
			}
			%>
		}
	
		function onUpdateButton() {
			document.frmUpdate.action = "<%= contextPath %>/Community/noticeUpdate";
			
			document.frmUpdate.no.value = "<%= noticeVO.getNo()%>";
			
			document.frmUpdate.submit();
		}
		
		function onDeleteButton() {
			$.ajax({
				url: "<%= contextPath%>/Community/noticeDeletePro",
				type: "post",
				data : {
					no: <%= noticeVO.getNo()%>
				},
				dataType: "text",
				success: function(responsedData){					
					if(responsedData == "1"){
						alert('공지사항이 삭제되었습니다.');
						location.href ='<%= contextPath %>/Community/noticeList';
					}
					else {
						alert('공지사항 삭제에 실패했습니다.');
					}
				},
				error: function(error){
					console.log(error);
					alert('공지사항 삭제 통신 오류');
				}				
			});
		}
	</script>
</body>

</html>
