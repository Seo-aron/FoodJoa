<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>최근에 본</title>
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
    .recent-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);  /* 4개의 열로 나누기 */
        gap: 20px;  /* 항목 간 간격 */
    }

    .recent-item {
        border: 1px solid #ddd;
        padding: 10px;
        text-align: center;
    }

    .recent-item img {
        max-width: 100%;
        height: auto;
    }
</style>
</head>
<body>
    <h1>Recently seen</h1>

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
        <div class="recently-grid">
            <c:forEach var="item" items="${recently}">
                <div class="recently-item">
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
        <div class="recently-grid">
            <c:forEach var="item" items="${recently}">
                <c:if test="${item.type == 'recipe'}">
                    <div class="recently-item">
                        <img src="${item.thumbnail}" alt="Thumbnail" width="100" height="100" />
                        <div>${item.name} - ${item.description}</div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>

    <!-- 상품 목록 -->
    <div id="productTitle" style="display: none;">
        <h2>상품</h2>
    </div>
    <div id="productList" style="display: none;">
        <div class="recently-grid">
            <c:forEach var="item" items="${recently}">
                <c:if test="${item.type == 'product'}">
                    <div class="recently-item">
                        <img src="${item.thumbnail}" alt="Thumbnail" width="100" height="100" />
                        <div>${item.name} - ${item.description}</div>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>


</body>
</html>