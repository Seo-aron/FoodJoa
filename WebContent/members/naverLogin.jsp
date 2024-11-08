<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>푸드조아 로그인</title>

    <style>
        /* 페이지 전체를 중앙 정렬 */
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            text-align: center;
        }

        .container {
            width: 1000px;
            margin: 0 auto;
        }

        #naver_id_login {
            margin-top: 10px; /* 네이버 로그인 버튼과 다른 요소들 간격 */
        }
    </style>

    <script type="text/javascript" src="https://static.nid.naver.com/js/naverLogin_implicit-1.0.3.js" charset="utf-8"></script>
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.3.min.js"></script>

</head>
<body>

    <div class="container">

        <!-- 네이버 로그인 버튼 노출 영역 -->
        <div id="naver_id_login"></div>

        <!-- 네이버 초기화 및 로그인 설정 -->
        <script type="text/javascript">
            var naver_id_login = new naver_id_login("klmdl_ht4rYoNXNwGvNg", "http://localhost:8090/FoodJoa/index.jsp");
            var state = naver_id_login.getUniqState();

            naver_id_login.setButton("white", 2, 40);
            naver_id_login.setDomain("http://localhost:8090/FoodJoa/join.jsp");
            naver_id_login.setState(state);
            naver_id_login.init_naver_id_login();

            // 네이버 로그인 성공 및 실패 처리
            naver_id_login.get_naver_userprofile("naverLoginCallback");

            function naverLoginCallback() {
                if (naver_id_login.oauthParams.access_token) {
                    console.log("네이버 로그인 성공!");
                    var naver_userid = naver_id_login.getProfileData("id");
                    var naver_username = naver_id_login.getProfileData("name");
                    console.log("네이버 사용자 ID:", naver_userid);
                    console.log("네이버 사용자 이름:", naver_username);

                    // 로그인 성공 시 페이지 이동
                    window.location.href = "/main.jsp";
                } else {
                    console.log("네이버 로그인 실패");
                }
            }
        </script>
    </div>
</body>
</html>
