package DAOs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

import Common.DBConnector;
import VOs.MemberVO;
import VOs.RecipeVO;

public class MemberDAO {

    private DBConnector dbConnector;

    public MemberDAO() {
        dbConnector = new DBConnector();
    }

public ArrayList<MemberVO> selectMembers() {
		
		ArrayList<MemberVO> members = new ArrayList<MemberVO>();
		
		String sql = "SELECT * FROM member";
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
		try {
			while (resultSet.next()) {
				
				MemberVO member = new MemberVO(
						resultSet.getString("id"),
						resultSet.getString("name"),
						resultSet.getString("nickname"),
						resultSet.getString("phone"),
						resultSet.getString("address"),
						resultSet.getString("profile"),
						resultSet.getTimestamp("join_date"));
				
				members.add(member);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectMembers() SQLException 발생");
		}
				
		dbConnector.Release();
		
		return members;
	}

public boolean overlappedId(String id) {
    boolean result = false;
    
    String sql = "SELECT COUNT(*) AS count FROM member WHERE id = '" + id + "'"; // SQL 쿼리 작성
    ResultSet rs = dbConnector.executeQuery(sql); // 쿼리 실행
    
    try {
        if (rs != null && rs.next()) {
            int count = rs.getInt("count"); // ID의 중복 여부 확인
            result = (count > 0); // count가 0보다 크면 중복된 ID가 존재, 그렇지 않으면 중복되지 않음
        }
    } catch (Exception e) {
        System.out.println("overlappedId 메소드에서 예외 발생");
        e.printStackTrace();
    }
    
    dbConnector.Release(); // 자원 해제
    
    return result; // 중복 여부 반환
}

public void insertMember(MemberVO vo) {
    String sql = "INSERT INTO member (id, name, nickname, phone, address, profile) "
               + "VALUES (?, ?, ?, ?, ?, ?)";

    try {
        int result = dbConnector.executeUpdate(sql, vo.getId(), vo.getName(), vo.getNickname(),
                                               vo.getPhone(), vo.getAddress(), vo.getProfile());

        if (result > 0) {
            System.out.println("회원이 성공적으로 등록되었습니다.");
        } else {
            System.out.println("회원 등록에 실패했습니다.");
        }
    } catch (Exception e) {
        System.out.println("회원 등록 중 오류 발생: " + e.getMessage());
        e.printStackTrace();  // 예외 스택 트레이스를 출력하여 상세한 정보 제공
    } finally {
        dbConnector.Release();  // 연결 해제
    }
}

public int userCheck(String login_id, String login_name) {
    int check = -1;
    
    String sql = "SELECT * FROM member WHERE id=?";
    
    try {
        
        ResultSet rs = dbConnector.executeQuery(sql, login_id);
        
        if (rs.next()) {
            
            if (login_name.equals(rs.getString("name"))) {
                check = 1;
            } else {
                check = 0;
            }
        } else {
            check = -1;
        }
    } catch (Exception e) {
        System.out.println("MemberDAO의 userCheck메소드에서 오류");
        e.printStackTrace(); 
    } finally {
        dbConnector.Release(); 
    }
    
    return check; 
}
}
		
	
	
