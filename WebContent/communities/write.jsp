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
			<form action="<%=contextPath%>/Community/write.pro" method="post">
				<div id="areaSelect">
					<span>지역을 선택해 주세요</span>
					<select>
						<option value="1">선택</option>
						<option value="2">서울</option>
						<option value="3">경기</option>
						<option value="4">광역시</option>
						<option value="5">기타</option>
					</select>
				</div>
				<div>
					<label for="title">제목</label>
					<input type="text" id="title" name="title">
					
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