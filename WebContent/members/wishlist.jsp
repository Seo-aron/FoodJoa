<%@ page import="java.util.HashMap" %>
<%@ page import="VOs.RecipeVO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=utf-8");

    String contextPath = request.getContextPath();

    // 위시리스트 데이터 가져오기 
    ArrayList<HashMap<String, Object>> recipeInfos = 
        (ArrayList<HashMap<String, Object>>) request.getAttribute("recipeWishListInfos"); // 수정된 속성명
    if (recipeInfos == null) {
        recipeInfos = new ArrayList<>(); // 데이터가 없으면 빈 리스트로 초기화
    } 
        
        
    // 밀키트 위시리스트 데이터 가져오기 
    ArrayList<HashMap<String, Object>> mealKitInfos = 
        (ArrayList<HashMap<String, Object>>) request.getAttribute("mealKitWishListInfos"); // 밀키트 위시리스트

    if (mealKitInfos == null) {
        mealKitInfos = new ArrayList<>(); // 데이터가 없으면 빈 리스트로 초기화
    }    
    
    final int columnCount = 4; // 한 줄에 표시할 항목 수
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Wish List</title>
    <script>
        // 라디오 버튼에 따라 표시할 리스트 제어
        function toggleList() {
            const selectedValue = document.querySelector('input[name="filter"]:checked').value;

            // 모든 목록과 제목 숨기기
            document.getElementById("allList").style.display = "none";
            document.getElementById("recipeList").style.display = "none";
            document.getElementById("productList").style.display = "none";
            document.getElementById("allTitle").style.display = "none";
            document.getElementById("recipeTitle").style.display = "none";
            document.getElementById("productTitle").style.display = "none";

            // 선택된 항목 표시
            if (selectedValue === "all") {
                document.getElementById("allList").style.display = "block";
                document.getElementById("allTitle").style.display = "block";
            } else if (selectedValue === "recipe") {
                document.getElementById("recipeList").style.display = "block";
                document.getElementById("recipeTitle").style.display = "block";
            } else if (selectedValue === "product") {
                document.getElementById("productList").style.display = "block";
                document.getElementById("productTitle").style.display = "block";
            }
        }

        // 페이지 로드 시 기본값 설정
        window.onload = function() {
            toggleList();
        };
    </script>
    <style>
    	
    
    	#container {
    		width: 1200px;
    		background-color: #FFEBEE;
    	}
    
       .wishlist-grid {
		    display: grid;
		    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
		    gap: 20px;
		}
		
		.wishlist-item {
		    border: 1px solid #ddd;
		    border-radius: 5px;
		    overflow: hidden;
		    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
		    text-align: center;
		    transition: transform 0.2s ease, box-shadow 0.2s ease;
		}
		
		.wishlist-item:hover {
		    transform: translateY(-5px);
		    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
		}
		
		.wishlist-item img {
		    max-width: 100%;
		    height: auto;
		    border-bottom: 1px solid #ddd;
		}
		
		.wishlist-item div {
		    margin: 10px 0;
		}
    </style>
</head>
<body>
	<div id="container">
	    <h1>Wish List</h1>
	
	    <!-- 라디오 버튼 -->
	    <div>
	        <input type="radio" id="all" name="filter" value="all" checked onchange="toggleList()">
	        <label for="all">전체보기</label>
	
	        <input type="radio" id="recipe" name="filter" value="recipe" onchange="toggleList()">
	        <label for="recipe">레시피</label>
	
	        <input type="radio" id="product" name="filter" value="product" onchange="toggleList()">
	        <label for="product">상품</label>
	    </div>
	    <hr>
	
	    <!-- 전체보기 -->
	    <div id="allTitle" style="display: block;">
	    </div>
	    <div id="allList" style="display: block;">
	        <div class="wishlist-grid">
	            <c:forEach var="item" items="${recipeWishListInfos}">
            <c:choose>
                <c:when test="${item.recipeVO != null}">
                    <div class="wishlist-item">
                        <a href="recipeDetails.jsp?recipeNo=${item.recipeVO.no}">
                            <img src="${pageContext.request.contextPath}/images/recipe/thumbnails/${item.recipeVO.no}/${item.recipeVO.thumbnail}" 
                                 alt="${item.recipeVO.title}" />
                            <div><b>${item.recipeVO.title}</b></div>
                            <div>작성자: ${item.nickname}</div> <!-- 작성자 닉네임 -->
                            <div>평점: ${item.averageRating}</div> <!-- 평점 -->
                        </a>
                    </div>
                </c:when>
            </c:choose>
        </c:forEach>
         <c:forEach var="item" items="${mealKitWishListInfos}">
            <c:choose>
                <c:when test="${item.mealkitVO != null}">
                    <div class="wishlist-item">
                        <a href="mealKitDetails.jsp?mealKitNo=${item.mealkitVO.no}">
                            <div><b>${item.mealkitVO.title}</b></div>
                            <div>작성자: ${item.nickname}</div> <!-- 작성자 닉네임 -->
                            <div>평점: ${item.avgRating}</div> <!-- 평점 -->
                        </a>
                    </div>
                </c:when>
            </c:choose>
        </c:forEach>
	        </div>
	    </div>
	<!-- 레시피 목록 -->
<div id="recipeTitle">
</div>
<div id="recipeList">
    <div class="wishlist-grid">
        <!-- 레시피 위시리스트 정보 출력 -->
        <c:forEach var="item" items="${recipeWishListInfos}">
            <c:choose>
                <c:when test="${item.recipeVO != null}">
                    <div class="wishlist-item">
                        <a href="recipeDetails.jsp?recipeNo=${item.recipeVO.no}">
                            <img src="${pageContext.request.contextPath}/images/recipe/thumbnails/${item.recipeVO.no}/${item.recipeVO.thumbnail}" 
                                 alt="${item.recipeVO.title}" />
                            <div><b>${item.recipeVO.title}</b></div>
                            <div>작성자: ${item.nickname}</div> <!-- 작성자 닉네임 -->
                            <div>평점: ${item.averageRating}</div> <!-- 평점 -->
                        </a>
                    </div>
                </c:when>
            </c:choose>
        </c:forEach>
    </div>
</div>

<!-- 밀키트 목록 -->
<div id="productTitle">
</div>
<div id="productList">
    <div class="wishlist-grid">
        <!-- 밀키트 위시리스트 정보 출력 -->
        <c:forEach var="item" items="${mealKitWishListInfos}">
            <c:choose>
                <c:when test="${item.mealkitVO != null}">
                    <div class="wishlist-item">
                        <a href="mealKitDetails.jsp?mealKitNo=${item.mealkitVO.no}">
                            <div><b>${item.mealkitVO.title}</b></div>
                            <div>작성자: ${item.nickname}</div> <!-- 작성자 닉네임 -->
                            <div>평점: ${item.avgRating}</div> <!-- 평점 -->
                        </a>
                    </div>
                </c:when>
            </c:choose>
        </c:forEach>
    </div>
</div>
	
</body>
</html>
