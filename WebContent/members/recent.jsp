<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>최근에 본 목록</title>
<script>
    // 라디오 버튼 선택에 따라 목록 표시 제어
    function toggleList() {
        const selectedValue = document.querySelector('input[name="filter"]:checked').value;

        // 모든 목록 숨김
        document.getElementById("allList").style.display = "none";
        document.getElementById("recipeList").style.display = "none";
        document.getElementById("productList").style.display = "none";

        // 선택된 라디오 버튼에 따라 목록 표시
        if (selectedValue === "all") {
            document.getElementById("allList").style.display = "block";
        } else if (selectedValue === "recipe") {
            document.getElementById("recipeList").style.display = "block";
        } else if (selectedValue === "product") {
            document.getElementById("productList").style.display = "block";
        }
    }

    // 페이지 로드 시 기본값 설정
    window.onload = function() {
        toggleList();
    };
</script>

<style>
    /* 그리드 레이아웃 설정: 4개의 항목이 한 줄에 표시되도록 */
    .recent-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 20px;
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
    <h1>최근에 본 목록</h1>

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
    <div id="allList" style="display: block;">
        <h2>전체보기</h2>
        <div class="recent-grid">
            <c:forEach var="item" items="${recently}">
                <div class="recent-item">
                    <img src="${item.thumbnail}" alt="Thumbnail" />
                    <h3>${item.title}</h3>
                    <p>${item.description}</p>
                    <p>타입: ${item.type == 0 ? '레시피' : '상품'}</p>
                    <p>최근 본 시간: 
                        <fmt:formatDate value="${item.viewedAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                    </p>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- 레시피 목록 -->
    <div id="recipeList" style="display: none;">
        <h2>레시피</h2>
        <div class="recent-grid">
            <c:forEach var="item" items="${recently}">
                <c:if test="${item.type == 0}">
                    <div class="recent-item">
                        <img src="${item.thumbnail}" alt="Thumbnail" />
                        <h3>${item.title}</h3>
                        <p>${item.description}</p>
                        <p>최근 본 시간: 
                            <fmt:formatDate value="${item.viewedAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                        </p>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>

    <!-- 상품 목록 -->
    <div id="productList" style="display: none;">
        <h2>상품</h2>
        <div class="recent-grid">
            <c:forEach var="item" items="${recently}">
                <c:if test="${item.type == 1}">
                    <div class="recent-item">
                        <img src="${item.thumbnail}" alt="Thumbnail" />
                        <h3>${item.title}</h3>
                        <p>${item.description}</p>
                        <p>최근 본 시간: 
                            <fmt:formatDate value="${item.viewedAt}" pattern="yyyy-MM-dd HH:mm:ss" />
                        </p>
                    </div>
                </c:if>
            </c:forEach>
        </div>
    </div>
</body>
</html>
