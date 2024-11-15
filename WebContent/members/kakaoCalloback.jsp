<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.net.*" %>
<%@ page import="org.json.JSONObject" %>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>카카오 로그인 처리</title>
</head>
<body>
<%
    try {
        // 카카오에서 전달된 'code'를 받아옵니다.
        String code = request.getParameter("code");
        String redirectUri = "http://localhost:8090/FoodJoa/Member/Kakaologin.me"; // 리디렉션 URI

        // 카카오 API에서 토큰을 요청할 URL
        String apiUrl = "https://kauth.kakao.com/oauth/token";

        // POST 파라미터들
        String params = "grant_type=authorization_code&client_id=dfedef18f339b433884cc51b005f2b42&redirect_uri=" + URLEncoder.encode(redirectUri, "UTF-8") + "&code=" + code;

        // 카카오 API에서 토큰을 요청하는 코드
        URL url = new URL(apiUrl);
        HttpURLConnection connection = (HttpURLConnection) url.openConnection();
        connection.setRequestMethod("POST");
        connection.setDoOutput(true);
        connection.getOutputStream().write(params.getBytes("UTF-8"));

        // 응답 상태 코드 확인
        int statusCode = connection.getResponseCode();
        if (statusCode != 200) {
            out.println("카카오 API 호출 오류: 응답 코드 " + statusCode);
            return;
        }

        // 첫 번째 응답 받기 (액세스 토큰을 얻기 위한 응답)
        BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
        StringBuilder tokenResponse = new StringBuilder(); // 변수 이름을 'tokenResponse'로 변경
        String line;
        while ((line = reader.readLine()) != null) {
            tokenResponse.append(line);
        }
        reader.close();

        // JSON 응답 처리
        JSONObject jsonResponse = new JSONObject(tokenResponse.toString());
        String accessToken = jsonResponse.getString("access_token");

        // 액세스 토큰을 사용하여 카카오 API에서 사용자 정보를 요청할 수 있습니다.
        String userInfoUrl = "https://kapi.kakao.com/v2/user/me";
        URL userInfoApiUrl = new URL(userInfoUrl);
        HttpURLConnection userInfoConnection = (HttpURLConnection) userInfoApiUrl.openConnection();
        userInfoConnection.setRequestMethod("GET");
        userInfoConnection.setRequestProperty("Authorization", "Bearer " + accessToken);

        // 두 번째 응답 받기 (사용자 정보를 얻기 위한 응답)
        BufferedReader userInfoReader = new BufferedReader(new InputStreamReader(userInfoConnection.getInputStream()));
        StringBuilder userInfoResponse = new StringBuilder(); // 변수 이름을 'userInfoResponse'로 변경
        while ((line = userInfoReader.readLine()) != null) {
            userInfoResponse.append(line);
        }
        userInfoReader.close();

        // 사용자 정보 출력
        JSONObject userJson = new JSONObject(userInfoResponse.toString());
        String nickname = userJson.getJSONObject("properties").getString("nickname");
        String email = userJson.getString("kakao_account.email");

        // 예시로 사용자 정보를 출력
        out.println("로그인 성공! 사용자 닉네임: " + nickname + ", 이메일: " + email);

    } catch (IOException e) {
        e.printStackTrace();  // 예외 처리 (예: 로그 기록)
        out.println("카카오 로그인 처리 중 오류가 발생했습니다.");
    }
%>
</body>
</html>
