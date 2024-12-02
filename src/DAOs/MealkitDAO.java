package DAOs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;

import Common.DBConnector;
import VOs.MealkitOrderVO;
import VOs.MealkitReviewVO;
import VOs.MealkitVO;
import VOs.MealkitWishListVO;
import VOs.MemberVO;

public class MealkitDAO {
	private DBConnector dbConnector;
	
	public MealkitDAO() {
		dbConnector = new DBConnector();
	}

	public ArrayList<MealkitVO> selectMealkits() {
		
		ArrayList<MealkitVO> mealkits = new ArrayList<MealkitVO>();
		
		String sql = "SELECT * FROM mealkit";
		
		ResultSet rs = dbConnector.executeQuery(sql);
		
		try {
			while(rs.next()) {
				MealkitVO mealkit = new MealkitVO(
						rs.getInt("no"), 
						rs.getString("id"),
						rs.getString("title"),
						rs.getString("contents"),
						rs.getInt("category"),
						rs.getString("price"),
						rs.getInt("stock"),
						rs.getString("pictures"),
						rs.getString("orders"),
						rs.getString("origin"),
						rs.getInt("views"),
						rs.getInt("soldout"),
						rs.getTimestamp("post_date"));
				
				mealkits.add(mealkit);
						
			}
		} catch (Exception e) {
			System.out.println("MealkitDAO - selectMealkits 예외발생 ");
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return mealkits;
	}

	public MealkitVO InfoMealkit(int no) {
		
		MealkitVO mealkit = null;
		
		String sql = "SELECT * FROM mealkit WHERE no = ?";
		
		ResultSet rs = dbConnector.executeQuery(sql, no);
		
		try {			
			if(rs.next()) {
				mealkit = new MealkitVO(
						rs.getInt("no"), 
						rs.getString("id"),
						rs.getString("title"),
						rs.getString("contents"),
						rs.getInt("category"),
						rs.getString("price"),
						rs.getInt("stock"),
						rs.getString("pictures"),
						rs.getString("orders"),
						rs.getString("origin"),
						rs.getInt("views"),
						rs.getInt("soldout"),
						rs.getTimestamp("post_date"));
			}
			
		} catch (Exception e) {
			System.out.println("MealkitDAO - InfoMealkit 예외발생 ");
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return mealkit;
	}
	
	public ArrayList<MealkitReviewVO> InfoReview(int no) {
		
		ArrayList<MealkitReviewVO> reviews = new ArrayList<MealkitReviewVO>();
		
		String sql = "SELECT * FROM mealkit_review WHERE mealkit_no = ?";
		
		ResultSet rs = dbConnector.executeQuery(sql, no);
		
		try {
			while(rs.next()) {
				MealkitReviewVO review = new MealkitReviewVO(
						rs.getInt("no"), 
						rs.getString("id"),
						rs.getInt("mealkit_no"),
						rs.getString("pictures"),
						rs.getString("contents"),
						rs.getInt("rating"),
						rs.getInt("empathy"),
						rs.getTimestamp("post_date"));
				
				reviews.add(review);
						
			}
		} catch (Exception e) {
			System.out.println("MealkitDAO - InfoReview 예외발생 ");
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return reviews;
	}

	public int insertMealkitWishlist(int no, String id) {
		
		System.out.println("no " + no);
		System.out.println("id " + id);
		
		String sql = "INSERT INTO mealkit_wishlist(id, mealkit_no, choice_date) "
				+ "VALUES(?, ?, CURRENT_TIMESTAMP)";
		
		int result = dbConnector.executeUpdate(sql, id, no);
		
		dbConnector.release();
		
		return result;
	}

	public int insertNewContent(MealkitVO vo) {
		int no = 0;
		
		String sql = "INSERT INTO mealkit(id, title, contents, category, price, stock, pictures, orders, origin, "
				+ "views, soldout, post_date) VALUES(?,?,?,?,?,?,?,?,?,0,0,NOW())";
		
		dbConnector.executeUpdate(sql, vo.getId(), vo.getTitle(), vo.getContents(), vo.getCategory(),
	            vo.getPrice(), vo.getStock(), vo.getPictures(), vo.getOrders(), vo.getOrigin());
		
		try {
			sql = "SELECT no FROM mealkit WHERE id = ? ORDER BY post_date DESC LIMIT 1";
			
			ResultSet rs = dbConnector.executeQuery(sql, vo.getId());
			
			if (rs.next()) {
				no = rs.getInt(1);
			}
		} catch (Exception e) {
			System.out.println("MealkitDAO - insertNewContent 예외발생 ");
		}
		
		dbConnector.release();
		
		return no;
	}

	public int insertNewReview(MealkitReviewVO vo) {
		int mealkit_no = 0;
		int review_no = 0;
		
		String sql = "SELECT no FROM mealkit WHERE no = ?";
		
		ResultSet rs = dbConnector.executeQuery(sql, vo.getMealkitNo());
		
		try {
			if(rs.next()) {
				mealkit_no = rs.getInt("no");
			}
		} catch (SQLException e) {
			System.out.println("MealkitDAO - insertNewReview 예외발생 ");
			e.printStackTrace();
		}
		
		sql = "INSERT INTO mealkit_review(id, mealkit_no, pictures, contents, rating, empathy, post_date) "
				+ "VALUES(?,?,?,?,?,0,NOW())";

		dbConnector.executeUpdate(sql, vo.getId(), mealkit_no, vo.getPictures(), vo.getContents(),vo.getRating());
		
		// review_no를 가져오기
		sql = "SELECT no FROM mealkit_review WHERE id = ? AND mealkit_no = ? ORDER BY post_date DESC LIMIT 1";
		
		rs = dbConnector.executeQuery(sql, vo.getId(), mealkit_no);
		
		try {
			if(rs.next()) {
				review_no = rs.getInt("no");
			}
		} catch (SQLException e) {
			System.out.println("MealkitDAO - insertNewReview 예외발생 ");
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return review_no;
	}

	public int updateEmpathy(int empathyCount, int mealkit_no, int no) {
		
		String sql = "UPDATE mealkit_review SET empathy = ? + 1 WHERE mealkit_no = ? AND no = ?";
		
		int result = dbConnector.executeUpdate(sql, empathyCount, mealkit_no, no);
		
		dbConnector.release();
		
		return result;
	}

	public int deleteMealkit(int no) {
		
		String sql = "DELETE FROM mealkit_review WHERE mealkit_no = ?";
		
		dbConnector.executeUpdate(sql, no);
		
		sql = "DELETE FROM mealkit WHERE no = ?";
		
		int result = dbConnector.executeUpdate(sql, no);
		
		dbConnector.release();
		
		return result;
	}

	public int updateMealkit(MealkitVO vo) {
		
		String sql = "UPDATE mealkit SET title = ?, contents = ?, price = ?, origin = ?, orders= ?, "
				+ "stock = ?, pictures = ? WHERE no = ?";
		
		int result = dbConnector.executeUpdate(sql, vo.getTitle(), vo.getContents(), vo.getPrice(), 
				vo.getOrigin(), vo.getOrders(), vo.getStock(), vo.getPictures(), vo.getNo());
		
		dbConnector.release();
		
		return result;
	}

	public MealkitVO getMealkitByNo(int no) {
		return InfoMealkit(no);
	}

	public void incrementViewCount(int no) {
		
		String sql = "UPDATE mealkit SET views = views + 1 WHERE no = ?";
		
		dbConnector.executeUpdate(sql, no);
		
		dbConnector.release();
	}

	public float getRatingAvr(int no) {
		
		float avr = 0;
		
		String sql = "select AVG(rating) rating_avr from mealkit_review "
				+ "where mealkit_no = ?";
		
		ResultSet rs = dbConnector.executeQuery(sql, no);
		
		try {
			if(rs.next()) {
				avr = rs.getFloat("rating_avr");
			}
		} catch (SQLException e) {
			System.out.println("MealkitDAAO - getRatingAvr 예외 발생");
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return avr;
	}

	public ArrayList selectSearchList(String key, String word) {
		
		ArrayList<MealkitVO> mealkits = new ArrayList<MealkitVO>();
		String sql = "";
		
		if(!word.equals("")) {
			if(key.equals("title")) {
				sql = "select * from mealkit "
						+ "where title like '%"+word+"%' order by no desc";
			} else {
				sql = "select * from mealkit "
						+ "where id like '%"+word+"%' order by no desc";
			}
		} else{
			sql = "select * from mealkit order by no desc";
		}
		
		ResultSet rs = dbConnector.executeQuery(sql);
		
		try {
			while(rs.next()) {
				MealkitVO mealkit = new MealkitVO(
						rs.getInt("no"), 
						rs.getString("id"),
						rs.getString("title"),
						rs.getString("contents"),
						rs.getInt("category"),
						rs.getString("price"),
						rs.getInt("stock"),
						rs.getString("pictures"),
						rs.getString("orders"),
						rs.getString("origin"),
						rs.getInt("views"),
						rs.getInt("soldout"),
						rs.getTimestamp("post_date"));
				
				mealkits.add(mealkit);				
			}
		} catch (Exception e) {
			System.out.println("MealkitDAO - selectSearchList 예외발생 ");
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return mealkits;
	}

	public ArrayList<HashMap<String, Object>> selectMealKitInfos(String userId) {
	    // 결과를 저장할 ArrayList 선언
	    ArrayList<HashMap<String, Object>> mealKitInfos = new ArrayList<HashMap<String, Object>>();
	    
	    // SQL 쿼리문 정의
	    String sql = "SELECT "
	    		+ "mk.pictures, mk.title, mk.contents, mk.price, m.nickname AS author_nickname, mr.average_rating "
	    		+ "FROM mealkit_wishlist mw "
	    		+ "JOIN mealkit mk ON mw.mealkit_no = mk.no "
	    		+ "JOIN member m ON mk.id = m.id "
	    		+ "LEFT JOIN ( "
	    		+ "SELECT mealkit_no, AVG(rating) AS average_rating "
	    		+ "FROM mealkit_review "
	    		+ "GROUP BY rating "
	    		+ ") mr ON mw.mealkit_no = mr.mealkit_no "
	    		+ "WHERE mw.id = ?";
	    
		ResultSet resultSet = dbConnector.executeQuery(sql, userId);

		try {
			while (resultSet.next()) {
				HashMap<String, Object> mealkitInfo = new HashMap<String, Object>();
				
				MealkitVO mealkitVO = new MealkitVO();
				mealkitVO.setPictures(resultSet.getString("pictures"));
				mealkitVO.setTitle(resultSet.getString("title"));
				mealkitVO.setContents(resultSet.getString("contents"));
				mealkitVO.setPrice(resultSet.getString("price"));
				
				String authorNickname  = resultSet.getString("author_nickname");
				float avgRating = resultSet.getFloat("average_rating");
				
				mealkitInfo.put("mealkitVO", mealkitVO);
				mealkitInfo.put("nickname", authorNickname);
				mealkitInfo.put("avgRating", avgRating);
				
				mealKitInfos.add(mealkitInfo);
				
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}

		dbConnector.release();

		return mealKitInfos;
	}



	public boolean saveOrder(String id, int mealkitNo, int quantity, int delivered, int refund) {

		String sql = "INSERT INTO mealkit_order (id, mealkit_no, address, quantity, delivered, refund, post_date) " +
                 "VALUES (?, ?, (SELECT address FROM member WHERE id = ?), ?, 0, 0, NOW())";
		
		int result = dbConnector.executeUpdate(sql, id, mealkitNo, id, quantity);
		
		return result == 1;
	}

	public ArrayList<HashMap<String, Object>> selectCartList(String userId) {
	    // 결과를 저장할 ArrayList 선언
	    ArrayList<HashMap<String, Object>> cartListInfos = new ArrayList<HashMap<String, Object>>();
	    
	    // SQL 쿼리문 정의
	    String sql = "SELECT "
	    		+ "mk.pictures, mk.title, m.nickname AS author_nickname, mk.price "
	    		+ "FROM mealkit_cart mc "
	    		+ "JOIN mealkit mk ON mc.mealkit_no = mk.no "
	    		+ "JOIN member m ON mk.id = m.id "
	    		+ "WHERE mc.id=?";
	    
		ResultSet resultSet = dbConnector.executeQuery(sql, userId);

		try {
			while (resultSet.next()) {
				HashMap<String, Object> cartListInfo = new HashMap<String, Object>();
				
				MealkitVO mealkitVO = new MealkitVO();
				mealkitVO.setPictures(resultSet.getString("pictures"));
				mealkitVO.setTitle(resultSet.getString("title"));
				mealkitVO.setPrice(resultSet.getString("price"));
				
				String authorNickname  = resultSet.getString("author_nickname");
				
				cartListInfo.put("mealkitVO", mealkitVO);
				cartListInfo.put("nickname", authorNickname);
				
				cartListInfos.add(cartListInfo);
				
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}

		dbConnector.release();

		return cartListInfos;
	}

	public ArrayList<Integer> selectCountOrderDelivered(String id) {
		
		ArrayList<Integer> counts = new ArrayList<Integer>();
		
		String sql = "";
		
		for (int i = 0; i < 3; i++) {
			sql = "SELECT COUNT(*) " + 
					"FROM mealkit_order o " + 
					"WHERE o.delivered=? AND o.id=?";
			
			ResultSet resultSet = dbConnector.executeQuery(sql, i, id);
			
			try {
				if (resultSet.next()) {
					counts.add(resultSet.getInt(1));
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			dbConnector.release();
		}
		
		return counts;
	}
	
//발송 
public ArrayList<Integer> selectCountDelivered(String id) {
		
		ArrayList<Integer> counts = new ArrayList<Integer>();
		
		String sql = "";
		
		for (int i = 0; i < 3; i++) {
			sql = "SELECT COUNT(*) " + 
					"FROM mealkit_order o " + 
					"WHERE o.delivered=? AND o.id=?";
			
			ResultSet resultSet = dbConnector.executeQuery(sql, i, id);
			
			try {
				if (resultSet.next()) {
					counts.add(resultSet.getInt(1));
				}
			} catch (SQLException e) {
				e.printStackTrace();
			}
			
			dbConnector.release();
		}
		
		return counts;
	}

	public void updateDelivery(String orderId, String deliveryStatus) throws SQLException {
	    // SQL 쿼리 작성 (배송 상태를 업데이트)
	    String sql = "UPDATE mealkit_order SET delivered = ? WHERE order_id = ?";
	
	    // 데이터베이스 연결
		ResultSet resultSet = dbConnector.executeQuery(sql, orderId, deliveryStatus);
	
		// executeQuery 대신 executeUpdate를 사용해야 하므로, resultSet을 사용하지 않음
		dbConnector.executeUpdate(sql, orderId, deliveryStatus); // 실행
	}
	
	public void updateOrderStatus(String orderId, String deliveryStatus, String refundStatus) throws SQLException {
	    String sql = "UPDATE mealkit_order SET delivered = ?, refund = ? WHERE no = ?";
	    dbConnector.executeUpdate(sql, Integer.parseInt(deliveryStatus), Integer.parseInt(refundStatus), Integer.parseInt(orderId));
	}

}
