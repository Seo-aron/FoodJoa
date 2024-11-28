package DAOs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import Common.DBConnector;
import VOs.MealkitReviewVO;
import VOs.MealkitVO;

public class MealkitDAO {
	private DBConnector dbConnector;
	
	public MealkitDAO() {
		dbConnector = new DBConnector();
	}

	public ArrayList<Map<String, Object>> selectMealkits() {
		
		ArrayList<Map<String, Object>> mealkits = new ArrayList<>();
		
		String sql = "SELECT mk.*, mem.nickname " 
				+ "FROM mealkit mk JOIN member mem "
                + "ON mk.id = mem.id";
		
		ResultSet rs = dbConnector.executeQuery(sql);
		
		try {
			while(rs.next()) {
				Map<String, Object> mealkitData = new HashMap<>();
					mealkitData.put("no", rs.getInt("no"));
		            mealkitData.put("id", rs.getString("id"));
		            mealkitData.put("title", rs.getString("title"));
		            mealkitData.put("contents", rs.getString("contents"));
		            mealkitData.put("category", rs.getInt("category"));
		            mealkitData.put("price", rs.getString("price"));
		            mealkitData.put("stock", rs.getInt("stock"));
		            mealkitData.put("pictures", rs.getString("pictures"));
		            mealkitData.put("orders", rs.getString("orders"));
		            mealkitData.put("origin", rs.getString("origin"));
		            mealkitData.put("views", rs.getInt("views"));
		            mealkitData.put("soldout", rs.getInt("soldout"));
		            mealkitData.put("post_date", rs.getTimestamp("post_date"));

		            mealkitData.put("nickname", rs.getString("nickname"));

		            mealkits.add(mealkitData);						
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
	
	public ArrayList<Map<String, Object>> InfoReview(int no) {
		
		ArrayList<Map<String, Object>> reviews = new ArrayList<>();
		
		String sql = "SELECT mr.*, mem.nickname FROM mealkit_review mr JOIN member mem "
				+ "ON mr.id = mem.id "
				+ "WHERE mr.mealkit_no = ?";
		
		ResultSet rs = dbConnector.executeQuery(sql, no);
		
		try {
			while(rs.next()) {
				Map<String, Object> reviewsData = new HashMap<>();
				reviewsData.put("no", rs.getInt("no"));
				reviewsData.put("id", rs.getString("id"));
				reviewsData.put("mealkit_no", rs.getInt("mealkit_no"));
				reviewsData.put("pictures", rs.getString("pictures"));
				reviewsData.put("contents", rs.getString("contents"));
				reviewsData.put("rating", rs.getInt("rating"));
				reviewsData.put("empathy", rs.getInt("empathy"));
				reviewsData.put("post_date", rs.getTimestamp("post_date"));
				
				reviewsData.put("nickname", rs.getString("nickname"));
				
				reviews.add(reviewsData);
						
			}
		} catch (Exception e) {
			System.out.println("MealkitDAO - InfoReview 예외발생 ");
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return reviews;
	}

	public int insertMealkitWishlist(int no, String id, int type) {
		
		System.out.println("no " + no);
		System.out.println("id " + id);
		System.out.println("type " + type);
		/*
		String sql = "INSERT INTO mealkit_wishlist(id, mealkit_no, type, choice_date) "
				+ "VALUES(?, ?, ?, CURRENT_TIMESTAMP)";
		*/
		String sql = "INSERT INTO mealkit_wishlist(id, mealkit_no, type) "
				+ "VALUES(?, ?, ?)";
		
		int result = dbConnector.executeUpdate(sql, id, no, type);
		
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

	public String selectNickName(String id) {
		
		String nickName = null;
		
		String sql = "SELECT nickname FROM member WHERE id = ?";
		
		ResultSet rs = dbConnector.executeQuery(sql, id);
		
		try {
			if(rs.next()) {
				nickName = rs.getString("nickname");
			}
		} catch (SQLException e) {
			System.out.println("MealkitDAO - selectNickName 예외발생");
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return nickName;
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

	public ArrayList<MealkitVO> selectSearchList(String key, String word) {
		
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
	
	public ArrayList<HashMap<String, Object>> selectMealKitInfos(String userId, int type) {
		
	    ArrayList<HashMap<String, Object>> mealKitInfos = new ArrayList<HashMap<String, Object>>();
	    
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
	    		+ "WHERE mw.id = ? AND mw.type = ?";
	    
		ResultSet resultSet = dbConnector.executeQuery(sql, userId, type);

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


	// 결제 api 
	public boolean saveOrder(String id, int mealkitNo, int quantity, int delivered, int refund) {

		String sql = "INSERT INTO mealkit_order (id, mealkit_no, address, quantity, delivered, refund, post_date) " +
                 "VALUES (?, ?, (SELECT address FROM member WHERE id = ?), ?, 0, 0, NOW())";
		
		int result = dbConnector.executeUpdate(sql, id, mealkitNo, id, quantity);
		
		return result == 1;
	}

}
