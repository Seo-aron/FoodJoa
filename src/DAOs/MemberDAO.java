package DAOs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.HashMap;

import Common.DBConnector;
import VOs.MealkitOrderVO;
import VOs.MealkitVO;
import VOs.MealkitWishListVO;
import VOs.MemberVO;
import VOs.RecipeVO;
import VOs.RecipeWishListVO;

public class MemberDAO {

	private static DBConnector dbConnector;
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
				MemberVO member = new MemberVO(
						resultSet.getString("id"), 
						resultSet.getString("name"),
						resultSet.getString("nickname"), 
						resultSet.getString("phone"), 
						resultSet.getString("zipcode"),
						resultSet.getString("address1"),
						resultSet.getString("address2"),
						resultSet.getString("profile"), 
						resultSet.getTimestamp("join_date"));

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
		String sql = "INSERT INTO member (id, name, nickname, phone, zipcode, address1, address2, profile, join_date) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

		int result = dbConnector.executeUpdate(sql,
				vo.getId(), 
				vo.getName(), 
				vo.getNickname(), 
				vo.getPhone(),
				vo.getZipcode(), 
				vo.getAddress1(), 
				vo.getAddress2(), 
				vo.getProfile());

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

		String sql = "UPDATE member SET profile=?, name=?, nickname=?, phone=?, zipcode=? , address1=? , address2=? "
				+ "WHERE id=?";

		int result = dbConnector.executeUpdate(sql, 
				member.getProfile(), 
				member.getName(), 
				member.getNickname(),
				member.getPhone(), 
				member.getZipcode(), 
				member.getAddress1(), 
				member.getAddress2(), 
				member.getId());

		return result;
	}

	public MemberVO selectMember(String id) {
		MemberVO member = null;
		String sql = "SELECT * FROM member WHERE id=?";

		ResultSet resultSet = dbConnector.executeQuery(sql, id);

		try {
			if (resultSet.next()) {
				member = new MemberVO(resultSet.getString("id"),
						resultSet.getString("name"),
						resultSet.getString("nickname"), 
						resultSet.getString("phone"), 
						resultSet.getString("zipcode"),
						resultSet.getString("address1"),
						resultSet.getString("address2"),
						resultSet.getString("profile"), 
						resultSet.getTimestamp("join_date"));
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

	
	/*
	 * public ArrayList<HashMap<String, Object>> getRecentView(String userId, int
	 * type) {
	 * 
	 * System.out.println("다오에서 UserId: " + userId); // userId 값 확인
	 * ArrayList<HashMap<String, Object>> recentViews = new ArrayList<>(); String
	 * sql = "SELECT ";
	 * 
	 * if (type == 0) { sql += "r.title, r.thumbnail, r.description, r.category, ";
	 * } else { sql += "k.title, k.contents, k.category, k.price, k.pictures, "; }
	 * 
	 * sql += "m.nickname, m.profile "; sql += "FROM recent_view v ";
	 * 
	 * if (type == 0) { sql += "LEFT JOIN recipe r ON v.item_no = r.no "; sql +=
	 * "LEFT JOIN member m ON r.id = m.id "; sql += "WHERE v.id = ? "; // userId로 조회
	 * sql += "ORDER BY r.post_date DESC LIMIT 20"; } else { sql +=
	 * "LEFT JOIN mealkit k ON v.item_no = k.no "; sql +=
	 * "LEFT JOIN member m ON k.id = m.id "; sql += "WHERE v.id = ? "; // userId로 조회
	 * sql += "ORDER BY k.post_date DESC LIMIT 20"; }
	 * 
	 * // 데이터베이스에서 결과 조회 ResultSet resultSet = dbConnector.executeQuery(sql,
	 * userId);
	 * 
	 * try { while (resultSet.next()) { HashMap<String, Object> recentView = new
	 * HashMap<String, Object>();
	 * 
	 * // type에 따라 레시피 또는 밀키트 정보를 다르게 처리 if (type == 0) { RecipeVO recipeVO = new
	 * RecipeVO(); recipeVO.setTitle(resultSet.getString("title"));
	 * recipeVO.setThumbnail(resultSet.getString("thumbnail"));
	 * recipeVO.setDescription(resultSet.getString("description"));
	 * recipeVO.setCategory(resultSet.getInt("category"));
	 * recentView.put("recipeVO", recipeVO); } else { MealkitVO mealkitVO = new
	 * MealkitVO(); mealkitVO.setTitle(resultSet.getString("title"));
	 * mealkitVO.setContents(resultSet.getString("contents"));
	 * mealkitVO.setCategory(resultSet.getInt("category"));
	 * mealkitVO.setPrice(resultSet.getString("price"));
	 * mealkitVO.setPictures(resultSet.getString("pictures"));
	 * recentView.put("mealkitVO", mealkitVO); }
	 * 
	 * // 회원 정보 추가 MemberVO memberVO = new MemberVO();
	 * memberVO.setNickname(resultSet.getString("nickname"));
	 * memberVO.setProfile(resultSet.getString("profile"));
	 * recentView.put("memberVO", memberVO);
	 * 
	 * // 최근 본 글 정보를 리스트에 추가 recentViews.add(recentView); } } catch (SQLException e)
	 * { e.printStackTrace(); }
	 * 
	 * return recentViews; }
	 */
	
	public ArrayList<HashMap<String, Object>> getRecentRecipeViews(String userId) {
	    ArrayList<HashMap<String, Object>> recentViews = new ArrayList<>();
	    String sql = "SELECT "
	    		+ "r.no, r.title, r.description, r.category, r.thumbnail, "
	    		+ "m.nickname, m.profile, "
	    		+ "COALESCE(average_table.average_rating, 0) AS average_rating "
	    		+ "FROM recent_view v "
	    		+ "LEFT JOIN recipe r ON v.item_no = r.no "
	    		+ "LEFT JOIN member m ON m.id = r.id "
	    		+ "LEFT JOIN ("
	    		+ "SELECT recipe_no, AVG(rating) AS average_rating "
	    		+ "FROM recipe_review "
	    		+ "GROUP BY recipe_no "
	    		+ ") average_table ON average_table.recipe_no = v.item_no "
	    		+ "WHERE v.id = ? AND v.type=0 "
	    		+ "ORDER BY v.view_date DESC LIMIT 20";

	    ResultSet resultSet = dbConnector.executeQuery(sql, userId);

	    try {
	        while (resultSet.next()) {
	            HashMap<String, Object> recentView = new HashMap<>();
	            RecipeVO recipeVO = new RecipeVO();
	            recipeVO.setNo(resultSet.getInt("no"));
	            recipeVO.setTitle(resultSet.getString("title"));
	            recipeVO.setThumbnail(resultSet.getString("thumbnail"));
	            recipeVO.setDescription(resultSet.getString("description"));
	            recipeVO.setCategory(resultSet.getInt("category"));

	            MemberVO memberVO = new MemberVO();
	            memberVO.setProfile(resultSet.getString("profile"));
	            memberVO.setNickname(resultSet.getString("nickname"));

	            float averageRating = resultSet.getFloat("average_rating");	            

	            recentView.put("recipeVO", recipeVO);
	            recentView.put("memberVO", memberVO);
	            recentView.put("averageRating", averageRating);
	            
	            recentViews.add(recentView);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return recentViews;
	}
	
	public ArrayList<HashMap<String, Object>> getRecentMealkitViews(String userId) {
	    ArrayList<HashMap<String, Object>> recentViews = new ArrayList<>();
	    String sql = "SELECT "
	    		+ "k.no, k.id, k.title, k.contents, k.category, k.price, k.pictures, "
	    		+ "m.nickname, m.profile, "
	    		+ "COALESCE(average_table.average_rating, 0) AS average_rating "
	    		+ "FROM recent_view v "
	    		+ "LEFT JOIN mealkit k ON v.item_no = k.no "
	    		+ "LEFT JOIN member m ON m.id = k.id "
	    		+ "LEFT JOIN ( "
	    		+ "SELECT mealkit_no, AVG(rating) AS average_rating "
	    		+ "FROM mealkit_review "
	    		+ "GROUP BY mealkit_no "
	    		+ ") average_table ON average_table.mealkit_no = v.item_no "
	    		+ "WHERE v.id = ? AND v.type=1 "
	    		+ "ORDER BY v.view_date DESC LIMIT 20";

	    ResultSet resultSet = dbConnector.executeQuery(sql, userId);

	    try {
	        while (resultSet.next()) {
	            HashMap<String, Object> recentView = new HashMap<>();
	            MealkitVO mealkitVO = new MealkitVO();
	            mealkitVO.setNo(resultSet.getInt("no"));
	            mealkitVO.setId(resultSet.getString("id"));
	            mealkitVO.setTitle(resultSet.getString("title"));
	            mealkitVO.setContents(resultSet.getString("contents"));
	            mealkitVO.setCategory(resultSet.getInt("category"));
	            mealkitVO.setPrice(resultSet.getString("price"));
	            mealkitVO.setPictures(resultSet.getString("pictures"));

	            MemberVO memberVO = new MemberVO();
	            memberVO.setProfile(resultSet.getString("profile"));
	            memberVO.setNickname(resultSet.getString("nickname"));
	            
	            float averageRating = resultSet.getFloat("average_rating");

	            recentView.put("mealkitVO", mealkitVO);
	            recentView.put("memberVO", memberVO);
	            recentView.put("averageRating", averageRating);
	            
	            recentViews.add(recentView);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    
	    return recentViews;
	}




	public MemberVO getMemberProfile(String userId) {
		MemberVO member = null;
		String sql = "SELECT * FROM member WHERE id=?";

		ResultSet resultSet = dbConnector.executeQuery(sql, userId);

		try {
			if (resultSet.next()) {
				member = new MemberVO(resultSet.getString("id"),
						resultSet.getString("name"),
						resultSet.getString("nickname"), 
						resultSet.getString("phone"), 
						resultSet.getString("zipcode"),
						resultSet.getString("address1"),
						resultSet.getString("address2"),
						resultSet.getString("profile"), 
						resultSet.getTimestamp("join_date"));
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
			dbConnector.release(); // 자원 해제
		}

		return member; // 회원 반환
	}


	public ArrayList<HashMap<String, Object>> selectDeliveredMealkit(String id) {
		
		ArrayList<HashMap<String, Object>> orderedMealkitList = new ArrayList<HashMap<String,Object>>();
		
		String sql = "SELECT "
				+ "o.address, o.quantity, o.delivered, o.refund, "
				+ "k.no, k.id, k.title, k.contents, k.category, k.price, k.pictures, "
				+ "m.nickname, m.profile "
				+ "FROM mealkit_order o "
				+ "LEFT JOIN mealkit k "
				+ "ON o.mealkit_no=k.no "
				+ "LEFT JOIN member m "
				+ "ON k.id=m.id "
				+ "WHERE o.id=? "
				+ "ORDER BY o.post_date DESC";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, id);
		
		try {
			while (resultSet.next()) {
				HashMap<String, Object> orderedMealkit = new HashMap<String, Object>();
				
				MealkitOrderVO orderVO = new MealkitOrderVO();
				orderVO.setAddress(resultSet.getString("address"));
				orderVO.setQuantity(resultSet.getInt("quantity"));
				orderVO.setDelivered(resultSet.getInt("delivered"));				
				orderVO.setRefund(resultSet.getInt("refund"));			
								
				MealkitVO mealkitVO = new MealkitVO();
				mealkitVO.setNo(resultSet.getInt("no"));
				mealkitVO.setId(resultSet.getString("id"));
				mealkitVO.setTitle(resultSet.getString("title"));
				mealkitVO.setContents(resultSet.getString("contents"));
				mealkitVO.setCategory(resultSet.getInt("category"));
				mealkitVO.setPrice(resultSet.getString("price"));
				mealkitVO.setPictures(resultSet.getString("pictures"));
				
				MemberVO memberVO = new MemberVO();
				memberVO.setNickname(resultSet.getString("nickname"));
				memberVO.setProfile(resultSet.getString("profile"));

				orderedMealkit.put("orderVO", orderVO);
				orderedMealkit.put("mealkitVO", mealkitVO);
				orderedMealkit.put("memberVO", memberVO);
				
				orderedMealkitList.add(orderedMealkit);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return orderedMealkitList;
	}
	
	public ArrayList<HashMap<String, Object>> selectSendedMealkit(String id) {
	    ArrayList<HashMap<String, Object>> orderedMealkitList = new ArrayList<>();
	    String sql = "SELECT "
	               + "k.no, k.title, k.contents, k.category, k.price, k.stock, k.pictures, "
	               + "o.id, o.no AS order_no, o.address, o.quantity, o.delivered, o.refund, "
	               + "m.nickname, m.profile "
	               + "FROM mealkit k "
	               + "INNER JOIN mealkit_order o ON k.no = o.mealkit_no "
	               + "INNER JOIN member m ON o.id = m.id "
	               + "WHERE k.id = ? "
	               + "ORDER BY o.post_date DESC";

	    ResultSet resultSet = dbConnector.executeQuery(sql, id);

	    try {
	        while (resultSet.next()) {
	            HashMap<String, Object> orderedMealkit = new HashMap<>();

	            // Mealkit 데이터 매핑
	            MealkitVO mealkitVO = new MealkitVO();
	            mealkitVO.setNo(resultSet.getInt("no"));
	            mealkitVO.setId(resultSet.getString("id"));
	            mealkitVO.setTitle(resultSet.getString("title"));
	            mealkitVO.setContents(resultSet.getString("contents"));
	            mealkitVO.setCategory(resultSet.getInt("category"));
	            mealkitVO.setPrice(resultSet.getString("price"));
	            mealkitVO.setStock(resultSet.getInt("stock"));
	            mealkitVO.setPictures(resultSet.getString("pictures"));

	            // Order 데이터 매핑
	            MealkitOrderVO orderVO = new MealkitOrderVO();
	            orderVO.setNo(resultSet.getInt("order_no"));
	            orderVO.setId(resultSet.getString("id"));
	            orderVO.setAddress(resultSet.getString("address"));
	            orderVO.setQuantity(resultSet.getInt("quantity"));
	            orderVO.setDelivered(resultSet.getInt("delivered"));
	            orderVO.setRefund(resultSet.getInt("refund"));

	            // Member 데이터 매핑
	            MemberVO memberVO = new MemberVO();
	            memberVO.setNickname(resultSet.getString("nickname"));
	            memberVO.setProfile(resultSet.getString("profile"));

	            // 결과 맵에 추가
	            orderedMealkit.put("orderVO", orderVO);
	            orderedMealkit.put("mealkitVO", mealkitVO);
	            orderedMealkit.put("memberVO", memberVO);

	            orderedMealkitList.add(orderedMealkit);
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }

	    return orderedMealkitList;
	}

	public int updateOrderStatus(int deliveredStatus, int refundStatus, int no) {

		String sql = "UPDATE mealkit_order SET delivered = ?, refund = ? WHERE no = ?";
		int result = dbConnector.executeUpdate(sql, deliveredStatus, refundStatus, no);

		dbConnector.release(); // 자원 해제

		return result; // 업데이트 결과 반환
	}

}