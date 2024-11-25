<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%
    request.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=utf-8");
    
    String contextPath = request.getContextPath();
    
    String id = (String) session.getAttribute("userId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>밀키트 판매 게시글 작성</title>
    
    <link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/mealkit/write.css">
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
</head>
<body>
    <div id="container">
        <h2>밀키트 게시글 작성</h2>
        <form action="<%=contextPath%>/Mealkit/write.pro" method="post" id="frmWrite" enctype="multipart/form-data">
            <table border="1">
                <tr>
                    <th>글 제목</th>
                    <td><input type="text" name="title" required></td>
                </tr>
                <tr>
				    <th>사진 추가</th>
				    <td>
				        <div id="imagePreview"></div>
   						<input type="file" id="pictureFiles" name="pictureFiles" 
							accept=".jpg,.jpeg,.png" multiple onchange="handleFileSelect(this.files)">
						<button type="button" id="addFileBtn" onclick="triggerFileInput()">사진 추가</button>	
						<input type="hidden" id="pictures" name="pictures">
				    </td>
				</tr>
                <tr>
                    <th>카테고리</th>
                    <td>
                        <select name="category" required>
                        	<option value="">선택하세요</option>
                            <option value="0">한식</option>
                            <option value="1">중식</option>
                            <option value="2">일식</option>
                            <option value="3">양식</option>
                            <option value="4">분식</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>간단 소개글</th>
                    <td><textarea name="contents" rows="4" required></textarea></td>
                </tr>
                <tr>
					<th>가격</th>
				    <td><input type="text" name="price" required min="0">원</td>
				</tr>
                <tr>
                    <th>재고 수량</th>
                    <td><input type="number" name="stock" required min="0">개</td>
                </tr>
                <tr>
					<td colspan="2">
						<p>간단 조리 순서 작성</p>
						<div class="orders-container"></div>
						<p><input type="button" class="add-orders" value="순서 추가하기"></p>
						<input type="hidden" id="orders" name="orders">
					</td>
				</tr>
                <tr>
                    <th>원산지 표기</th>
                    <td><input type="text" name="origin" required></td>
                </tr>
                <tr>
                <td colspan="2">
					<input type="button" class="write" value="작성 완료" onclick="onSubmit(event, '<%=contextPath%>')">
				</td>
			</tr>
            </table>
        </form>
    </div>
    
    <script src="<%= contextPath %>/js/mealkit/write.js"></script>
</body>
</html>
