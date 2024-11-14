package DAOs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.util.ArrayList;

import Common.DBConnector;
import VOs.MemberVO;


public class MemberDAO {

	private static final String URL = "jdbc:mysql://localhost:3306/my_database";
	private static final String USER = "root";
	private static final String PASSWORD = "password123";
	
	
    private DBConnector dbConnector;

    public MemberDAO() {
        dbConnector = new DBConnector();
    }

    // 전체 회원 조회
    public ArrayList<MemberVO> selectMembers() {
        ArrayList<MemberVO> members = new ArrayList<>();
        String sql = "SELECT * FROM member";
        ResultSet resultSet = null;

        try {
            resultSet = dbConnector.executeQuery(sql);
            while (resultSet.next()) {
                MemberVO member = new MemberVO(
                    resultSet.getString("id"),
                    resultSet.getString("name"),
                    resultSet.getString("nickname"),
                    resultSet.getString("phone"),
                    resultSet.getString("address"),
                    resultSet.getString("profile"),
                    resultSet.getTimestamp("join_date")
                );
                members.add(member);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("selectMembers() SQLException 발생");
        } finally {
            dbConnector.Release();  // 자원 해제
        }
        return members;
    }
    
    public MemberVO selectMember(String id) {
    	
    	MemberVO vo = new MemberVO();
    	
    	return vo;
    	
    }

    // ID 중복 확인
    public boolean isExistMemberId(String id) {
        boolean result = false;
        String sql = "SELECT COUNT(*) AS count FROM member WHERE id = ?";
        ResultSet resultSet = null;

        try {
            resultSet = dbConnector.executeQuery(sql, id);
            if (resultSet != null && resultSet.next()) {
                int count = resultSet.getInt("count");
                result = (count > 0);
            }
        } catch (Exception e) {
            System.out.println("isExistMemberId 메소드에서 예외 발생");
            e.printStackTrace();
        } finally {
            dbConnector.Release();
        }
        return result;
    }

    // 네이버 아이디 등록
    public void insertNaverMember(String naverId) {
        String sql = "INSERT INTO member (id) VALUES (?)";

        try {
            int result = dbConnector.executeUpdate(sql, naverId);

            if (result > 0) {
                System.out.println("네이버 아이디가 성공적으로 등록되었습니다.");
            } else {
                System.out.println("네이버 아이디 등록에 실패했습니다.");
            }
        } catch (Exception e) {
            System.out.println("네이버 아이디 등록 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            dbConnector.Release();
        }
    }

    // 회원 등록
    public void insertMember(MemberVO vo) {
        String sql = "INSERT INTO member(id, name, nickname, phone, address, profile, join_date) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try {
            // 값 확인
            System.out.println("id: " + vo.getId());
            System.out.println("name: " + vo.getName());
            System.out.println("nickname: " + vo.getNickname());
            System.out.println("phone: " + vo.getPhone());
            System.out.println("address: " + vo.getAddress());
            System.out.println("profile: " + vo.getProfile());

            Timestamp currentTimestamp = new Timestamp(System.currentTimeMillis());
            int result = dbConnector.executeUpdate(sql, 
                vo.getId(), 
                vo.getName(), 
                vo.getNickname(),
                vo.getPhone(), 
                vo.getAddress(), 
                vo.getProfile(), 
                currentTimestamp
            );

            if (result > 0) {
                System.out.println("회원이 성공적으로 등록되었습니다.");
            } else {
                System.out.println("회원 등록에 실패했습니다.");
            }
        } catch (Exception e) {
            System.out.println("회원 등록 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            dbConnector.Release();
        }
    }

    // 사용자 확인 (로그인용)
    public int checkMember(String login_id, String login_name) {
        int check = -1;
        String sql = "SELECT * FROM member WHERE id=?";
        ResultSet resultSet = null;

        try {
            resultSet = dbConnector.executeQuery(sql, login_id);
            if (resultSet.next()) {
                if (login_name.equals(resultSet.getString("name"))) {
                    check = 1; // 이름 일치
                } else {
                    check = 0; // 이름 불일치
                }
            } else {
                check = -1; // ID 없음
            }
        } catch (Exception e) {
            System.out.println("MemberDAO의 userCheck 메소드에서 오류");
            e.printStackTrace();
        } finally {
            dbConnector.Release();
        }
        return check;
    }

    //개인정보수정 - id변경 불가
    public int updateMember(MemberVO member) {
    	
    	int result = -1;
    	
    	// 1. memberVO를 통해 전달 받은 멤버가 DB에 존재하는지 확인
        String checkSql = "SELECT COUNT(*) FROM member WHERE id = ?";
        
        ResultSet resultSet = dbConnector.executeQuery(checkSql, member.getId());
        
        try {
			if (resultSet.next()) {
				// DB에 멤버가 존재 할 때
				// 2. 존재하는 멤버의 DB정보를 수정
				String updateSql = "UPDATE member SET profile = ?, name = ?, nickname = ?, phone = ?, address = ? WHERE id = ?";
		        
				result = dbConnector.executeUpdate(updateSql,
						member.getProfile(),
						member.getName(),
						member.getNickname(),
						member.getPhone(),
						member.getAddress(),
						member.getId());
				
				if (result == 1) {
					// 정보 수정이 성공적으로 실행 했을 때
				}
				else {
					// 정보 수정에 실패 했을 때
				}
			}
			else {
				result = -1;
			}
		}
        catch (SQLException e) {
			e.printStackTrace();
			result = -1;
		}
        
        dbConnector.Release();
        
        return result;
    }
    
    //프로필 사진 불러오기
    public String viewProfile(String profile){
    	
		return profile;
    }
}
