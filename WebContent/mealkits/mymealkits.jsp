<%@ page import="VOs.MealkitVO"%>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.List"%>
<%@ page import="Common.StringParser"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
	
	ArrayList<HashMap<String, Object>> mealkits = (ArrayList<HashMap<String, Object>>) request.getAttribute("mealkits");
	
	String id = (String) session.getAttribute("userId");
	String nickName = (String) request.getAttribute("nickName");
%>

<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<script src="https://code.jquery.com/jquery-latest.min.js"></script>
	<link rel="stylesheet" href="<%=contextPath%>/css/mealkit/mymealkits.css">
</head>

<body>
	<div id="container">
		<h1>내 밀키트 관리</h1>
		<table width="100%">
			<%
			if (mealkits == null || mealkits.size() == 0) {
				%>
				<tr>
					<td>작성한 밀키트 상품이 없습니다.</td>
				</tr>
				<%
			}
			else {
				for(int i = 0; i < mealkits.size(); i++) {
					MealkitVO mealkitVO = (MealkitVO) mealkits.get(i).get("mealkitVO");
					
					String pictures = (String) mealkitVO.getPictures();
					List<String> picturesList = StringParser.splitString(pictures);
				    String thumbnail = picturesList.get(0);
				    
					float averageRating = (float) mealkits.get(i).get("averageRating");
					
					String priceString = mealkitVO.getPrice();
				    int price = Integer.parseInt(priceString);
				    NumberFormat numberFormat = NumberFormat.getInstance();
				    String formattedPrice = numberFormat.format(price);
					%>
					<tr>
						<td>
							<div class="mealkit-container">
								<table width="100%">
									<tr>
										<td rowspan="3" width="300px">
											<div class="mealkit-thumbnail">
												<a href="<%=contextPath%>/Mealkit/info?no=<%=mealkitVO.getNo()%>&nickName=<%=nickName%>">
													<img src="<%= contextPath %>/images/mealkit/thumbnails/<%= mealkitVO.getNo() %>/<%= thumbnail %>">
												</a>
											</div>
										</td>
										<td class="title-area" width="718px">
											<p><%= mealkitVO.getTitle() %></p>
										</td>
										<td class="rating-area" width="180px">
											<img class="rating-star" src="<%= contextPath %>/images/recipe/full_star.png">
											<%= averageRating %>
										</td>
									</tr>
									<tr>
										<td class="description-area" rowspan="2">
											<%= mealkitVO.getContents() %>
										</td>
										<td class="views-price-area">
										    <div>조회수 : <%= mealkitVO.getViews() %></div>
										    <div>가격 : <%= formattedPrice %> 원</div>
										    <div>수량 : <%=mealkitVO.getStock() %></div>
										</td>

									</tr>
									<tr>
										<td class="button-area">
											<input type="button" class="update-button" value="수정" onclick="onUpdateButton('<%= mealkitVO.getNo() %>')">
											<input type="button" class="delete-button" value="삭제" onclick="onDeleteButton('<%= mealkitVO.getNo() %>')">
										</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>					
					<%
				}
			}
			%>
		</table>
	</div>
	
	
	<script>
		function onUpdateButton(no) {
			location.href = '<%= contextPath %>/Mealkit/update?no=' + no;
		}
		
		function onDeleteButton(no) {
			if (confirm('정말로 삭제하시겠습니까?')) {
				$.ajax({
				    url: '<%= contextPath %>/Mealkit/delete.pro',
				    type: "POST",
				    data: {
				    	no: no
				    },
				    dataType: "text",
				    async: true,
				    success: function(responseData, status, jqxhr) {
						if(responseData == "1") {
							alert('밀키트를 삭제했습니다.');
							location.href = '<%= contextPath %>/Member/mypagemain.me';
						}
						else {
							alert('밀키트 삭제에 실패했습니다.');
						}
				    },
				    error: function(xhr, status, error) {
				        console.log("error", error);
						alert('통신 에러');
				    }
				});
			}
		}
	</script>
</body>

</html>