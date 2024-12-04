<%@page import="VOs.CommunityShareVO"%>
<%@page import="VOs.CommunityVO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="Common.StringParser"%>
<%@page import="VOs.MealkitVO"%>
<%@page import="VOs.MemberVO"%>
<%@page import="VOs.RecipeVO"%>
<%@page import="VOs.NoticeVO"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
	
	ArrayList<HashMap<String, Object>> recipes = (ArrayList<HashMap<String, Object>>) request.getAttribute("recipes");
	ArrayList<HashMap<String, Object>> mealkits = (ArrayList<HashMap<String, Object>>) request.getAttribute("mealkits");
	ArrayList<NoticeVO> notices = (ArrayList<NoticeVO>) request.getAttribute("notices");
	ArrayList<HashMap<String, Object>> communities = (ArrayList<HashMap<String, Object>>) request.getAttribute("communities");
	ArrayList<HashMap<String, Object>> shares = (ArrayList<HashMap<String, Object>>) request.getAttribute("shares");
%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"/>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bxslider@4.2.17/dist/jquery.bxslider.min.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bxslider@4.2.17/dist/jquery.bxslider.min.js"></script>	
	<link rel="stylesheet" href="<%= contextPath %>/css/includes/center.css">
	
	<script>
        
		$(function() {
			$('.bx_slider').bxSlider({
				adaptiveHeight: true,
				auto : true,
				pager : false
			});
		});
	</script>
</head>

<body>
	<div id="container">
		<div class="event_banner">
			<img src="${contextPath}/images/mainpage/main_banner.png" alt="이벤트 배너">
		</div>
		
		<div class="rank">
			<ul class="bx_slider">
				<li>
					<div class="slider-cell">
						<div class="slide-cell-header">
							<img src="${contextPath}/images/mainpage/trophy.png" alt="별모양 이미지">
							<span>레시피 BEST</span>
						</div>
						<%
						for (int i = 0; i < recipes.size(); i++) {
							RecipeVO recipeVO = (RecipeVO) recipes.get(i).get("recipeVO");
							float averageRating = (float) recipes.get(i).get("averageRating");
							MemberVO memberVO = (MemberVO) recipes.get(i).get("memberVO");
							
							int category = recipeVO.getCategory();
							String categoryStr = (category == 1) ? "[한식]" :
									(category == 2) ? "[일식]" :
									(category == 3) ? "[중식]" :
									(category == 4) ? "[양식]" : "[자취]";
							
							%>
							<div class="block-cell">
								<a href="<%= contextPath %>/Recipe/read?no=<%= recipeVO.getNo() %>">
									<div class="image-area">
										<img src="<%= contextPath %>/images/recipe/thumbnails/<%= recipeVO.getNo() %>/<%= recipeVO.getThumbnail() %>">
										<div class="rank-flag">
											<img class="rank-flag" src="${contextPath}/images/mainpage/rankflag.png">
										</div>
										<div class="rank-label"><%= i + 1 %></div>
									</div>
									<div class="label-area">
										<p>
											<%
						    					String starImage = "";
									            for (int j = 1; j <= 5; j++) {
									                if (j <= averageRating) starImage = "full_star.png";
									                else if (j > averageRating && j < averageRating + 1) starImage = "half_star.png";
									                else starImage = "empty_star.png";
									                %>
									                <img class="review_star" src="<%= contextPath %>/images/recipe/<%= starImage %>" alt="별점">
									                <%
									            }
						    					%>
										</p>
										<p><%= categoryStr %>&nbsp;<%= recipeVO.getTitle() %></p>
										<p><%= memberVO.getNickname() %></p>
									</div>
								</a>
							</div>
							<%
						}
						%>
					</div>
				</li>
				<li>
					<div class="slider-cell">
						<div class="slide-cell-header">
							<img src="${contextPath}/images/mainpage/trophy.png" alt="별모양 이미지">
							<span>스토어 BEST</span>
						</div>
						<%
						for (int i = 0; i < mealkits.size(); i++) {
							MealkitVO mealkitVO = (MealkitVO) mealkits.get(i).get("mealkitVO");
							float averageRating = (float) mealkits.get(i).get("averageRating");
							
							List<String> pictures = StringParser.splitString(mealkitVO.getPictures());
							int category = mealkitVO.getCategory();
							String categoryStr = (category == 1) ? "[한식]" :
									(category == 2) ? "[일식]" :
									(category == 3) ? "[중식]" :
									(category == 4) ? "[양식]" : "[자취]";
							%>
							<div class="block-cell">
								<a href="<%= contextPath %>/Mealkit/info?no=<%= mealkitVO.getNo() %>">
									<div class="image-area">
										<img src="<%= contextPath %>/images/recipe/thumbnails/<%= mealkitVO.getNo() %>/<%= pictures.get(0) %>">
										<div class="rank-flag">
											<img class="rank-flag" src="${contextPath}/images/mainpage/rankflag.png">
										</div>
										<div class="rank-label"><%= i + 1 %></div>
									</div>
									<div class="label-area">
										<p>
											<%
						    					String starImage = "";
									            for (int j = 1; j <= 5; j++) {
									                if (j <= averageRating) starImage = "full_star.png";
									                else if (j > averageRating && j < averageRating + 1) starImage = "half_star.png";
									                else starImage = "empty_star.png";
									                %>
									                <img class="review_star" src="<%= contextPath %>/images/recipe/<%= starImage %>" alt="별점">
									                <%
									            }
						    					%>
										</p>
										<p><%= categoryStr %>&nbsp;<%= mealkitVO.getTitle() %></p>
										<p>
											<fmt:formatNumber value="<%= mealkitVO.getPrice() %>" 
													type="currency" 
													currencySymbol="₩" 
													groupingUsed="true" 
													maxFractionDigits="0" />원
											</p>
									</div>
								</a>
							</div>
							<%
						}
						%>
					</div>
				</li>
			</ul>
		</div>
		
		<div class="board-area">
			<table width="100%">
				<tr>
					<td width="49%">
						<div class="board-notice-area">
							<div class="board-area-head">
								<label>공지사항</label>
								<span class="board-area-more">
									<a href='<%= contextPath %>/Community/noticeList'>+더보기</a>
								</span>
							</div>
							<table class="notice-table" width="100%">
								<%
								for(int i = 0; i < notices.size(); i++) {
									NoticeVO noticeVO = notices.get(i);						
									%>
									<tr>
										<td width="70%">
											<p>
												<a href="<%= contextPath %>/Community/noticeRead?no=<%= noticeVO.getNo() %>">
													<%= noticeVO.getTitle() %>
												</a>
											</p>
										</td>
										<td width="30%" align="right">
											<%= new SimpleDateFormat("yyyy-MM-dd").format(noticeVO.getPostDate()) %>
										</td>
									</tr>
									<%
								}
								%>
							</table>
						</div>
					</td>
					
					<td width="2%"></td>					
					
					<td width="49%">
						<div class="board-community-area">
							<div class="board-area-head">
								<input type="button" value="자유게시판" onclick="changeCommunityBoard(0)">
								<input type="button" value="공유게시판" onclick="changeCommunityBoard(1)">
								<span class="board-area-more">
									<a href='javascript:onBoardMoreButton()'>+더보기</a>
								</span>
							</div>
							<div class="board-free-area">
								<table class="free-table" width="100%">
									<%
									for (int i = 0; i < communities.size(); i++) {
										CommunityVO communityVO = (CommunityVO) communities.get(i).get("communityVO");
										MemberVO memberVO = (MemberVO) communities.get(i).get("memberVO");
										%>
										<tr>
											<td align="left" width="50%">
												<a href="<%= contextPath %>/Community/read?no=<%= communityVO.getNo() %>">
													<p><%= communityVO.getTitle() %></p>
												</a>
											</td>
											<td align="center" width="20%"><p><%= memberVO.getNickname() %></p></td>
											<td align="center" width="15%"><%= communityVO.getViews() %>&nbsp;views</td>
											<td align="center" width="15%">
												<%= new SimpleDateFormat("yyyy-MM-dd").format(communityVO.getPostDate()) %>
											</td>
										</tr>
										<%
									}
									%>
								</table>
							</div>
							
							<div class=board-share-area>
								<table class="share-table" width="100%">
									<%
									for (int i = 0; i < shares.size(); i++) {
										CommunityShareVO shareVO = (CommunityShareVO) shares.get(i).get("shareVO");
										MemberVO memberVO = (MemberVO) communities.get(i).get("memberVO");
										%>
										<tr>
											<td align="left" width="50%">
												<a href="<%= contextPath %>/Community/shareRead?no=<%= shareVO.getNo() %>">
													<p><%= shareVO.getTitle() %></p>
												</a>
											</td>
											<td align="center" width="20%"><p><%= memberVO.getNickname() %></p></td>											
											<td align="center" width="15%"><%= shareVO.getViews() %>&nbsp;views</td>
											<td align="center" width="15%">
												<%= new SimpleDateFormat("yyyy-MM-dd").format(shareVO.getPostDate()) %>
											</td>
										</tr>
										<%
									}
									%>
								</table>
							</div>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	
	<script>
		let categoryButtons = $(".board-area-head input");
		let boardType = 0;
		
		const categoryButtonStyles = [
	        { border: 'none', backgroundColor: '#BF917E', color: 'white' },
	        { border: '1px solid #BF917E', backgroundColor: 'white', color: '#BF917E' }
	    ];
		
		function changeCommunityBoard(type) {
			boardType = type;
			
			$('.board-free-area').css('display', type == 0 ? 'block' : 'none');
			$('.board-share-area').css('display', type == 0 ? 'none' : 'block');
	
			$.each(categoryButtons, function(index, button) {
		        var style = categoryButtonStyles[type === index ? 0 : 1];
		        $(button).css(style);
		    });
		}
		
		function onBoardMoreButton() {
			let listType = (boardType == 0) ? '/list' : '/shareList';
			
			location.href = '<%= contextPath %>/Community' + listType;
		}
		
		window.onload = changeCommunityBoard(boardType);
	</script>
</body>


</html>