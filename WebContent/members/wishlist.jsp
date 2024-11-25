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
    ArrayList<HashMap<String, Object>> wishListInfos = 
        (ArrayList<HashMap<String, Object>>) request.getAttribute("wishList");
    if (wishListInfos == null) {
        wishListInfos = new ArrayList<>(); // 데이터가 없으면 빈 리스트로 초기화
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
        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr); /* 4개의 열로 나누기 */
            gap: 20px; /* 항목 간 간격 */
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

    <!-- 전체보기 -->
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
    </div>
    <div id="recipeList" style="display: none;">
        <table class="list_table">
            <%
            if (wishListInfos.isEmpty()) {
            %>
                <tr>
                    <td colspan="<%= columnCount %>">등록된 레시피가 없습니다.</td>
                </tr>
            <%
            } else {
                for (int i = 0; i < wishListInfos.size(); i++) {
                    if (i % columnCount == 0) {
            %>
                <tr> <!-- 새로운 행 시작 -->
            <%
                    }

                    // 레시피 정보 추출
                    HashMap<String, Object> recipeData = wishListInfos.get(i);
                    RecipeVO recipe = (RecipeVO) recipeData.get("recipeVO");
                    double rating = (double) recipeData.get("averageRating");
            %>
                    <td class="wishlist-item">
                        <a href="recipeDetails.jsp?recipeNo=<%= recipe.getNo() %>">
                            <img src="<%= contextPath %>/images/recipe/thumbnails/<%= recipe.getNo() %>/<%= recipe.getThumbnail() %>" 
                                 alt="Thumbnail">
                            <div><b><%= recipe.getTitle() %></b></div>
                            <div>작성자: <%= recipe.getId() %></div>
                            <div>평점: <%= String.format("%.1f", rating) %></div>
                        </a>
                    </td>
            <%
                    if ((i + 1) % columnCount == 0 || i == wishListInfos.size() - 1) {
            %>
                </tr> <!-- 현재 행 종료 -->
            <%
                    }
                }
            }
            %>
        </table>
    </div>

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
