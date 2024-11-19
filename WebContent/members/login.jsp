<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	
	String contextPath = request.getContextPath();
%>

  <style>
    #container {
            text-align: center;
            background-color: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
    img {
            width: auto;
            height: 50px;
        }
  
  </style>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>푸드조아 로그인</title>
</head>
<body>
	


<center>
		<div id="container">
		<table width="100%">
		<h2>푸드조아 로그인</h2>
			<tr>
				<td>
					<a href="https://nid.naver.com/oauth2.0/authorize?client_id=XhLz64aZjKhLJHJUdga6&response_type=code&redirect_uri=http://localhost:8090/FoodJoa/Member/naverlogin.me&state=YOUR_STATE">
					    <img height="50" src="<%= contextPath %>/images/member/naverlogin.png"/>
					</a>
				</td>
			</tr>
			
			<tr>
				<td>
					
				     <a href="https://kauth.kakao.com/oauth/authorize?response_type=code&client_id=dfedef18f339b433884cc51b005f2b42&redirect_uri=http://localhost:8090/FoodJoa/Member/kakaologin.me">
						<img src="<%= contextPath %>/images/member/kakaologin.png" style="width: 200px">
					</a>
				</td>
			</tr>
		</table>
		</div>
	</center>
	<%-- alertMessage가 있으면 알림창 띄우기 --%>
<%
    String alertMessage = (String) request.getAttribute("alertMessage");
    if (alertMessage != null) {
%>
        <script type="text/javascript">
            alert("<%= alertMessage %>");
            location.href = "<%= request.getContextPath() %>/Member/join.me"; // 회원가입 페이지로 리디렉션
        </script>
<%
    }
%>

</body>
</html>