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
4. 사용자 정보 요청 Servlet
	Access Token으로 네이버 API에 사용자 정보를 요청하여 데이터를 가져옵니다.
	
	GetUserProfileServlet의 역할은 네이버에서 받은 Access Token을 사용하여 사용자 프로필 정보를 가져오는 것입니다. 
*/


@WebServlet("/members/getUserProfileServlet")
public class GetUserProfileServlet extends HttpServlet {
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
       
		
//1.세션에서 Access Token 가져오기
//		request.getSession().getAttribute("accessToken")은 세션에서 저장된 Access Token을 가져옵니다.
//		Access Token은 사용자 정보를 요청할 때 필요한 인증 토큰으로, 세션을 통해 공유되고 있습니다.		
		String accessToken = (String) request.getSession().getAttribute("accessToken");

//2.Access Token 유효성 검사
//		accessToken이 null이면 로그인하지 않은 상태이므로, 로그인 요청 메시지를 클라이언트에 전송하고 메서드를 종료합니다.
//		이렇게 하면, 인증되지 않은 사용자가 사용자 정보 요청을 시도할 때 오류가 발생하지 않도록 처리됩니다.		
		if (accessToken == null) {
            response.getWriter().write("로그인이 필요합니다.");
            return;
        }
		
//3.인증 헤더 생성
//		Bearer는 OAuth 2.0에서 토큰을 사용하는 방식의 일종입니다.
//		Bearer <토큰> 형식으로 Access Token을 네이버 서버에 보냅니다.		
        String header = "Bearer " + accessToken;
        
//4.API URL 설정
//      apiURL 변수에 네이버 사용자 정보를 가져오는 API의 URL을 설정합니다.
//      이 URL에 Access Token을 포함한 요청을 보내면 사용자 정보를 받을 수 있습니다.
        String apiURL = "https://openapi.naver.com/v1/nid/me";

//5.URL 객체 생성
//      apiURL 문자열을 URL 객체로 변환하여 서버에 연결할 수 있도록 합니다.
        URL url = new URL(apiURL);
     
//6.HTTP 연결 설정
//      url.openConnection()을 사용해 실제 서버와의 연결을 설정하는 HttpURLConnection 객체를 만듭니다.
//      con 객체는 네이버 서버와 통신하는 역할을 합니다.
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        
//7.HTTP 요청 방식 설정
//      con.setRequestMethod("GET"): GET 방식으로 요청을 보냅니다.
//      GET 요청은 데이터를 가져오는 용도로 사용되며, 여기서는 사용자 정보를 가져오려는 요청입니다.      
        con.setRequestMethod("GET");
        
//8.인증 헤더 설정
//      setRequestProperty 메서드를 통해 Authorization 헤더에 Bearer <Access Token> 값을 설정합니다.
//      이 헤더는 네이버 서버가 인증 정보를 확인하도록 도와줍니다.       
        con.setRequestProperty("Authorization", header);

//9.응답 코드 확인
//      getResponseCode() 메서드를 통해 네이버 서버에서 받은 응답 코드 확인.
//      응답 코드가 200이면 요청이 성공한 것이고, 다른 코드일 경우 요청이 실패한 것을 의미합니다.        
        int responseCode = con.getResponseCode();
        
//10.응답 데이터 읽기 준비
//      응답 코드가 200일 때는 getInputStream()을 사용해 정상 응답 데이터를 읽습니다.
//      실패한 경우에는 getErrorStream()을 사용해 에러 내용을 읽습니다.
//      BufferedReader는 데이터를 한 줄씩 읽을 수 있는 객체입니다.  
        BufferedReader br = (responseCode == 200) ? new BufferedReader(new InputStreamReader(con.getInputStream()))
                                                 : new BufferedReader(new InputStreamReader(con.getErrorStream()));
//11.응답 데이터 읽기
//        while 루프를 사용해 서버 응답 데이터를 한 줄씩 읽어 responseContent에 저장합니다.
//        모든 데이터를 다 읽은 후 br.close()를 통해 BufferedReader를 닫아 메모리를 해제합니다.
        String inputLine;
        StringBuffer responseContent = new StringBuffer();
        while ((inputLine = br.readLine()) != null) {
            responseContent.append(inputLine);
        }
        br.close();
        
//12.응답 데이터를 JSON 객체로 변환
//    responseContent에 저장된 JSON 데이터를 JSONObject로 변환해 사용합니다.
//    이렇게 하면 JSON 형식으로 전달된 데이터에서 원하는 값을 쉽게 추출할 수 있습니다.
        JSONObject userProfile = new JSONObject(responseContent.toString()).getJSONObject("response");
        System.out.println(userProfile);
        
//13.응답 데이터에서 사용자 정보 추출
//      jsonResponse에서 response라는 키를 가진 하위 JSON 객체를 가져옵니다.
//      이 response 객체에 사용자의 ID, 이름, 이메일 등의 정보가 포함되어 있습니다.        
        request.setAttribute("userProfile", userProfile);
        
//14. displayUserProfile.jsp 재요청(디스패처 방식 포워딩) 시 request공유        
        request.getRequestDispatcher("displayUserProfile.jsp").forward(request, response);
    }
}
