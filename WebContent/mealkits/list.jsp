<%@ page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html;charset=utf-8");
	
	String contextPath = request.getContextPath();
	// 검색 기능 
	// 페이징 기법
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

	<div id="container">
		<input type="button" id="newContent" value="글쓰기" 
			onclick="location.href='<%=contextPath%>/Mealkit/write'"/>
		<table class="list">
			<c:set var="i" value="0" />
			<c:forEach var="mealkit" items="${mealkitList}" varStatus="status">		
					<tr>
						<td>
							<a href="<%= contextPath %>/Mealkit/info?no=${mealkit.no}"> 
								<sapn>
								<img class="thumbnail" src="<%= contextPath %>/images/mealkit/thumbnails/${mealkit.no}/${mealkit.pictures}">
									<!--<img src="${mealkit.pictures}" alt="${mealkit.title}">-->
									작성자: ${mealkit.id } &nbsp;&nbsp;&nbsp;&nbsp;
									작성일: ${mealkit.postDate} &nbsp;&nbsp;&nbsp;&nbsp;
									평점:  <fmt:formatNumber value="${ratingAvr[mealkit.no]}" pattern="#.#" />&nbsp;&nbsp;&nbsp;&nbsp;
									조회수: ${mealkit.views}
								</sapn>
								<h3>${mealkit.title}</h3>
								<p>가격: ${mealkit.price}</p>
								<p>${mealkit.contents}</p>
							</a>
						</td>
					</tr>
			</c:forEach>
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
		</table>
	</div>

</body>
</html>
