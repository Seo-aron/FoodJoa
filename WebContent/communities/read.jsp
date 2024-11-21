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
	
	.board-container {
	    background: #fff;
	    padding: 20px;
	    border-radius: 5px;
	    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
	}
		
	</style>
</head>

<body>
	<table>
		<tr>
			<td colspan="3">
				<input type="button" value="목록" id="list" onclick="onListButton()">
				<%
				if (id != null && id.equals(vo.getId())) {
					%>
					<input type="submit" value="수정" id="update" onclick="onUpdateButton()">
					<input type="submit" value="삭제" id="delete" onclick="onDeleteButton()">
					<%
				}
				%>
			</td>
		</tr>
		<tr>
			<td>
				<%= vo.getTitle() %>
			</td>
			<td>
				<%= vo.getId() %>
			</td>
			<td>
				<%= vo.getPostDate() %>
			</td>
		</tr>
		<tr>
			<td colspan="3">
				<%= vo.getContents() %>
			</td>
		</tr>
		<tr>
			<td colspan="3">
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
			document.frmUpdate.contents.value = "<%= vo.getContents() %>";
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