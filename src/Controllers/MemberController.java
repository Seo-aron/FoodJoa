package Controllers;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import Services.MemberService;
@WebServlet("/Member/*")
@MultipartConfig(location = "/tmp")
public class MemberController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private MemberService memberService;
    private String nextPage;

    private String header;

    @Override
    public void init() throws ServletException {
        memberService = new MemberService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doHandle(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doHandle(request, response);
    }

    protected void doHandle(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("utf-8");
        response.setContentType("text/html; charset=utf-8");

        String action = request.getPathInfo();
        System.out.println("action : " + action);      
      
        PrintWriter out = response.getWriter();
        String nextPage = null;

        switch (action) {
            case "/join.me":
                // 회원 가입 페이지 처리
                nextPage = memberService.serviceJoinName(request);
                request.setAttribute("center", nextPage);
                nextPage = "/join.jsp";
                break;

            case "/joinIdCheck.me":
                // 아이디 중복 체크 처리
                handleIdCheck(request, response);
                return;
                
            case "/naverlogin.me" :
                // 네이버 인증 후 콜백 처리
                handleNaverLogin(request, response);
                return;  // 리디렉션 후 추가 처리하지 않도록 return

            case "/joinPro.me":
                // 회원 가입 처리
                memberService.serviceInsertMember(request);
                nextPage = "/main.jsp";
                break;
                
            case "/login.me":
                // 로그인 페이지 처리
                nextPage = memberService.serviceLoginMember();
                request.setAttribute("center", nextPage);
                nextPage = "/login.jsp";
                break;

            case "/loginPro.me":
                // 로그인 처리
                handleLoginPro(request, response);
                return; // 로그인 처리 후 바로 리턴해서 다른 처리가 진행되지 않게 한다.
            
            case "/profileupdate.me": //정보수정 페이지 요청
        	   center = memberService.profileupdate(request);
				//"members/profileupdate.jsp"
				
				//request객체에 "members/join.jsp" 중앙화면 뷰 주소 바인딩
				request.setAttribute("center", center);
				
				nextPage = "/Main.jsp";
				 
				break;
				
				
            case "/viewprofile.me": //프로필 사진 요청
            //	center = memberService.view
                
            case "/mypagemain.me":
                // 정보 수정 페이지 요청
                String center = memberService.profileupdate(request);
                request.setAttribute("center", center);
                nextPage = "/CarMain.jsp";
                break;

            case "/getUserProfile.me":
                // 사용자 프로필 정보 요청
            	handleNaverLogin(request, response);
                return;
                
            default:
                nextPage = "/main.jsp";
        }

        if (nextPage != null) {
            RequestDispatcher dispatcher = request.getRequestDispatcher(nextPage);
            dispatcher.forward(request, response);
        }
    }

    private void handleIdCheck(HttpServletRequest request, HttpServletResponse response) throws IOException {
        PrintWriter out = response.getWriter();
        boolean result = memberService.serviceOverLappedId(request);
        if (result) {
            out.write("not_usable");
        } else {
            out.write("usable");
        }
    }

    // 네이버 로그인 후 액세스 토큰 요청 및 처리
    private void handleNaverLogin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String code = request.getParameter("code");
        String state = request.getParameter("state");

        // 인증 코드가 있으면 액세스 토큰 요청
        if (code != null) {
            String clientId = "XhLz64aZjKhLJHJUdga6"; // 발급받은 Client ID
            String clientSecret = "SIITGJFkea"; // 발급받은 Client Secret

            String apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&"
                    + "client_id=" + clientId
                    + "&client_secret=" + clientSecret
                    + "&code=" + code
                    + "&state=" + state;

            // URL 연결 및 응답 코드 확인
            URL url = new URL(apiURL);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");

            int responseCode = con.getResponseCode();
            BufferedReader br = (responseCode == 200) ? 
                    new BufferedReader(new InputStreamReader(con.getInputStream())) : 
                    new BufferedReader(new InputStreamReader(con.getErrorStream()));

            String inputLine;
            StringBuffer responseContent = new StringBuffer();
            while ((inputLine = br.readLine()) != null) {
                responseContent.append(inputLine);
            }
            br.close();

            JSONObject jsonResponse = new JSONObject(responseContent.toString());
            String accessToken = jsonResponse.getString("access_token");
            handleUserProfile(accessToken);
            // Access Token 저장 후, 사용자 프로필 정보 요청
        	} else {
            response.getWriter().write("인증 실패!");
        }
    }

    // 사용자 프로필 정보 요청
    private void handleUserProfile(String accessToken) throws IOException {
     


        // 인증 헤더 생성
        String header = "Bearer " + accessToken;
        String apiURL = "https://openapi.naver.com/v1/nid/me";
        URL url = new URL(apiURL);

        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");
        con.setRequestProperty("Authorization", header);

        int responseCode = con.getResponseCode();
        BufferedReader br = (responseCode == 200) ? 
                new BufferedReader(new InputStreamReader(con.getInputStream())) : 
                new BufferedReader(new InputStreamReader(con.getErrorStream()));

        String inputLine;
        StringBuffer responseContent = new StringBuffer();
        while ((inputLine = br.readLine()) != null) {
            responseContent.append(inputLine);
        }
        br.close();

        // 사용자 프로필 정보 파싱
        JSONObject userProfile = new JSONObject(responseContent.toString()).getJSONObject("response");
       System.out.println(userProfile);
    }
    

    
}
