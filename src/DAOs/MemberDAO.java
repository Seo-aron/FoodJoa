package DAOs;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.List;

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

	public Timestamp selectJoinDate(String id) {

		Timestamp result = null;

		String sql = "SELECT join_date FROM member WHERE id = ?";

		try {
			ResultSet resultSet = dbConnector.executeQuery(sql, id);
			if (resultSet.next()) {
				result = resultSet.getTimestamp("join_date");
			}
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectJoinDate() SQLException 발생");
		} finally {
			dbConnector.release();
		}
		return result;
	}
	
	public MemberVO selectMembers() {
		MemberVO members = new MemberVO();
		String sql = "SELECT * FROM member";
		ResultSet resultSet = null;
		try {
			resultSet = dbConnector.executeQuery(sql);
			while (resultSet.next()) {
				MemberVO member = new MemberVO(resultSet.getString("id"), resultSet.getString("name"),
						resultSet.getString("nickname"), resultSet.getString("phone"), resultSet.getString("address"),
						resultSet.getString("profile"), resultSet.getTimestamp("join_date"));

			}
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectMembers() SQLException 발생");
		} finally {
			dbConnector.release(); // 자원 해제
		}
		return members;
	}

	public MemberVO getMemberProfile(String userId) throws SQLException {
	       MemberVO member = null;
	       String sql = "SELECT * FROM member WHERE id=?";
	       
	       ResultSet resultSet = dbConnector.executeQuery(sql, userId);
	       
	       try {
	           if (resultSet.next()) {
	               member = new MemberVO(
	                   resultSet.getString("id"), 
	                   resultSet.getString("name"),
	                   resultSet.getString("nickname"), 
	                   resultSet.getString("phone"), 
	                   resultSet.getString("address"),
	                   resultSet.getString("profile"), 
	                   resultSet.getTimestamp("join_date")
	               );
	           }
	       } catch (SQLException e) {
	           e.printStackTrace();
	       } finally {
	           dbConnector.release(); // 자원 해제
	       }

	       return member; // 회원 반환
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

	// 네이버 아이디 저장
	public void insertNaverMember(String naverId) throws SQLException {
		String sql = "INSERT INTO member (id) VALUES (?)";
		try {
			int result = dbConnector.executeUpdate(sql, naverId);
			if (result > 0) {
				System.out.println("네이버 아이디가 성공적으로 등록되었습니다.");
			} else {
				System.out.println("네이버 아이디 등록에 실패했습니다.");
			}
		} finally {
			dbConnector.release();
		}
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
			int result = dbConnector.executeUpdate(sql, vo.getId(), vo.getName(), vo.getNickname(), vo.getPhone(),
					vo.getAddress(), vo.getProfile(), currentTimestamp);
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
			return rs.getInt(1) > 0; // 존재하면 true 반환
		}
		return false;
	}

	// 레시피 위시리스트에 레시피 추가
	public boolean addRecipeToWishlist(String id, int recipeNo) throws SQLException {
		String sql = "INSERT INTO recipe_wishlist (id, recipe_no) VALUES (?, ?)";
		try {
			int result = dbConnector.executeUpdate(sql, id, recipeNo);
			return result > 0; // 성공하면 true, 실패하면 false
		} finally {
			dbConnector.release(); // 자원 해제
		}
	}

	// 상품 위시리스트에 상품 추가
	public boolean addMealkitToWishlist(String id, int mealkit_no) throws SQLException {
		String sql = "INSERT INTO mealkit_wishlist (id, mealkit_no, type) VALUES (?, ?, ?)";
		try {
			int result = dbConnector.executeUpdate(sql, id, mealkit_no, type);
			return result > 0; // 성공하면 true, 실패하면 false
		} finally {
			dbConnector.release(); // 자원 해제
		}
	}

	// 레시피 위시리스트에서 레시피 삭제
	public boolean removeRecipeFromWishlist(String id, int recipeNo) throws SQLException {
		String sql = "DELETE FROM recipe_wishlist WHERE id = ? AND recipe_no = ?";
		try {
			int result = dbConnector.executeUpdate(sql, id, recipeNo);
			return result > 0; // 성공하면 true, 실패하면 false
		} finally {
			dbConnector.release(); // 자원 해제
		}
	}

	// 상품 위시리스트에서 상품 삭제
	public boolean removeProductFromWishlist(String id, int mealkit_no) throws SQLException {
		String sql = "DELETE FROM mealkit_wishlist WHERE id = ? AND product_no = ?";
		try {
			int result = dbConnector.executeUpdate(sql, id, mealkit_no);
			return result > 0; // 성공하면 true, 실패하면 false
		} finally {
			dbConnector.release(); // 자원 해제
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

	// 사용자 레시피 위시리스트 조회
	public ArrayList<RecipeWishListVO> selectUserRecipeWishlist(String id) {
		ArrayList<RecipeWishListVO> wishlist = new ArrayList<>();
		String sql = "SELECT rw.no, rw.id, rw.recipe_no, r.thumbnail, r.title, r.description "
				+ "FROM recipe_wishlist rw " + "JOIN recipe r ON rw.recipe_no = r.no " + "WHERE rw.id = ?"; // 사용자의 찜한
																											// 레시피 목록을
																											// 조회

		ResultSet resultSet = null;

		try {
			// 쿼리 실행
			resultSet = dbConnector.executeQuery(sql, id);

			// 결과 처리
			while (resultSet.next()) {
				// RecipeWishListVO 객체 생성 (기존 필드만 사용)
				RecipeWishListVO recipeWishlist = new RecipeWishListVO(resultSet.getInt("no"), // 찜 목록 고유 번호
						resultSet.getString("id"), // 사용자 아이디
						resultSet.getInt("recipe_no") // 레시피 고유 번호
				);

				// 레시피 정보를 추가로 처리 (별도로 저장하지 않음, 단지 사용만 함)
				// 예를 들어, JSP에서 레시피 썸네일, 제목, 설명을 사용하려면 `ResultSet`에서 추출한 정보를 이용
				String thumbnail = resultSet.getString("thumbnail");
				String title = resultSet.getString("title");
				String description = resultSet.getString("description");

				// 여기에 저장하지 않고 바로 JSP에서 출력할 수 있도록 처리
				// 예를 들어, JSP 페이지에서 "recipeWishlist.getThumbnail()" 등의 방식으로 사용 가능

				// 추가 필드가 필요하다면, 그 부분을 JSP에서 직접 처리하거나 `VO` 클래스에서 다른 방법으로 처리 가능

				wishlist.add(recipeWishlist); // 리스트에 추가
			}
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectUserRecipeWishlist() SQLException 발생");
		} finally {
			dbConnector.release(); // 자원 해제
		}
		return wishlist;
	}

	// 사용자 상품 위시리스트 조회
	public ArrayList<MealkitWishListVO> selectUserProductWishlist(String id) {
		ArrayList<MealkitWishListVO> wishlist = new ArrayList<>();

		// 상품 테이블(mealkit)을 JOIN하여 상품의 추가 정보도 가져오기
		String sql = "SELECT mw.no, mw.id, mw.product_no, mw.type, m.thumbnail, m.name, m.price "
				+ "FROM mealkit_wishlist mw " + "JOIN mealkit m ON mw.product_no = m.no " + "WHERE mw.id = ?"; // 사용자의 찜
																												// 목록 조회

		ResultSet resultSet = null;

		try {
			// 쿼리 실행
			resultSet = dbConnector.executeQuery(sql, id);

			// 결과 처리
			while (resultSet.next()) {
				// MealkitWishListVO 객체 생성 (기존 필드만 사용)
				MealkitWishListVO mealkitwishlist = new MealkitWishListVO(resultSet.getInt("no"), // 찜 목록 고유 번호
						resultSet.getString("id"), // 사용자 아이디
						resultSet.getInt("product_no"), // 상품 고유 번호
						resultSet.getInt("type") // 상품 유형
				);

				// 상품의 추가 정보를 가져옴 (VO에 저장하지 않고 사용)
				String thumbnail = resultSet.getString("thumbnail");
				String name = resultSet.getString("name");
				double price = resultSet.getDouble("price");

				wishlist.add(mealkitwishlist); // 리스트에 추가
			}
		} catch (SQLException e) {
			e.printStackTrace();
			System.out.println("selectUserProductWishlist() SQLException 발생");
		} finally {
			dbConnector.release(); // 자원 해제
		}

		return wishlist;
	}

	// 개인정보수정 - id변경 불가
	public int updateMember(MemberVO member) {

		System.out.println(member.getProfile());
		System.out.println(member.getName());
		System.out.println(member.getNickname());
		System.out.println(member.getPhone());
		System.out.println(member.getAddress());
		System.out.println(member.getId());

		String sql = "UPDATE member SET profile=?, name=?, nickname=?, phone=?, address=? " + "WHERE id=?";

		int result = dbConnector.executeUpdate(sql, member.getProfile(), member.getName(), member.getNickname(),
				member.getPhone(), member.getAddress(), member.getId());

		return result;
	}

	public MemberVO selectMember(String id) {
		MemberVO member = null;
		String sql = "SELECT * FROM member WHERE id=?";

		ResultSet resultSet = dbConnector.executeQuery(sql, id);

		try {
			if (resultSet.next()) {
				member = new MemberVO(resultSet.getString("id"), resultSet.getString("name"),
						resultSet.getString("nickname"), resultSet.getString("phone"), resultSet.getString("address"),
						resultSet.getString("profile"), resultSet.getTimestamp("join_date"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return member; // 회원 리스트 반환
	}

	public int deleteMemberById(String readonlyId) {

		int result = 0;

		// 삭제할 회원에 대한 SQL 쿼리
		String sql = "DELETE FROM member WHERE id = '" + readonlyId + "'";

		try {
			// DB 연결을 위한 dbConnector 객체 사용 (Statement 사용)
			dbConnector.executeUpdate(sql); // executeUpdate로 DELETE 쿼리 실행

			result = 1; // 삭제 성공
		} catch (Exception e) {
			System.out.println("MemberDAO의 deleteMemberById 메소드에서 오류");
			e.printStackTrace();
		} finally {
			dbConnector.release(); // 연결 해제
		}

		return result; // 삭제 성공 시 1 반환, 실패 시 0 반환
	}
}
