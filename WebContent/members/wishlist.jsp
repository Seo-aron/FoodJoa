<%@ page import="java.util.HashMap" %>
<%@ page import="VOs.RecipeVO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=utf-8");

    String contextPath = request.getContextPath();

    ArrayList<HashMap<String, Object>> recipeInfos = 
        (ArrayList<HashMap<String, Object>>) request.getAttribute("recipeWishListInfos");
    if (recipeInfos == null) {
        recipeInfos = new ArrayList<>();
    } 

    ArrayList<HashMap<String, Object>> mealKitInfos = 
        (ArrayList<HashMap<String, Object>>) request.getAttribute("mealKitWishListInfos");
    if (mealKitInfos == null) {
        mealKitInfos = new ArrayList<>();
    }

    // 데이터를 JSP 하단에서 사용 가능하도록 전달
    request.setAttribute("recipeWishListInfos", recipeInfos);
    request.setAttribute("mealKitWishListInfos", mealKitInfos);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Wish List</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
    <style>
        /* 스타일 정의 그대로 유지 */
        .container {
            width: 1200px;
            margin: 0 auto;
            font-family: "Noto Serif KR", serif;
        }
        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            width: 100%;
        }
        .wishlist-item {
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            text-align: center;
            display: flex;
            align-items: center;
            padding: 10px;
        }
        .wishlist-item img {
            max-width: 150px;
            height: 150px;
            margin-right: 20px;
        }
        .wishlist-item .info {
            text-align: left;
        }
        #radio {
            margin-bottom: 20px;
        }
    </style>
    <script>
        function toggleList() {
            const selectedValue = document.querySelector('input[name="filter"]:checked').value;
            document.getElementById("wishListRecipe").style.display = selectedValue === "recipe" ? "block" : "none";
            document.getElementById("wishListMealKit").style.display = selectedValue === "product" ? "block" : "none";
        }
        window.onload = function() {
            document.getElementById("wishListRecipe").style.display = "block";
            document.getElementById("wishListMealKit").style.display = "none";
            document.getElementById("recipe").checked = true;
        };
    </script>
</head>
<body>
    <div id="container">
        <!-- 기존 라디오 버튼 및 제목 유지 -->
        <div id="radio">
            <h1>Wish List</h1>
            <input type="radio" id="recipe" name="filter" value="recipe" checked onchange="toggleList()">
            <label for="recipe">레시피</label>
            <input type="radio" id="product" name="filter" value="product" onchange="toggleList()">
            <label for="product">상품</label>
            <hr>
        </div>

        <!-- 기존 레시피 및 밀키트 위시리스트 유지 -->
        <!-- 레시피 위시리스트 -->
        <div id="wishListRecipe" class="wishList">
            <div class="wishlist-grid">
                <c:forEach var="item" items="${recipeWishListInfos}">
                    <div class="wishlist-item">
						<a href="<%= request.getContextPath() %>/Recipe/read?no=${item.recipeVO.no}">
						    <img src="<%= request.getContextPath() %>/images/recipe/thumbnails/${item.recipeVO.no}/${item.recipeVO.thumbnail}" 
						         alt="${item.recipeVO.title}">
						</a>

                        <div class="info">
                            <div><b>${item.recipeVO.title}</b></div>
                            <div>작성자: ${item.nickname}</div>
                            <div>${item.recipeVO.description}</div>
                            <div>평점: ${item.averageRating}</div>
                           <form action="<%= request.getContextPath() %>/Member/deleteWishRecipe.me" method="post" onsubmit="return confirm('정말로 삭제하시겠습니까?');">
							    <input type="hidden" name="recipeNo" value="${item.recipeVO.no}">
							    <input type="hidden" name="userId" value="${sessionScope.userId}"> <!-- userId로 이름을 수정 -->
							    <button type="submit">삭제</button>
							</form>

                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 밀키트 위시리스트 -->
        <div id="wishListMealKit" class="wishList" style="display: none;">
            <div class="wishlist-grid">
                <c:forEach var="item" items="${mealKitWishListInfos}">
                    <div class="wishlist-item">
                    <a href="<%= request.getContextPath() %>/Mealkit/info?no=${item.mealkitVO.no}">
                     <img src="<%= request.getContextPath() %>/images/mealkit/thumbnails/${item.mealkitVO.no}/${item.mealkitVO.id}/${item.mealkitVO.pictures.substring(4)}" 
                             alt="${item.mealkitVO.title}">
                             </a>
                        <div class="info">
                            <div><b>${item.mealkitVO.title}</b></div>
                             <p>no: ${item.mealkitVO.id}</p>
                            <div>작성자: ${item.nickname}</div>
                            <div>가격: ${item.mealkitVO.price}</div>
                            <div>평점: ${item.avgRating}</div>
                             <form action="<%= request.getContextPath() %>/Member/deleteWishMealkit.me" method="post" onsubmit="return confirm('정말로 삭제하시겠습니까?');">
							    <input type="hidden" name="mealkitNo" value="${item.mealkitVO.no}">
							    <input type="hidden" name="userId" value="${sessionScope.userId}"> <!-- userId로 이름을 수정 -->
							     <input type="submit" value="삭제" class="btn" style="background-color: #BF917E;">
							</form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>
</body>
</html>
