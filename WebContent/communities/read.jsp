<%@page import="java.text.SimpleDateFormat"%>
<%@page import="VOs.CommunityVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
	
	CommunityVO vo = (CommunityVO)request.getAttribute("vo");
	
	String id = (String) session.getAttribute("userId");
%>
    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>작성글 읽기 및 글 수정, 삭제, 목록</title>
	
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
    
	#container {
        width: 1200px;
        margin: 0 auto;
        padding: 20px;
        background-color: #ffffff;
        border: 1px solid #e0e0e0;
        border-radius: 10px;
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
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
	
	.board-container {
	    background: #fff;
	    padding: 20px;
	    border-radius: 5px;
	    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	}
	
	h1 {
        font-size: 24px;
        font-weight: bold;
        text-align: center;
        color: #333333;
        margin-bottom: 30px;
    }
     .community_p1{
    	font-size: 40px;
    }
    
    .community_p2{
    	font-size: 30px;
    }
    
    input[type="button"],
    input[type="submit"]
    								{
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
		
	</style>
</head>

<body>
	<div id="container">
	<div id="top_container" align="center">
		<p class="community_p1">COMMUNITY</p>
		<p class="community_p2">자유게시판</p>
		<p>자유롭게 글을 작성해보세요</p>
	</div>
	<table>
		<tr>
			<td colspan="3" align="right">
				<input type="button" value="목록" id="list" onclick="onListButton()">
				<%
				if (id != null && id.equals(vo.getId())) {
					%>
					<input type="button" value="수정" id="update" onclick="onUpdateButton()">
					<input type="button" value="삭제" id="delete" onclick="onDeleteButton()">
					<%
				}
				%>
			</td>
		</tr>
		<tr>
			<td width="40%">
				제목 : <%= vo.getTitle() %>
			</td>
			<td width="45%">
				아이디 : <%= vo.getId() %>
			</td>
			<td width="15%">
				작성 날짜 :<br> <%=new SimpleDateFormat("yyyy-MM-dd").format(vo.getPostDate())%>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				내용 : <%= vo.getContents() %>
			</td>
		</tr>
		<tr>
			<td colspan="3" align="right">
				<input type="button" value="목록" id="list" onclick="onListButton()">
				<%
				if (id != null && id.equals(vo.getId())) {
					%>
					<input type="button" value="수정" id="update" onclick="onUpdateButton()">
					<input type="button" value="삭제" id="delete" onclick="onDeleteButton()">
					<%
				}
				%>
			</td>
		</tr>
	</table>
	</div>
	<form name="frmUpdate">
		<input type="hidden" name="no">
		<input type="hidden" name="id">
		<input type="hidden" name="title">
		<input type="hidden" name="contents">
		<input type="hidden" name="views">
	</form>
	
	
	<script>
		function onListButton() {
			location.href = '<%= contextPath %>/Community/list';
			
		}
	
		function onUpdateButton() {
			document.frmUpdate.action = "<%= contextPath %>/Community/update?no=<%= vo.getNo() %>";
			
			document.frmUpdate.no.value = <%= vo.getNo() %>;
			document.frmUpdate.id.value = "<%= vo.getId() %>";
			document.frmUpdate.title.value = "<%= vo.getTitle() %>";
			document.frmUpdate.contents.value = `<%= vo.getContents() %>`;
			document.frmUpdate.views.value = <%= vo.getViews()%>;
			
			document.frmUpdate.submit();
		}
		
		function onDeleteButton() {
			$.ajax({
				url: "<%= contextPath%>/Community/deletePro",
				type: "post",
				data : {
					no: <%= vo.getNo()%>
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