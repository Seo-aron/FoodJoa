import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;
/*
3. 토큰 요청 및 사용자 정보 요청
토큰을 요청하는 서블릿에서는 받은 Authorization Code로 Access Token을 요청하고, 
그 토큰으로 사용자 프로필 정보를 가져옵니다.


이  TokenRequestServlet은 
네이버 로그인 API를 통해 인증 코드를 사용해 Access Token을 요청하고 
이를 세션에 저장하는 역할을 합니다.
 
*/
@WebServlet("/members/tokenRequestServlet")
public class TokenRequestServlet extends HttpServlet {
	/*
	HttpServlet은 Java에서 HTTP 프로토콜을 통해 
	클라이언트와의 통신을 쉽게 처리할 수 있도록 기본 기능을 제공하는 클래스입니다.
	*/
	
	
//	이 메서드가 호출되면 클라이언트로부터 인증 코드를 받아 네이버에 Access Token을 요청합니다.
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       
/*
요청에서 인증 코드와 상태값 가져오기
	code: 네이버 인증 서버가 로그인 과정에서 클라이언트로 전달하는 일회용 인증 코드입니다.
	      Access Token을 얻기 위해 필수로 필요합니다.
	state: CSRF(Cross-Site Request Forgery) 공격을 막기 위해 사용하는 상태값입니다. 
	       클라이언트가 로그인 요청을 보낼 때 생성해 보내고, 다시 돌려받아 일치하는지 확인하는 값입니다.
*/
    	String code = request.getParameter("code"); // 네이버가 보내준 인증 코드
        String state = request.getParameter("state"); // CSRF 방지를 위한 상태값

       
        String clientId = "XhLz64aZjKhLJHJUdga6"; // 발급받은 Client ID
        String clientSecret = "SIITGJFkea"; // 발급받은 Client Secret

//API URL 구성하기   
/*
apiURL은 네이버 서버에 Access Token을 요청하기 위한 URL입니다.
각 파라미터의 의미:
	grant_type=authorization_code: 네이버 서버에 인증 코드 방식을 사용해 요청하고 있음을 알림.
	client_id와 client_secret: 요청이 유효한 애플리케이션으로부터 온 것임을 확인.
	code와 state: 각각 인증 코드와 상태값으로, 인증 완료 여부와 요청의 유효성을 확인하기 위해 사용.
*/
        String apiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code&"
                + "client_id=" + clientId
                + "&client_secret=" + clientSecret
                + "&code=" + code
                + "&state=" + state;

// HttpURLConnection으로 Access Token 요청
/*        
        URL 객체 생성
	        URL 객체는 apiURL 문자열을 네이버 서버로의 연결 정보로 변환해 줍니다.
	        url 변수는 네이버 서버와의 연결을 설정할 때 사용됩니다.
*/	        
        URL url = new URL(apiURL);
  
//서버 연결 객체 생성 및 초기화
/*        
        HttpURLConnection 객체를 사용해 실제 서버와의 연결을 열 수 있습니다. 
        여기서 openConnection() 메서드는 URL 객체에 설정된 apiURL에 연결할 준비를 합니다.
*/      
        HttpURLConnection con = (HttpURLConnection) url.openConnection();

//HTTP 요청 방식 설정
/*        
        con.setRequestMethod("GET"): 이 코드가 서버에 요청을 보낼 때 GET 방식을 사용하도록 지정합니다.
        GET 요청은 주로 데이터를 서버에서 가져오는 데 사용됩니다.        
*/        
        con.setRequestMethod("GET");

        
//응답 코드 확인
/*        
        responseCode: 서버로부터 받은 응답 코드입니다.
        응답 코드가 200이면 성공적으로 Access Token을 요청한 것이고, 다른 코드(예: 400, 500 등)는 요청이 실패했음을 의미합니다.
*/        
        int responseCode = con.getResponseCode();
  
//응답 내용 읽기 준비
/*        
        responseCode가 200이면 성공한 것으로, con.getInputStream()을 통해 서버로부터 실제 응답 데이터를 읽습니다.
        에러가 발생했다면 con.getErrorStream()을 통해 에러 내용을 읽어옵니다.
*/       
        BufferedReader br = (responseCode == 200) ? new BufferedReader(new InputStreamReader(con.getInputStream()))
                                                 : new BufferedReader(new InputStreamReader(con.getErrorStream()));
//응답 데이터 읽기
/*        
        while 루프를 사용해 서버의 응답 데이터를 한 줄씩 읽습니다.
        responseContent에 모든 데이터를 담아둡니다. 
        예를 들어, 서버가 JSON 형식의 데이터를 반환하면 responseContent에 JSON 데이터가 저장됩니다.
        모든 데이터를 읽은 후 br.close()로 BufferedReader를 닫아 메모리를 해제합니다.        
 */ 
        String inputLine;
        StringBuffer responseContent = new StringBuffer();
        while ((inputLine = br.readLine()) != null) {
            responseContent.append(inputLine);
        }
        br.close();

//응답 데이터를 JSON 객체로 변환
/*        
        responseContent에 저장된 JSON 형식의 응답 데이터를 JSONObject로 변환해 파싱합니다.
        JSONObject를 사용하면 JSON에서 원하는 값을 쉽게 추출할 수 있습니다.
*/        
        JSONObject jsonResponse = new JSONObject(responseContent.toString());
        
        
//Access Token 추출
/*        
        jsonResponse.getString("access_token"): access_token이라는 키를 통해 Access Token 값을 추출합니다. 
        Access Token은 이후 사용자 정보를 가져오거나 API 호출 시 인증용으로 사용됩니다.
*/        
        String accessToken = jsonResponse.getString("access_token");

        
//Access Token 저장 및 리다이렉트
/*        
        accessToken이 성공적으로 추출되면 세션에 저장합니다. 세션은 서버에서 사용자 상태를 유지하는데 사용됩니다.
        이후 getUserProfileServlet으로 리다이렉트하여 사용자 프로필 정보를 요청합니다.
        만약 Access Token이 없으면 클라이언트에게 실패 메시지를 출력합니다.
*/              
        // 사용자 정보 요청
        if (accessToken != null) {
            request.getSession().setAttribute("accessToken", accessToken);
            response.sendRedirect("getUserProfileServlet");
        } else {
            response.getWriter().write("Access Token 획득 실패");
        }
    }
}







