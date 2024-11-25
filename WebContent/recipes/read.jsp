<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="VOs.RecipeReviewVO"%>
<%@page import="java.util.List"%>
<%@page import="Common.StringParser"%>
<%@page import="VOs.RecipeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
	
	HashMap<String, Object> recipeInfos = (HashMap<String, Object>) request.getAttribute("recipeInfos");
	
	RecipeVO recipe = (RecipeVO) recipeInfos.get("recipe");
	double averageRating = (double) recipeInfos.get("averageRating");
	String nickname = (String) recipeInfos.get("nickname");
	String profile = (String) recipeInfos.get("profile");
	ArrayList<HashMap<String, Object>> reviews = (ArrayList<HashMap<String, Object>>) recipeInfos.get("reviews");
			
	String compressedContents = recipe.getContents();
	
	ArrayList<String> reviewContents = new ArrayList<String>();
	
	String category = (String) request.getAttribute("category");
	if (category == null) category = "0";
	String currentPage = (String) request.getAttribute("currentPage");
	String currentBlock = (String) request.getAttribute("currentBlock");
	
	String id = (String) session.getAttribute("userId");
%>
    
    
<!DOCTYPE html>
<html>

<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<script src="http://code.jquery.com/jquery-latest.min.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/pako/2.1.0/pako.min.js"></script>
	<script src="<%= contextPath %>/js/common/common.js"></script>
	
	<link rel="stylesheet" href="<%=contextPath%>/css/recipe/read.css">    
</head>

<body>
	<div id="container">
		<table width="100%">
			<tr>
				<td>
					<%
					if (id != null && !id.equals("") && !id.equals(recipe.getId())) {
						%><input type="button" value="리뷰 쓰기" onclick="onReviewButton()"><%
					}
					%>
					<input type="button" value="목록" onclick="onListButton()">
					<%
					if (recipe.getId().equals(id)) {
						%>
						<input type="button" value="수정" onclick="onUpdateButton()">
						<input type="button" value="삭제" onclick="onDeleteButton()">
						<%
					}
					%>
				</td>
			</tr>
			<tr>
				<td>			
					<ul class="recipe-list">
					    <li class="profile-img">
					    	<div>
					        	<img src="<%= contextPath %>/images/member/userProfiles/<%= recipe.getId() %>/<%= profile %>">
					    	</div>
					    </li>
					    <li class="recipe-title">
					        <%= recipe.getTitle() %>
					    </li>
					    <li class="recipe-id">
					        <%= nickname %>
					    </li>
					    <li class="recipe-info">
					        <p>
					            <img src="<%= contextPath %>/images/recipe/full_star.png" class="rating-star">
					            <%= averageRating %>
					        </p>
					        <p>조회수 : <%= recipe.getViews() %></p>
					    </li>
					</ul>
				</td>	
			</tr>
			<tr>
				<td align="center">
					<div id="thumbnail">
						<img src="<%= contextPath %>/images/recipe/thumbnails/<%= recipe.getNo() %>/<%= recipe.getThumbnail() %>">
						<div id="wishlist">
							<%
							if (id != null && !id.equals("") && !id.equals(recipe.getId())) {
								%><button id="wishlist-button">레시피 찜하기</button><%
							}
							%>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td align="center">
					<div id="description">
						<%= recipe.getDescription() %>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div id="contents"></div>
				</td>				
			</tr>
			<tr>
				<td>
					<div id="ingredient">
						<p>사용한 재료</p>
						<%
						List<String> parsedIngredient = StringParser.splitString(recipe.getIngredient());
						List<String> parsedIngredientAmount = StringParser.splitString(recipe.getIngredientAmount());
						
						for (int i = 0; i < parsedIngredient.size(); i++) {
							String ingredient = parsedIngredient.get(i);
							String ingredientAmout = parsedIngredientAmount.get(i);
							%>
							<p>
								<span><%= ingredient %></span>
								<span><%= ingredientAmout %></span>
							</p>
							<%
						}
						%>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div id="orders">
						<p>조리 순서</p>
						<%
						List<String> parsedOrders = StringParser.splitString(recipe.getOrders());
					
						for (int i = 0; i < parsedOrders.size(); i++) {
							String orders = parsedOrders.get(i);
							%>
							<p>
								<span><%=orders%></span>
							</p>
							<%
						}
						%>
					</div>
				</td>
			</tr>
			<tr>
				<td align="center">
					<p>레시피 리뷰</p>
					<table width="100%" border="1">
						<%
						if (reviews == null || reviews.size() == 0) {
							%>
							<tr>
								<td align="center">등록된 리뷰가 없습니다.</td>
							</tr>						
							<%
						}
						else {
							for (int i = 0; i < reviews.size(); i++) {
								RecipeReviewVO review = (RecipeReviewVO) (reviews.get(i).get("review"));
								String reviewNickName = (String) (reviews.get(i).get("nickname"));
								%>
								<tr>
									<td rowspan="3" class="reviewer-profile" width="10%">
										<div>
											<img alt="프로필사진" src="<%= contextPath %>/images/recipe/test_thumbnail.png">
										</div>
										<div>
											<p align="center"><%= reviewNickName %></p>
										</div>
									</td>
									<td>
										<ul class="review-star">
										<%
										int rating = review.getRating();
										for (int startIndex = 1; startIndex <= 5; startIndex++) {
											String starImage = (startIndex <= rating) ? "full_star.png" : "empty_star.png";
											%>
							                <li>
							                	<img src="<%= contextPath %>/images/recipe/<%= starImage %>" alt="별점">
							                </li>
							                <%
										}
							            %>
							            </ul>
									</td>
								</tr>
								<tr>
									<td>
										<div class="review-pictures-area">
										<%
											List<String> pictures = StringParser.splitString(review.getPictures());
										
											for(String picture : pictures) {
												%>
												<div class="review-pictures">
													<img src="<%= contextPath %>/images/recipe/reviews/<%= recipe.getNo() %>/<%= review.getId() %>/<%= picture %>">
												</div>
												<%
											}
										%>
										</div>
									</td>
								</tr>
								<tr>
									<td>
										<%-- <div class="review-contents"><%= review.getContents() %></div> --%>
										<div class="review-contents">
										<% reviewContents.add(review.getContents()); %>
										</div>
									</td>
								</tr>
								<%
							}
						}
						%>
					</table>
				</td>
			</tr>
			<tr>
				<td>					
					<input type="button" value="리뷰 쓰기" onclick="onReviewButton()">
					<input type="button" value="목록" onclick="onListButton()">
					<%
					if (recipe.getId().equals(id)) {
						%>
						<input type="button" value="수정" onclick="onUpdateButton()">
						<input type="button" value="삭제" onclick="onDeleteButton()">
						<%
					}
					%>
				</td>
			</tr>
		</table>
	</div>
	
	
	<script>
		function onListButton() {
			let href = '<%= contextPath %>/Recipe/list?category=<%= category %>';
			<%
			if (currentBlock != null && currentPage != null) {
				%>
				href += '&currentPage=<%= currentPage %>&currentBlock=<%= currentBlock %>';
				<%
			}
			%>
			
			location.href = href;
		}
		
		function onReviewButton() {
			location.href = '<%= contextPath %>/Recipe/review?recipe_no=<%= recipe.getNo() %>';
		}
		
		function onUpdateButton() {
			location.href = '<%= contextPath %>/Recipe/update?no=<%= recipe.getNo() %>';
		}
		
		function onDeleteButton() {
			if (confirm("정말 레시피를 삭제 하시겠습니까?")) {
				location.href = '<%= contextPath %>/Recipe/deletePro?no=<%= recipe.getNo() %>';	
			}
		}
	
		/* id 파라미터 부분 로그인 완성 되면 수정 필요 */
		$("#wishlist-button").click(function() {
			$.ajax({
				url: "<%= contextPath %>/Recipe/wishlist",
				type: "POST",
				data: {
					id: '<%= id %>',
					recipeNo: <%= recipe.getNo() %>
				},
				dataType: "text",
				success: function(responseData, status, jqxhr) {
					if (responseData == "2") {
						alert("이미 찜 목록에 있습니다.");
					}
					else if (responseData == "1") {
						alert("찜 목록에 추가 되었습니다.");
					}
					else {
						alert("찜 목록 추가에 실패 했습니다.");
					}
				},
				error: function(xhr, status, error) {
					console.log(error);
					alert("찜 목록 추가에 실패 했습니다.");
				}
			});
		});
		
	    function initialize() {
		    var compressedData = "<%= compressedContents %>";
		    
	        try {
	            // Base64 디코딩
	            const binaryString = atob(compressedData);
	            const bytes = new Uint8Array(binaryString.length);
	            for (let i = 0; i < binaryString.length; i++) {
	                bytes[i] = binaryString.charCodeAt(i);
	            }

	            const decompressedBytes = pako.inflate(bytes);
	            
	            const decompressedText = new TextDecoder('utf-8').decode(decompressedBytes);
	            
	            document.getElementById('contents').innerHTML = decompressedText;
	        } catch (error) {
	            console.error("압축 해제 중 오류 발생:", error);
	            document.getElementById('contents').innerHTML = "내용을 표시할 수 없습니다.";
	        }
	        
	        let reviewContents = [
	            <%
	            for (int i = 0; i < reviewContents.size(); i++) {
	                String str = StringParser.escapeHtml(reviewContents.get(i));
	            %>
	                "<%= str.replace("\"", "\\\"") %>"<%= (i < reviewContents.size() - 1) ? "," : "" %>
	            <%
	            }
	            %>
	        ];
	        
	        $(".review-contents").each(function(index, element) {
				$(element).text(unescapeHtml(reviewContents[index]));
			})
	    }
	
	    // 페이지 로드 시 함수 실행
	    window.onload = initialize;
</script>
</body>

</html>