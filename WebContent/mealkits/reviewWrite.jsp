<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	
	String contextPath = request.getContextPath();
	// 작성자 명 
    String nickname = (String) session.getAttribute("nickname");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>리뷰 작성</title>
    
    <script src="https://code.jquery.com/jquery-latest.min.js"></script>
    <script>
		let ratingValue = 0;
       	let empathValue = 0;
       	
		// 평점 
        function setRating(value) {
            ratingValue = value;
            $('#ratingInput').val(value);
            $('.rating_button').removeClass('selected');
            for (let i = 1; i <= value; i++) {
                $('#rating' + i).addClass('selected');
            }
        }
		
        // 작성 취소 버튼 
        function confirmCancel() {
            if (confirm("정말 취소하겠습니까?")) {
                history.back();
            }
        }
        // 공감 
        function empathyCount() {
			
		}
    </script>
    <style>
        .rating-button {
            display: inline-block;
            width: 30px;
            height: 30px;
            background-color: lightgray;
            text-align: center;
            line-height: 30px;
            cursor: pointer;
            margin-right: 5px;
        }
        .rating-button.selected {
            background-color: gold;
        }
    </style>
</head>
<body>
    <div id="container">
        <h2>리뷰 작성</h2>
        <form action="<%=contextPath %>/Mealkit/reviewwrite.pro" method="post">
            <table>
                <tr>
                    <th>작성자</th>
                    <td>
                        <input type="text" name="id" value="user2" readonly>
                    </td>
                    <td>
                        평점:
                        <div id="rating_buttons">
                            <div class="rating_button" id="rating1" onclick="setRating(1)">1</div>
                            <div class="rating_button" id="rating2" onclick="setRating(2)">2</div>
                            <div class="rating_button" id="rating3" onclick="setRating(3)">3</div>
                            <div class="rating_button" id="rating4" onclick="setRating(4)">4</div>
                            <div class="rating_button" id="rating5" onclick="setRating(5)">5</div>
                        </div>
                        <input type="hidden" name="rating" value="" id="ratingInput">
                    </td>
                    <td>
                        <button type="button" onclick="empathyCount()">공감</button>
                    </td>
                </tr>
                <tr>
                    <th>사진</th>
                    <td colspan="3">
                        <input type="file" name="pictures" accept="image/*" required>
                    </td>
                </tr>
                <tr>
                    <th>내용</th>
                    <td colspan="3">
                        <textarea name="contents" rows="5" style="width: 100%;" required></textarea>
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <button type="submit">작성</button>
                        <button type="button" onclick="confirmCancel()">취소</button>
                    </td>
                </tr>
            </table>
            <input type="hidden" name="rating" value="" id="ratingInput">
        </form>
    </div>
</body>
</html>