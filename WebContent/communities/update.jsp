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
    
    #top_container {
        margin-bottom: 30px;
    }
    
    .community_p1{
    	font-size: 40px;
    }
    
    .community_p2{
    	font-size: 30px;
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
    
    .form-container {
        margin-top: 20px;
    }
    
    form label {
        display: block;
        font-size: 14px;
        font-weight: bold;
        color: #555555;
        margin-bottom: 5px;
    }
    
    form input[type="text"], form textarea {
        width: calc(100% - 20px);
        padding: 10px;
        border: 1px solid #cccccc;
        border-radius: 5px;
        font-size: 14px;
        color: #333333;
        background-color: #ffffff;
        margin-bottom: 20px;
    }
    
    form input[type="text"]:focus, form textarea:focus {
        border-color: #BF817E;
        box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
        outline: none;
    }
    
    form textarea {
        resize: vertical;
        height: 500px;
    }
    
    .bottom_button {
        text-align: center;
        margin-top: 20px;
    }
    
    .bottom_button input[type="submit"], .bottom_button button {
        background-color: #BF817E;
	    border: none;
	    border-radius: 5px;
	    padding: 8px 16px;
	    font-size: 1rem;
	    color: white;
	    cursor: pointer;
	    transition: background-color 0.3s ease;
    }
    
    .bottom_button input[type="submit"]:hover, .bottom_button button:hover {
        background-color: #f5f5f5;
    }

    .bottom_button input[type="submit"]:active, .bottom_button button:active {
        background-color: #e0e0e0;
    }
    
	</style>
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
	
		function onListButton(e) {
			e.preventDefault();
			location.href='<%=contextPath%>/Community/list';
		}
	</script>
</body>
</html>