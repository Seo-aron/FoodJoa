<%@page import="VOs.CommunityVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	String contextPath = request.getContextPath();

	CommunityVO vo = (CommunityVO) request.getAttribute("vo");
	
	String id = (String)session.getAttribute("userId");
%>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>지역별 커뮤니티</title>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>	
	
	<link rel="stylesheet" href="<%=contextPath%>/css/community/update.css">

</head>

<body>
	<div id="top_container" align="center">
		<p class="community_p1">COMMUNITY</p>
		<p class="community_p2">자유 게시판</p>
		<p>자유롭게 글을 작성해보세요</p>
	</div>
	<div id="container">
		<div class="form-container">
			<form>
				<div>
					<label for="title">제목</label>
					<input type="text" id="title" name="title" value="<%= vo.getTitle() %>">
					
					<label for="contents">내용</label>
					<textarea id="contents" name="contents" rows="25"><%= vo.getContents() %></textarea>
					
					<div class="bottom_button" align="center">
						<button onclick="onUpdateButton(event)">수정</button>
						<!--<input type="button" value="목록" onclick="onListButton(event)">-->
						<button onclick="onListButton(event)">목록</button>
					</div>
				</div>	
			</form>
		</div>
	</div>
		
		
	<script>
		function onUpdateButton(e) {
			e.preventDefault();
			
			$.ajax({
				url: "<%= contextPath %>/Community/updatePro",
				type: "post",
				data: {
					no: <%= vo.getNo() %>,
					title: $("#title").val(),
					contents: $("#contents").val(),
					views: <%= vo.getViews() %>
				},
				dataType: "text",
				success: function(responsedData) {
					
					if (responsedData == "1") {
						location.href = '<%= contextPath %>/Community/read?no=<%= vo.getNo() %>';
					}
					else {
						alert('게시글 수정을 실패 했습니다.');
					}
				},
				error: function(error) {
					console.log(error);
				}
			});
		}
	
		function onListButton(e) {
			e.preventDefault();
			location.href='<%=contextPath%>/Community/list';
		}
	</script>
</body>
</html>