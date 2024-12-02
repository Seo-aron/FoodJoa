<%@ page import="java.util.HashMap" %>
<%@ page import="VOs.RecipeVO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=utf-8");

    String contextPath = request.getContextPath();

    // 최근 본 글 리스트 정보 받아오기
    ArrayList<HashMap<String, Object>> recentViewInfos = 
        (ArrayList<HashMap<String, Object>>) request.getAttribute("recentViewInfos");
    if (recentViewInfos == null) {
        recentViewInfos = new ArrayList<>();
    }

    // 'type' 파라미터 값을 받아서, default는 0 (레시피)로 설정
    String type = request.getParameter("type");
    if (type == null) {
        type = "0";  // 기본값: 레시피
    }

    // 데이터를 JSP 하단에서 사용 가능하도록 전달
    request.setAttribute("recentViewInfos", recentViewInfos);
    request.setAttribute("type", type); // 'type' 값을 JSP로 전달
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>최근 본 글 목록</title>
    <link href="https://fonts.googleapis.com/css2?family=Noto+Serif+KR:wght@200..900&display=swap" rel="stylesheet">
    <style>
        .container {
            width: 1200px;
            margin: 0 auto;
            font-family: "Noto Serif KR", serif;
        }
        .recent-view-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
            width: 100%;
        }
        .recent-view-item {
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            text-align: center;
            display: flex;
            align-items: center;
            padding: 10px;
        }
        .recent-view-item img {
            max-width: 150px;
            height: 150px;
            margin-right: 20px;
        }
        .recent-view-item .info {
            text-align: left;
        }
        #radio {
            margin-bottom: 20px;
        }
    </style>
    <script>
        function toggleList() {
            const selectedValue = document.querySelector('input[name="filter"]:checked').value;
            const typeHiddenField = document.getElementById("typeHidden");
            
            // '레시피'가 선택되면 0, '밀키트'가 선택되면 1
            if (selectedValue === "recipe") {
                typeHiddenField.value = "0";
            } else {
                typeHiddenField.value = "1";
            }

            // 선택된 값에 맞춰 필터링
            document.getElementById("recentViewRecipe").style.display = selectedValue === "recipe" ? "block" : "none";
            document.getElementById("recentViewMealKit").style.display = selectedValue === "product" ? "block" : "none";

            // form 제출하여 'type' 값 갱신
            document.getElementById("typeForm").submit();
        }

        window.onload = function() {
            const type = '<%= type %>';
            // 페이지 로드 시 선택된 항목에 따라 해당하는 목록만 표시
            if (type === "0") {
                document.getElementById("recentViewRecipe").style.display = "block";
                document.getElementById("recentViewMealKit").style.display = "none";
                document.getElementById("recipe").checked = true;
            } else {
                document.getElementById("recentViewRecipe").style.display = "none";
                document.getElementById("recentViewMealKit").style.display = "block";
                document.getElementById("product").checked = true;
            }
        };
    </script>
</head>
<body>
    <div id="container">
        <!-- 라디오 버튼으로 레시피와 밀키트 선택 -->
        <div id="radio">
            <h1>최근 본 글 목록</h1>
            <form id="typeForm" method="POST" action="${pageContext.request.contextPath}/Member/recentList.me">
                <!-- type 값을 전달하는 hidden 필드를 사용 -->
                <input type="hidden" id="typeHidden" name="type" value="<%= type %>">
                <input type="radio" id="recipe" name="filter" value="recipe" <%= "0".equals(type) ? "checked" : "" %> onchange="toggleList()">
                <label for="recipe">레시피</label>
                <input type="radio" id="product" name="filter" value="product" <%= "1".equals(type) ? "checked" : "" %> onchange="toggleList()">
                <label for="product">밀키트</label>
                <hr>
            </form>
        </div>

        <!-- 최근 본 레시피 목록 -->
        <div id="recentViewRecipe" class="recent-view" style="display: none;">
            <div class="recent-view-grid">
                <c:forEach var="item" items="${recentViewInfos}">
                    <c:if test="${item.recipeVO != null}">
                        <div class="recent-view-item">
                            <a href="${pageContext.request.contextPath}/Recipe/read?no=${item.recipeVO.no}&category=0&currentPage=0&currentBlock=0">
						    <img src="${pageContext.request.contextPath}/images/recipe/thumbnails/${item.recipeVO.no}/${item.recipeVO.thumbnail}" 
						         alt="${item.recipeVO.title}">
							</a>

                            <div class="info">
                                <div><b>${item.recipeVO.title}</b></div>
                                <div>작성자: ${item.nickname}</div>
                                <div>${item.recipeVO.description}</div>
                                <div>평점: ${item.averageRating}</div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>

        <!-- 최근 본 밀키트 목록 -->
        <div id="recentViewMealKit" class="recent-view" style="display: none;">
            <div class="recent-view-grid">
                <c:forEach var="item" items="${recentViewInfos}">
                    <c:if test="${item.mealkitVO != null}">
                        <div class="recent-view-item">
                            <img src="${pageContext.request.contextPath}/images/mealkit/thumbnails/${item.mealkitVO.no}/${item.mealkitVO.id}/${item.mealkitVO.pictures.substring(4)}" 
                             alt="${item.mealkitVO.title}">
                            <div class="info">
                                <div><b>${item.mealkitVO.title}</b></div>
                                <div>작성자: ${item.nickname}</div>
                                <div>가격: ${item.mealkitVO.price}</div>
                                <div>평점: ${item.avgRating}</div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>
    </div>
</body>
</html>
