<%@ page import="java.util.Map" %>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="Common.StringParser"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	
	String contextPath = request.getContextPath();
	
	String id = (String) session.getAttribute("userId");
	
	ArrayList<Map<String, Object>> list = (ArrayList<Map<String, Object>>) request.getAttribute("reviewvo");
	
	int totalRecord = 0;
	int numPerPage = 3;
	int pagePerBlock = 10;
	int totalPage = 0;
	int totalBlock = 0;
	int nowPage = 0;
	int nowBlock = 0;
	int beginPerPage = 0;
	
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
<c:set var="mealkit" value="${requestScope.mealkitvo}" />

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>리뷰</title>
	
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css">
	<link rel="stylesheet" href="<%=contextPath%>/css/mealkit/review.css">
	
</head>
<body>
	<input type="hidden" name="mealkit_no" value="${mealkit.no }" >
	<div id="review-container">
		<table class="list">
			<tr>
				<td colspan="4" class="review-h2"><h2>리뷰</h2></td>
			</tr>
		<%
		if(list.isEmpty()){
		%>
			<tr>
				<td> 등록된 리뷰가 없습니다.</td>
			</tr>
		<%
		} else{
			for(int i=beginPerPage; i<(beginPerPage+numPerPage); i++){
				if(i == totalRecord){ break; }
				
				Map<String, Object> vo = list.get(i);

				String picture = (String) vo.get("pictures");
				
				int no = (int) vo.get("no");
		        String reviewId = (String) vo.get("id");
		        int mealkitNo = (int) vo.get("mealkit_no");
			    String contents = (String) vo.get("contents");
			    int rating = (int) vo.get("rating");
			    Object postDate = vo.get("post_date");
			    String nickName = (String) vo.get("nickname");
		%>
				<tr>
					<th>작성자</th>
					<td>
						<input type="text" name="id" value="<%=nickName %>" readonly>
					</td>
					<td>
						<span>평점: <%=rating %></span>
					</td>
				</tr>
				<tr>
					<th>사진</th>
					<td colspan="3">
						<div class="contents-container">
							<img src="<%= contextPath %>/images/mealkit/reviews/<%=no %>/<%=reviewId %>/<%=picture %>" 
								class="review-image" alt="<%=picture%>">
							<textarea name="contents" class="review-contents" rows="5" required><%=contents %></textarea>
						</div>
					</td>
				</tr>
			<%
			} // for
		} // esle
		%>	
			<tr>
				<td colspan="4">
					<input type="button" value="리뷰 작성" class="review-button"
						onclick="location.href='<%=contextPath%>/Mealkit/reviewwrite?no=${mealkit.no }'">
				</td>
			</tr>
		</table>
	</div>
</body>
</html>
