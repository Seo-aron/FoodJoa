<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	request.setCharacterEncoding("UTF-8");
	response.setContentType("text/html; charset=utf-8");
	
	String contextPath = request.getContextPath();
%>

<html>
  <head>
  
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
  
  
    <title>SNS 회원가입</title>
  </head>
  <body>
	<center>
		<div id="container">
		<table width="100%">
			<tr>
				<td>
					<a href="https://nid.naver.com/oauth2.0/authorize?client_id=XhLz64aZjKhLJHJUdga6&response_type=code&redirect_uri=http://localhost:8090/FoodJoa/Member/naverlogin.me&state=YOUR_STATE">
					    <img height="50" src="<%= contextPath %>/images/member/naverlogin.png"/>
					</a>
				</td>
			</tr>
			
			<tr>
				<td>
					
				     <a href="javascript:kakaoLogin()"><img src="<%= contextPath %>/images/member/kakaologin.png">" style="width: 200px"></a>
				</td>
			</tr>
		</table>
		</div>
	</center>
  </body>
</html>
<script type="text/javascript" src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script type="text/javascript">
    Kakao.init('dfedef18f339b433884cc51b005f2b42');
    function kakaoLogin() {
        Kakao.Auth.login({
            success: function (response) {
                Kakao.API.request({
                    url: '/v2/user/me',
                    success: function (response) {
                        alert(JSON.stringify(response))
                    },
                    fail: function (error) {
                        alert(JSON.stringify(error))
                    },
                })
            },
            fail: function (error) {
                alert(JSON.stringify(error))
            },
        })
    }
</script>
