<%@ page import="java.util.List"%>
<%@ page import="java.util.Map" %>
<%@ page import="Common.StringParser"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="VOs.MealkitVO" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html;charset=utf-8");
	
	String contextPath = request.getContextPath();
	
	int category = (int) request.getAttribute("category");
	String strCategory = null;
	
	if(category == 0){ strCategory = "전체 밀키트 게시글"; }
	else if (category == 1){ strCategory = "한식 밀키트 게시글"; }
	else if (category == 2){ strCategory = "일식 밀키트 게시글"; }
	else if (category == 3){ strCategory = "중식 밀키트 게시글"; }
	else if (category == 4){ strCategory = "양식 밀키트 게시글"; }
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>나만의 음식 판매</title>
	
	<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/mealkit/list.css">
	
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
		
		ArrayList<Map<String, Object>> list = (ArrayList<Map<String, Object>>) request.getAttribute("mealkitList");
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
		<!-- 검색 기능 -->
		<h1><%=strCategory %></h1>
		<div id="search-container">
			<form action="<%=contextPath%>/Mealkit/searchlist.pro" method="post" name="frmSearch" 
				onsubmit="fnSearch(); return false;">
				 <div class="search-form-container">
		            <select name="key">
		                <option value="title">밀키트 명</option>
		                <option value="name">작성자</option>
		            </select>
		            
		            <input type="text" name="word" id="word" />
		            <input type="submit" value="검색" />
		        </div>
			</form>
				<!-- 글쓰기 -->
			<c:if test="${not empty sessionScope.userId}">
				<input type="button" id="newContent" value="글쓰기" 
					onclick="location.href='<%=contextPath%>/Mealkit/write'"/>
			</c:if>
		</div>
		
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
					Map<String, Object> vo = list.get(i);

				    // "pictures" 키로 문자열 가져오기
				    String pictures = (String) vo.get("pictures");
					List<String> picturesList = StringParser.splitString(pictures);
				    String thumbnail = picturesList.get(0);
				    
				    int no = (int) vo.get("no");
			        String id = (String) vo.get("id");
			        String title = (String) vo.get("title");
			        String contents = (String) vo.get("contents");
			        Object postDate = vo.get("post_date");
			        int views = (int) vo.get("views");
			        String nickName = (String) vo.get("nickname");
			        
			        String price = (String) vo.get("price");
					int price_ = Integer.parseInt(price); 
					NumberFormat numberFormat = NumberFormat.getInstance();
					String formattedPrice = numberFormat.format(price_);
					%>
				<tr>
			        <td>
			            <a href="<%=contextPath%>/Mealkit/info?no=<%=no%>&nickName=<%=nickName%>">
				            <span>
				                <img class="thumbnail" 
				                     src="<%=contextPath%>/images/mealkit/thumbnails/<%=no%>/<%=id%>/<%=thumbnail%>">
				                작성자: <%=nickName%> &nbsp;&nbsp;&nbsp;&nbsp;
				                작성일: <%=postDate%> &nbsp;&nbsp;&nbsp;&nbsp;
				                평점: <fmt:formatNumber value="<%=ratingAvr.get(no)%>" pattern="#.#" /> &nbsp;&nbsp;&nbsp;&nbsp;
				                조회수: <%=views%>
				            </span>
				            <h3><%=title%></h3>
				            <p>가격: <%=formattedPrice%> 원</p>
				            <p>내용: <%=contents%></p>
				            <br>
			        </td>
			    </tr>
						
				<%
				} // for
			} // esle
			%>			    
			<!--페이징-->
			<tr align="center">
				<td>
					<%
						if(totalRecord != 0){
							
							if(nowBlock > 0){
							%>
								<a href="<%=contextPath%>/Mealkit/list?nowBlock=<%=nowBlock-1%>&nowPage=<%=((nowBlock-1) * pagePerBlock)%>">
								이전
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
									다음
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
