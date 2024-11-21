<%@page import="VOs.CommunityVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	String contextPath = request.getContextPath();

	CommunityVO vo = (CommunityVO) request.getAttribute("vo");
%>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>지역별 커뮤니티</title>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>	
	
	<style>
	
	/* 기본 스타일 */
	#container {
	    font-family: Arial, sans-serif;
	    background-color: #f0f0f0;
	    max-width: 800px;
	    margin: 0 auto;
	    padding: 20px;
	}
	
	/* 폼 스타일 */
	.form-container {
	    background: #fff;
	    padding: 20px;
	    border-radius: 5px;
	    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	    margin-bottom: 20px;
	}
	
	label {
	    font-weight: bold;
	}
	
	input[type="text"],textarea {
	    width: 100%;
	    padding: 8px;
	    margin-bottom: 10px;
	    border: 1px solid #ccc;
	    border-radius: 4px;
	}
	
	/* 게시판 테이블 스타일 */
	.board-container {
	    background: #fff;
	    padding: 20px;
	    border-radius: 5px;
	    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	}
	
	#areaSelect {
	}
		
	</style>
</head>

<body>
	<div id="container">
		<h1>지역별 커뮤니티 게시판</h1>
		<div class="form-container">
			<div id="areaSelect">
				<span>지역을 선택해 주세요</span>
				<select>
					<option>선택</option>
					<option>서울</option>
					<option>경기</option>
					<option>광역시</option>
					<option>기타</option>
				</select>
			</div>
			<div>
				<label for="title">제목</label>
				<input type="text" id="title" name="title" value="<%= vo.getTitle() %>">
				
				<label for="contents">내용</label>
				<textarea id="contents" name="contents" rows="25" placeholder="내용을 입력해주세요"><%= vo.getContents() %></textarea>
				
				<div class="bottom_button" align="center">
					<button onclick="onUpdateButton()" >수정</button>
					<!--<input type="button" value="목록" onclick="onListButton(event)">-->
					<button onclick="onListButton()" >목록</button>
				</div>
			</div>	
		</div>
	</div>
		
		
	<script>
		function onUpdateButton() {
			$.ajax({
				url: "<%= contextPath %>/Community/updatePro",
				type: "post",
				data: {
					no: <%= vo.getNo() %>,
					id: "<%= vo.getId() %>",
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
	
		function onListButton() {
			location.href='<%=contextPath%>/Community/list';
		}
	</script>
</body>
</html>