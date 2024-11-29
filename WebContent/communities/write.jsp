<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	String contextPath = request.getContextPath();
%>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>지역별 커뮤니티</title>
    
	<link rel="stylesheet" href="<%=contextPath%>/css/community/write.css">
	
</head>

<body>
	<div id="top_container" align="center">
		<p class="community_p1">COMMUNITY</p>
		<p class="community_p2">자유 게시판</p>
		<p>자유롭게 글을 작성해보세요</p>
	</div>
	<div id="container">
		<div class="form-container">
			<form action="<%=contextPath%>/Community/write.pro" method="post">
				<div>
					<label for="title">제목</label>
					<input type="text" id="title" name="title" placeholder="제목을 입력하세요">
					
					<label for="contents">내용</label>
					<textarea id="contents" name="contents" rows="25" placeholder="내용을 입력해주세요"></textarea>
					
					<div class="bottom_button" align="center">
						<input type="submit" value="등록">
						<!--<input type="button" value="목록" onclick="onListButton(event)">-->
						<button onclick="onListButton(event)" >목록</button>
					</div>
				</div>	
			</form>
		</div>
	</div>
		
		
	<script>
		function onListButton(event) {
			event.preventDefault();
			
			location.href='<%=contextPath%>/Community/list';
		}
	</script>
</body>
</html>