<%@page import="VOs.CommunityVO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% 
	String contextPath = request.getContextPath();
	ArrayList<CommunityVO> communities = (ArrayList<CommunityVO>)request.getAttribute("communities");
%>  
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	#container {
		margin: 0 auto;
		width: 1200px;
	}
	
	.col-no {
		width: 5%;
	}
	
	.col-title {
		width: 30%;
	}
	
	.col-views {
		width: 5%;
	}
	
</style>
</head>
<body>
	<div id="container">
		<table border="0" width=100% cellpadding="2" cellspacing="0">
			<tr align="center" bgcolor="#99ff99">
				<td class="col-no">글번호</td>
				<td class="col-title">제목</td>
				<td>작성자</td>
				<td class="col-views">조회수</td>
				<td>작성날짜</td>
			</tr>
			
			<%
			if (communities == null || communities.size() == 0){
				
			%>
				<tr align="center">
					<td colspan="5">등록된 글이 없습니다.</td>
				</tr>
			<%
			}
			else{
				for(int i=0; i<communities.size(); i++){
					CommunityVO vo = communities.get(i); 
			%>			
				<tr>
					<td><%= vo.getNo()%></td>
					<td><%= vo.getTitle()%></td>
					<td><%= vo.getContents()%></td>
					<td><%= vo.getViews()%></td>
					<td><%= vo.getPostDate()%></td>
				</tr>
			<%
				}
			}
			%>
			</table>
				<tr>
					<form action="<%=contextPath%>/communitied/searchlist"
						  method="post"
						  name="frmSearch" onsubmit="fnSearch(); return false;">
						<td colspan="2">
							<div align="left">
								<select>
									<option value="titleContent">제목+내용</option>								
									<option value="titleContent">작성자</option>								
								</select>
							</div>
						<td width="50%">
							<div align="center">
								<input type="text" name="word" id="word" placeholder="검색어를 입력해주세요"/>
								<input type="submit" value="검색"/>
							</div>
						</td>
					</form>
					
					<td width="40%" style="text-align:left">
				</tr>
</body>
</html>
















