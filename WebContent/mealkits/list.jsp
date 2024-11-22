<%@ page import="java.util.List"%>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="VOs.MealkitVO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html;charset=utf-8");
	
	String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>나만의 음식 판매</title>
	
	<script type="text/javascript">
		function fnSearch() {
			var word = document.getElementById("word").value;
			
			if(word == null || word == ""){
				alert("검색어를 입력하세요");
				document.getElementById("word").focus();
				
				return false;
			} else{
				document.frmSearch.submit();
			}
		}
	</script>
	<style>
	#container {
		width: 1000px;
	}
	
	.list {
		width: 1000px;
	}
	.thumbnail {
		width: 256px;
		height: 256px;
	}
	</style>
</head>
<body>
	<%
		int totalRecord = 0;
		int numPerPage = 5;
		int pagePerBlock = 3;
		int totalPage = 0;
		int totalBlock = 0;
		int nowPage = 0;
		int nowBlock = 0;
		int beginPerPage = 0;
		
		ArrayList<MealkitVO> list = (ArrayList)request.getAttribute("mealkitList");
		Map<Integer, Float> ratingAvr = (Map<Integer, Float>) request.getAttribute("ratingAvr");
		
		totalRecord = list.size();
		
		if(request.getAttribute("nowPage") != null){
			nowPage = Integer.parseInt(request.getAttribute("nowPage").toString());
		}
		
		beginPerPage = nowPage * numPerPage;
		totalPage = (int)Math.ceil((double)totalRecord / numPerPage);
		totalBlock = (int)Math.ceil((double)totalPage / pagePerBlock);
		
		if(request.getAttribute("nowBlock") != null){
			nowBlock = Integer.parseInt(request.getAttribute("nowBlock").toString());
		}
	%>
	<div id="container">
		<input type="button" id="newContent" value="글쓰기" 
			onclick="location.href='<%=contextPath%>/Mealkit/write'"/>
		<table class="list">
			<%
				if(list.isEmpty()){
					%>
					<tr>
						<td> 등록된 글이 없습니다.</td>
					</tr>
					<%
				} else{
					for(int i=beginPerPage; i<(beginPerPage+numPerPage); i++){
						if(i == totalRecord){
							break;
						}
						
						MealkitVO vo = list.get(i);
						%>
						<tr>
					        <td>
					            <a href="<%= contextPath %>/Mealkit/info?no=<%=vo.getNo()%>">
					                <span>
					                    <img class="thumbnail" src="<%= contextPath %>/images/mealkit/thumbnails/<%=vo.getNo()%>/<%=vo.getPictures()%>">
					                    작성자: <%=vo.getId() %> &nbsp;&nbsp;&nbsp;&nbsp;
					                    작성일: <%=vo.getPostDate() %> &nbsp;&nbsp;&nbsp;&nbsp;
					                    평점:  <fmt:formatNumber value="<%=ratingAvr.get(vo.getNo()) %>" pattern="#.#" />&nbsp;&nbsp;&nbsp;&nbsp;
					                    조회수: <%=vo.getViews() %>
					                </span>
					                <h3><%=vo.getTitle() %></h3>
					                <p>가격: <%=vo.getPrice() %></p>
					                <p>내용: <%=vo.getContents() %></p>
					            </a>
					        </td>
					    </tr>
						
						<%
					}
				}
			%>
			    
			<!--검색 기능 및 페이지 처리 부분-->
			<tr>
				<form action="<%=contextPath%>/Mealkit/searchlist.pro" method="post" name="frmSearch" 
				onsubmit="fnSearch(); return false;">
					<td colspan="2">
						<div id="key_select">
							<select name="key">
								<option value="title">제목</option>
								<option value="name">작성자</option>
							</select>
						</div>
					</td>
					<td>
						<div id="search_input">
							<input type="text" name="word" id="word" />
							<input type="submit" value="검색" />
						</div>
					</td>
				</form>
			</tr>
			<!--페이징-->
			<tr align="center">
				<td>
					<%
						if(totalRecord != 0){
							
							if(nowBlock > 0){
							%>
								<a href="<%=contextPath%>/Mealkit/list?nowBlock=<%=nowBlock-1%>&nowPage=<%=((nowBlock-1) * pagePerBlock)%>">
								이전 <%=pagePerBlock %>개
								</a>
							<%
							}
							
							for(int i=0; i<pagePerBlock; i++){
							%>
								&nbsp;&nbsp;
								<a href="<%=contextPath%>/Mealkit/list?nowBlock=<%=nowBlock%>&nowPage=<%=(nowBlock * pagePerBlock)+i%>">
									<%=(nowBlock * pagePerBlock)+i+1 %>
									<%
										if((nowBlock * pagePerBlock)+i+1 == totalPage){
											break;
										}
									%>
								</a>
								&nbsp;&nbsp;
							<%
							}
							
							if(totalBlock > nowBlock + 1){
							%>
								<a href="<%=contextPath%>/Mealkit/list?nowBlock=<%=nowBlock+1%>&nowPage=<%=(nowBlock + 1) * pagePerBlock%>">
									다음 <%=pagePerBlock %>개
								</a>
							<%
							}
						}
					%>
				</td>
			</tr>
		</table>
	</div>

</body>
</html>
