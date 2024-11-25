<%@page import="java.util.HashMap"%>
<%@page import="VOs.RecipeVO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>     
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>     

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");

	String contextPath = request.getContextPath();
	
	ArrayList<HashMap<String, Object>> wishListInfos = (ArrayList<HashMap<String, Object>>) request.getAttribute("wishListInfos");
	
	String category = (String) request.getAttribute("category");
	
	final int columnCount = 4;
	
	int totalRecipeCount = wishListInfos.size();
	
	int recipeCountPerPage = 12;
	int totalPageCount = (int) Math.ceil((double) totalRecipeCount / recipeCountPerPage);
	int currentPage = (request.getAttribute("currentPage") == null) ? 0 :
		Integer.parseInt(request.getAttribute("currentPage").toString());
	
	int pageCountPerBlock = 5;
	int totalBlockCount = (int) Math.ceil((double) totalPageCount / pageCountPerBlock);
	int currentBlock = (request.getAttribute("currentBlock") == null) ? 0 :
		Integer.parseInt(request.getAttribute("currentBlock").toString());
	
	int firstRecipeIndex = currentPage * recipeCountPerPage;
%>


<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Wish List</title>
<script>
    // 라디오 버튼 선택에 따라 목록과 제목 표시 제어
    function toggleList() {
        const selectedValue = document.querySelector('input[name="filter"]:checked').value;

        // 모든 목록과 제목을 숨김
        document.getElementById("allList").style.display = "none";
        document.getElementById("recipeList").style.display = "none";
        document.getElementById("productList").style.display = "none";
        document.getElementById("allTitle").style.display = "none";
        document.getElementById("recipeTitle").style.display = "none";
        document.getElementById("productTitle").style.display = "none";

        // 선택된 라디오 버튼에 따라 목록과 제목을 표시
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
    /* 그리드 레이아웃 설정: 4개의 항목이 한 줄에 표시되도록 설정 */
    .wishlist-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);  /* 4개의 열로 나누기 */
        gap: 20px;  /* 항목 간 간격 */
    }

    .wishlist-item {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: center;
    }

    .wishlist-item img {
        max-width: 100%;
        height: auto;
    }
</style>
</head>
<body>
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

    <!-- 전체보기 목록 -->
    <div id="allTitle" style="display: block;">
        <h2>전체보기</h2>
    </div>
    <div id="allList" style="display: block;">
        <div class="wishlist-grid">
            <c:forEach var="item" items="${wishList}">
                <div class="wishlist-item">
                    <img src="${item.thumbnail}" alt="Thumbnail" width="100" height="100" />
                    <div>${item.name} (${item.type})</div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- 레시피 목록 -->
    <div id="recipeTitle" style="display: none;">
        <h2>레시피</h2>
  <% 
    if (wishListInfos == null || wishListInfos.size() <= 0) { 
%>
        <tr>
            <td>등록된 위시리스트가 없습니다.</td>
        </tr>
<% 
    } else {
        int firstRecipeIndex = 0; // 시작 인덱스
        int recipeCountPerPage = 5; // 한 페이지당 보여줄 레시피 개수
        int totalRecipeCount = wishListInfos.size(); // 전체 위시리스트 수
        int columnCount = 3; // 한 줄에 보여줄 열 수
        
        // 페이지 나누기를 위한 for문
        for (int i = firstRecipeIndex; i < firstRecipeIndex + recipeCountPerPage; i++) {
            if (i >= totalRecipeCount) { %> </tr> <% break; }
            
            if (i % columnCount == 0) { %> <tr> <% }
            
            // 위시리스트에서 각 항목을 가져오기
            HashMap<String, Object> wishListItem = wishListInfos.get(i);
            RecipeVO recipe = (RecipeVO) wishListItem.get("recipeVO");  // RecipeVO 객체
            double rating = (double) wishListItem.get("averageRating");  // 평균 평점
            String nickname = (String) wishListItem.get("nickname");  // 사용자 닉네임
            
%>
            <td>
                <div>
                    <h3>${recipe.title}</h3>
                    <img src="${recipe.thumbnail}" alt="${recipe.title}" width="100" height="100">
                    <p>평균 평점: ${rating}</p>
                    <p>작성자: ${nickname}</p>
                </div>
            </td>

<% 
            if ((i + 1) % columnCount == 0) { %> </tr> <% }
        }
    }
%>

    <!-- 상품 목록 -->
    <div id="productTitle" style="display: none;">
        <h2>상품</h2>
    </div>
    <div id="productList" style="display: none;">
        <div class="wishlist-grid">
            <c:forEach var="item" items="${wishList}">
                <c:if test="${item.type == 'product'}">
                    <div class="wishlist-item">
                        <img src="${item.thumbnail}" alt="Thumbnail" width="100" height="100" />
                        <div>${item.name} - ${item.description}</div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>

</body>
</html>
