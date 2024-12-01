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
        document.getElementById("wishListRecipe").style.display = "none";
        document.getElementById("wishListMealKit").style.display = "none";
;

        // 선택된 항목 표시
        if (selectedValue === "recipe") {
            document.getElementById("wishListRecipe").style.display = "block";  // 레시피 목록 보이기
        } else if (selectedValue === "product") {
            document.getElementById("wishListMealKit").style.display = "block"; // 밀키트 목록 보이기
        }
    }

    // 페이지 로드 시 기본값 설정
    window.onload = function() {
        // 기본적으로 레시피 목록만 표시하도록 설정
        document.getElementById("wishListRecipe").style.display = "block";
        // 밀키트 목록은 숨기기
        document.getElementById("wishListMealKit").style.display = "none";

        // 레시피 라디오 버튼이 체크되도록 설정
        document.getElementById("recipe").checked = true;
    };
</script>

<!DOCTYPE html>
<html>
<head>
 <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
    <meta charset="UTF-8">
    <title>Wish List</title>
    <style>
    /* #container는 기본적으로 flexbox가 아닌 기본 레이아웃 유지 */
    .container {
        width: 1200px;
        margin: 0 auto; /* 가운데 정렬 */
        font-family: "Noto Serif KR", serif;
    }

    .wishlist-grid {
        display: grid;
        grid-template-columns: repeat(2, 1fr); /* 두 개의 항목을 나란히 배치 */
        gap: 25px; /* 항목 간의 간격 */
        width: 100%;
        font-family: "Noto Serif KR", serif;
    }

    /* wishlist-item에만 flexbox 적용 */
    .wishlist-item {
        border: 1px solid #ddd;
        border-radius: 5px;
        overflow: hidden;
        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        text-align: center;
        transition: transform 0.2s ease, box-shadow 0.2s ease;
        display: flex; /* Flexbox를 사용하여 아이템을 가로로 배치 */
        align-items: center; /* 세로로 가운데 정렬 */
        padding: 10px;
        font-family: "Noto Serif KR", serif;
    }
    
    h1{
    font-family: "Noto Serif KR", serif;}

    .wishlist-item:hover {
        transform: translateY(-5px);
        box-shadow: 0 4px 10px rgba(0, 0, 0, 0.2);
    }

    .wishlist-item img {
        max-width: 150px; /* 이미지 크기 조정 */
        height: 150px;
        margin-right: 20px; /* 이미지와 텍스트 사이의 간격 */
    }

    .wishlist-item .info {
        text-align: left; /* 텍스트를 왼쪽 정렬 */
    }

    .wishlist-item .info div {
        margin-bottom: 10px;
    }

    /* radio 관련 스타일은 기본 레이아웃으로 유지 */
    #radio {
        margin-bottom: 20px;
        font-family: "Noto Serif KR", serif;
    }
</style>

<div id="container">
    <!-- 라디오 버튼과 제목을 담고 있는 div -->
    <div id="radio">
        <h1>Wish List</h1>
        <input type="radio" id="recipe" name="filter" value="recipe" checked onchange="toggleList()">
        <label for="recipe">레시피</label>

        <input type="radio" id="product" name="filter" value="product" onchange="toggleList()">
        <label for="product">상품</label> 
        <hr> <!-- 구분선 -->
    </div>
    
    <!-- 레시피 목록을 보여주는 div -->
    <div id="wishListRecipe" class="wishList">
        <div class="wishlist-grid">
            <c:forEach var="item" items="${recipeWishListInfos}">
                <c:choose>
                    <c:when test="${item.recipeVO != null}">
                        <div class="wishlist-item">
                            <!-- 이미지 왼쪽에 배치 -->
                            <a href="${pageContext.request.contextPath}/recipes/list.jsp?recipeNo=${item.recipeVO.no}">
                                <img src="${pageContext.request.contextPath}/images/recipe/thumbnails/${item.recipeVO.no}/${item.recipeVO.thumbnail}" 
                                     alt="${item.recipeVO.title}" />
                            </a>

                            <!-- 텍스트 정보 오른쪽에 배치 -->
                            <div class="info">
                                <div id="title"><b>${item.recipeVO.title}</b></div>
                                <div id="nickname">작성자: ${item.nickname}</div> <!-- 작성자 닉네임 -->
                                <div id="contents">간단소개: ${item.contents}</div>
                                <div id="averageRating">평점: ${item.averageRating}</div> <!-- 평점 -->
                            </div>
                            
                                    <!-- 삭제 버튼 추가 -->
                        <form action="<%= request.getContextPath() %>/Member/deleteWishRecipe.me" method="GET">
                            <input type="hidden" name="recipeNo" value="${item.recipeVO.no}">
                            <button type="submit" class="delete-btn">삭제</button>
                        </form>
                        </div>
                    </c:when>
                </c:choose>
            </c:forEach>
        </div>
    </div>

    <!-- 밀키트 목록을 보여주는 div -->
    <div id="wishListMealKit" class="wishList" style="display:none;">
        <div class="wishlist-grid">
            <c:forEach var="item" items="${mealKitWishListInfos}">
                <c:choose>
                    <c:when test="${item.mealkitVO != null}">
                        <div class="wishlist-item">
                            <!-- 이미지 왼쪽에 배치 -->
                            <%-- <a href="mealKitDetails.jsp?mealKitNo=${item.mealkitVO.no}">
                                <img src="${pageContext.request.contextPath}/images/mealkit/thumbnails/${item.mealkitVO.no}/${item.mealkitVO.thumbnail}" 
                                     alt="${item.mealkitVO.title}" />
                            </a>
 --%>
                            <!-- 텍스트 정보 오른쪽에 배치 -->
                            <div class="info">
                                <div><b>${item.mealkitVO.title}</b></div>
                                <div>작성자: ${item.nickname}</div> <!-- 작성자 닉네임 -->
                                <div>평점: ${item.avgRating}</div> <!-- 평점 -->
                            </div>
                            
                       
                        </div>
                    </c:when>
                </c:choose>
            </c:forEach>
        </div>
    </div>
</div>
</body>
</html>