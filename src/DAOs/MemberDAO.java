package DAOs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.util.ArrayList;

import Common.DBConnector;
import VOs.MealkitWishListVO;
import VOs.MemberVO;
import VOs.RecipeWishListVO;

public class MemberDAO {

    private DBConnector dbConnector;
	private Object type;
	public MemberDAO() {
		dbConnector = new DBConnector();
	}
	
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
            dbConnector.release();  // 자원 해제
        }
        return members;
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
            dbConnector.release();
        }
        return result;
    }

	/*
	 * // 네이버 아이디 저장 public void insertNaverMember(String naverId) throws
	 * SQLException { String sql = "INSERT INTO member (id) VALUES (?)"; try { int
	 * result = dbConnector.executeUpdate(sql, naverId); if (result > 0) {
	 * System.out.println("네이버 아이디가 성공적으로 등록되었습니다."); } else {
	 * System.out.println("네이버 아이디 등록에 실패했습니다."); } } finally {
	 * dbConnector.release(); } }
	 */
    
 // 카카오 아이디 저장
	/*
	 * public void insertKakaoMember(String kakaoId) throws SQLException {
	 * 
	 * System.out.println("DAO에서" + kakaoId);
	 * 
	 * String sql = "INSERT INTO member (id) VALUES (?)"; try {
	 * 
	 * int result = dbConnector.executeUpdate(sql, kakaoId); if (result > 0) {
	 * System.out.println("카카오 아이디가 성공적으로 등록되었습니다.");
	 * 
	 * } else { System.out.println("카카오 아이디 등록에 실패했습니다.");
	 * 
	 * } } finally { dbConnector.release(); } }
	 */
    

    // 회원가입 처리 (추가 정보 포함)
    public void insertMember(MemberVO vo) {
        String sql = "INSERT INTO member (id, name, nickname, phone, address, profile, join_date) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
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
        } finally {
            dbConnector.release();
        }
    }
    
    
    public boolean isUserExists(String userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM member WHERE id = ?";
        ResultSet rs = dbConnector.executeQuery(sql, userId);
        if (rs.next()) {
            return rs.getInt(1) > 0;  // 존재하면 true 반환
        }
        return false;
    }

    

    // 사용자 확인 (로그인용)
    public int userCheck(String login_id, String login_name) {
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
            dbConnector.release();
        }
        return check;
    }
    
    //회원정보 수정
    public String profileUpdate(String id){    

    	return null;
    }
    
	public MemberVO selectMember(String id) {
    	
    	MemberVO vo = new MemberVO();
    //	vo.getId()
    	return vo;
    	
    }
	
    // 사용자 레시피 위시리스트 조회
    public ArrayList<RecipeWishListVO> selectUserRecipeWishlist(String id) {
        ArrayList<RecipeWishListVO> wishlist = new ArrayList<>();
        String sql = "SELECT * FROM recipe_wishlist WHERE id = ?";
        ResultSet resultSet = null;

        try {
            resultSet = dbConnector.executeQuery(sql, id);
            while (resultSet.next()) {
                RecipeWishListVO recipeWishlist = new RecipeWishListVO(
                        resultSet.getInt("no"),
                        resultSet.getString("id"),
                        resultSet.getInt("recipe_no")
                );
                wishlist.add(recipeWishlist);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("selectUserRecipeWishlist() SQLException 발생");
        } finally {
            dbConnector.release();  // 자원 해제
        }
        return wishlist;
    }

    // 사용자 상품 위시리스트 조회
    public ArrayList<MealkitWishListVO> selectUserProductWishlist(String id) {
        ArrayList<MealkitWishListVO> wishlist = new ArrayList<>();
        String sql = "SELECT * FROM mealkit_wishlist WHERE id = ?";
        ResultSet resultSet = null;

        try {
            resultSet = dbConnector.executeQuery(sql, id);
            while (resultSet.next()) {
            	MealkitWishListVO mealkitwishlist = new MealkitWishListVO(
                        resultSet.getInt("no"),
                        resultSet.getString("id"),
                        resultSet.getInt("product_no"),
                        resultSet.getInt("type")
                );
                wishlist.add(mealkitwishlist);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("selectUserMealkitWishListVO() SQLException 발생");
        } finally {
            dbConnector.release();  // 자원 해제
        }
        return wishlist;
    }

    // 레시피 위시리스트에 레시피 추가
    public boolean addRecipeToWishlist(String id, int recipeNo) throws SQLException {
        String sql = "INSERT INTO recipe_wishlist (id, recipe_no) VALUES (?, ?)";
        try {
            int result = dbConnector.executeUpdate(sql, id, recipeNo);
            return result > 0;  // 성공하면 true, 실패하면 false
        } finally {
            dbConnector.release();  // 자원 해제
        }
    }

    // 상품 위시리스트에 상품 추가
    public boolean addMealkitToWishlist(String id, int mealkit_no) throws SQLException {
        String sql = "INSERT INTO mealkit_wishlist (id, mealkit_no, type) VALUES (?, ?, ?)";
        try {
            int result = dbConnector.executeUpdate(sql, id, mealkit_no, type);
            return result > 0;  // 성공하면 true, 실패하면 false
        } finally {
            dbConnector.release();  // 자원 해제
        }
    }

    // 레시피 위시리스트에서 레시피 삭제
    public boolean removeRecipeFromWishlist(String id, int recipeNo) throws SQLException {
        String sql = "DELETE FROM recipe_wishlist WHERE id = ? AND recipe_no = ?";
        try {
            int result = dbConnector.executeUpdate(sql, id, recipeNo);
            return result > 0;  // 성공하면 true, 실패하면 false
        } finally {
            dbConnector.release();  // 자원 해제
        }
    }

    // 상품 위시리스트에서 상품 삭제
    public boolean removeProductFromWishlist(String id, int mealkit_no) throws SQLException {
        String sql = "DELETE FROM mealkit_wishlist WHERE id = ? AND product_no = ?";
        try {
            int result = dbConnector.executeUpdate(sql, id, mealkit_no);
            return result > 0;  // 성공하면 true, 실패하면 false
        } finally {
            dbConnector.release();  // 자원 해제
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
			dbConnector.release();
		}
		return check;
	}

	// 개인정보수정 - id변경 불가
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

				result = dbConnector.executeUpdate(updateSql, member.getProfile(), member.getName(),
						member.getNickname(), member.getPhone(), member.getAddress(), member.getId());

				if (result == 1) {
					// 정보 수정이 성공적으로 실행 했을 때
				} else {
					// 정보 수정에 실패 했을 때
				}
			} else {
				result = -1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			result = -1;
		}

		dbConnector.release();

		return result;
	}

	// 프로필 사진 불러오기
	public String viewProfile(String profile) {

		return profile;
	}
}
