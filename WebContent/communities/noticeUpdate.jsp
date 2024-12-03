<%@page import="VOs.NoticeVO"%>
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
	<title>지역별 커뮤니티</title>
    
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>	
	<link rel="stylesheet" href="<%=contextPath%>/css/community/write.css">	
</head>

<body>
	<div id="top_container" align="center">
		<p class="community_p1">NOTICE</p>
		<p class="community_p2">공지 사항</p>
	</div>
	<div id="container">
		<div class="form-container">
			<div>
				<label for="title">제목</label>
				<input type="text" id="title" name="title" placeholder="제목을 입력하세요" value="<%= noticeVO.getTitle() %>">
				
				<label for="contents">내용</label>
				<textarea id="contents" name="contents" rows="25" placeholder="내용을 입력해주세요"><%= noticeVO.getContents() %></textarea>
				
				<div class="bottom_button" align="center">
					<input type="button" value="수정" onclick="onSubmit(event)">
					<button onclick="onListButton(event)" >목록</button>
				</div>
			</div>
		</div>
	</div>
		
		
	<script>
		function onSubmit(event) {
			event.preventDefault();
			
			$.ajax({
				url: '<%= contextPath %>/Community/noticeUpdatePro',
				type: 'POST',
				async: false,
				data: {
					no: <%= noticeVO.getNo() %>,
					title: $("#title").val(),
					contents: $("#contents").val()
				},
				dateType: "text",
				success: function(responseData, status, jqxhr) {
					if (responseData == "1") {
						alert("공지사항을 수정했습니다.");
						location.href = '<%=contextPath%>/Community/noticeRead?no=<%=noticeVO.getNo()%>&nowPage=<%=nowPage%>&nowBlock=<%=nowBlock%>';
					}
					else {
						alert("공지사항 수정에 실패했습니다.");
					}
				},
				error: function(xhr, status, error) {
					console.log(error);
					alert("공지사항 수정 통신 에러");
				}
			});
		}
	
		function onListButton(event) {
			event.preventDefault();
			
			location.href='<%=contextPath%>/Community/noticeList?nowPage=<%=nowPage%>&nowBlock=<%=nowBlock%>';
		}
	</script>
</body>
</html>