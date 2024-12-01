package DAOs;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.HashMap;

import Common.DBConnector;
import VOs.DeliveryInfoVO;
import VOs.MealkitVO;
import VOs.MealkitWishListVO;
import VOs.MemberVO;
import VOs.RecipeVO;
import VOs.RecipeWishListVO;

public class MemberDAO {

	private DBConnector dbConnector;
	private Object type;
	private ResultSet resultSet;

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
	public int insertMember(MemberVO vo) {
		String sql = "INSERT INTO member (id, name, nickname, phone, address, profile, join_date) "
				+ "VALUES (?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

		int result = dbConnector.executeUpdate(sql, vo.getId(), vo.getName(), vo.getNickname(), vo.getPhone(),
				vo.getAddress(), vo.getProfile());

		dbConnector.release();

		return result;
	}

	public boolean isUserExists(String userId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM member WHERE id = ?";
		ResultSet rs = dbConnector.executeQuery(sql, userId);
		if (rs.next()) {
			return rs.getInt(1) > 0; // 존재하면 true 반환
		}
		return false;
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

	public ArrayList<DeliveryInfoVO> selectDeliver(String id) {
		ArrayList<DeliveryInfoVO> delivery = new ArrayList<>();
//		delivery = null;
//		String sql = "SELECT A.id, A.nickname, B.pictures, C.address, C.amount, C.delivered, C.refund "
//				+ "FROM MEMBER A " + "JOIN MEALKIT B " + "ON A.ID = B.ID " + "JOIN MEALKIT_ORDER C " + "ON B.ID = C.ID "
//				+ "WHERE A.id=?";
//		ResultSet resultSet = dbConnector.executeQuery(sql, id);
//		try {
//			while (resultSet.next()) {
//				DeliveryInfoVO memberDelivery = new DeliveryInfoVO(resultSet.getString("id"),
//						resultSet.getString("nickname"), resultSet.getString("pictures"),
//						resultSet.getString("address"), resultSet.getInt("amount"), resultSet.getInt("delivered"),
//						resultSet.getInt("refund"));
//				delivery.add(memberDelivery);
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//		} finally {
//			dbConnector.release();
//		}
		return delivery;
	}

	
	// 최근 본 목록 조회
	public ArrayList<HashMap<String, Object>> getRecentView(String userId, int type) {

		
		ArrayList<HashMap<String, Object>> recentViews = new ArrayList<>();
	    String sql = "SELECT ";
	    
	    if (type == 0) {
	    	sql += "r.title, r.thumbnail, r.description, r.category, ";
	    }
	    else {
	    	sql += "k.title, k.contents, k.category, k.price, k.pictures, ";
	    }
	    sql += "m.nickname, m.profile ";
	    sql += "FROM recent_view v ";
	    if (type == 0 ) {
	    	sql += "LEFT JOIN recipe r ON v.item_no = r.no ";
	    	sql += "LEFT JOIN member m ON r.id=m.id ";
	    	sql += "WHERE v.id=?";
		    sql += "ORDER BY r.post_date DESC LIMIT 20";
	    }
	    else {
	    	sql += "LEFT JOIN mealkit k ON v.item_no = k.no ";
	    	sql += "LEFT JOIN member m ON k.id=m.id ";
	    	sql += "WHERE v.id=?";
		    sql += "ORDER BY k.post_date DESC LIMIT 20";
	    }
	    
	    ResultSet resultSet = dbConnector.executeQuery(sql, userId);
	    
	  
	    
	    try {
			while (resultSet.next()) {
				HashMap<String, Object> recentView = new HashMap<String, Object>();
				
				if (type == 0) {
					RecipeVO recipeVO = new RecipeVO();

					recipeVO.setTitle(resultSet.getString("title"));
					recipeVO.setThumbnail(resultSet.getString("thumbnail"));
					recipeVO.setDescription(resultSet.getString("description"));
					recipeVO.setCategory(resultSet.getInt("category"));
					
					recentView.put("recipeVO", recipeVO);
				
				}
				else {
					MealkitVO mealkitVO = new MealkitVO();
					//sql += "k.title, k.contents, k.category, k.price, k.pictures, ";
					mealkitVO.setTitle(resultSet.getString("title"));
					mealkitVO.setContents(resultSet.getString("contents"));
					mealkitVO.setCategory(resultSet.getInt("category"));
					mealkitVO.setPrice(resultSet.getString("price"));
					mealkitVO.setPictures(resultSet.getString("pictures"));
					
					recentView.put("mealkitVO", mealkitVO); 
		
				}
				
				MemberVO memberVO = new MemberVO();
				
				memberVO.setNickname(resultSet.getString("nickname"));
				memberVO.setProfile(resultSet.getString("profile"));
				recentView.put("memberVO", memberVO);
				
				recentViews.add(recentView);
				
				;
			}
		}
	    catch (SQLException e) {
			e.printStackTrace();
		}
	    
	    return recentViews;
	}

	public MemberVO getMemberProfile(String userId) throws SQLException {
		MemberVO member = null;
		String sql = "SELECT * FROM member WHERE id=?";

		ResultSet resultSet = dbConnector.executeQuery(sql, userId);

		try {
			if (resultSet.next()) {
				member = new MemberVO(resultSet.getString("id"), resultSet.getString("name"),
						resultSet.getString("nickname"), resultSet.getString("phone"), resultSet.getString("address"),
						resultSet.getString("profile"), resultSet.getTimestamp("join_date"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			dbConnector.release(); // 자원 해제
		}

		return member; // 회원 반환
	}

	public ArrayList<DeliveryInfoVO> selectSend(String id) {
		ArrayList<DeliveryInfoVO> send = new ArrayList<>();
	//	String sql = "SELECT A.id, A.address, A.quantity, A.delivered, A.refund, B.contents, B.category, B.price, B.stock, B.pictures, B.nickname" + 
	//			" FROM mealkit_order" + "LEFT JOIN  mealkit " + "ON  a.id = b.id" +  "where A.id=?";
	//	ResultSet resultSet = dbConnector.executeQuery(sql, id);
	//	try {
	//		while (resultSet.next()) {
	//			DeliveryInfoVO memberSend = new DeliveryInfoVO(
	//					resultSet.getString("id"),
	//					resultSet.getString("nickname"),
	//					resultSet.getString("pictrues"),
	//					resultSet.getString("address"),
	//					resultSet.getInt("amount"),
	//					resultSet.getInt("delivered"),
	//					resultSet.getInt("refund"),
	//					resultSet.getInt("quantity"),
	//					resultSet.getString("contents"),
	//					resultSet.getInt("category"),
	//					resultSet.getString("price"),
	//					resultSet.getInt("stock"));
	//			send.add(memberSend);
	//		}
	//			
	//	} catch (Exception e) {
	//		e.printStackTrace();
	//	} finally {
	//		dbConnector.release();
	//	}
		return send;
	}
}