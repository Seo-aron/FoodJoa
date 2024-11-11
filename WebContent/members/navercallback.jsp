<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>네이버 로그인</title>
  </head>
  <body>
  <%
    String clientId = "klmdl_ht4rYoNXNwGvNg"; // 애플리케이션 클라이언트 아이디값
    String clientSecret = "v0d16oISwA"; // 애플리케이션 클라이언트 시크릿값
    String code = request.getParameter("code");
    String state = request.getParameter("state");
    String redirectURI = "http://localhost:8090/FoodJoa/members/navercallback.jsp"; // 인코딩하지 않음
    
    String apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code"
        + "&client_id=" + clientId
        + "&client_secret=" + clientSecret
        + "&redirect_uri=" + redirectURI
        + "&code=" + code
        + "&state=" + state;
    
    String accessToken = "";
    String refreshToken = "";
    
    try {
      URL url = new URL(apiURL);
      HttpURLConnection con = (HttpURLConnection) url.openConnection();
      con.setRequestMethod("GET");
      int responseCode = con.getResponseCode();
      BufferedReader br;
      
      if (responseCode == 200) { // 정상 호출
        br = new BufferedReader(new InputStreamReader(con.getInputStream()));
      } else {  // 에러 발생
        br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
      }
      
      String inputLine;
      StringBuilder res = new StringBuilder();
      while ((inputLine = br.readLine()) != null) {
        res.append(inputLine);
      }
      br.close();
      
      // JSON 응답에서 access_token 추출
      JSONObject jsonResponse = (JSONObject) new org.json.simple.parser.JSONParser().parse(res.toString());
      accessToken = (String) jsonResponse.get("access_token");
      refreshToken = (String) jsonResponse.get("refresh_token");
      
      // 액세스 토큰을 세션에 저장
      session.setAttribute("access_token", accessToken);
      session.setAttribute("refresh_token", refreshToken);
      
      // 사용자 정보 요청
      String userInfoAPI = "https://openapi.naver.com/v1/nid/me";
      URL userInfoUrl = new URL(userInfoAPI);
      HttpURLConnection userInfoCon = (HttpURLConnection) userInfoUrl.openConnection();
      userInfoCon.setRequestMethod("GET");
      userInfoCon.setRequestProperty("Authorization", "Bearer " + accessToken);
      
      BufferedReader userInfoBr;
      int userInfoResponseCode = userInfoCon.getResponseCode();
      if (userInfoResponseCode == 200) {
        userInfoBr = new BufferedReader(new InputStreamReader(userInfoCon.getInputStream()));
      } else {
        userInfoBr = new BufferedReader(new InputStreamReader(userInfoCon.getErrorStream()));
      }
      
      StringBuilder userInfoRes = new StringBuilder();
      while ((inputLine = userInfoBr.readLine()) != null) {
        userInfoRes.append(inputLine);
      }
      userInfoBr.close();
      
      // JSON 응답에서 사용자 id 추출
      JSONObject userInfoJsonResponse = (JSONObject) new org.json.simple.parser.JSONParser().parse(userInfoRes.toString());
      JSONObject responseObj = (JSONObject) userInfoJsonResponse.get("response");
      String userId = (String) responseObj.get("id");
      
      // id를 세션에 저장
      session.setAttribute("userId", userId);
      
      // 로그인 성공 후 join.jsp로 리디렉션 (id 전달)
      response.sendRedirect(request.getContextPath() + "/members/join.jsp"); 
      
    } catch (Exception e) {
      e.printStackTrace(); // 예외 발생 시 로그
      out.println("Error occurred: " + e.getMessage());
    }
  %>
  </body>
</html>
