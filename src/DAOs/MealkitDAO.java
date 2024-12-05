package DAOs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import Common.DBConnector;
import VOs.MealkitReviewVO;
import VOs.MealkitVO;
import VOs.MemberVO;
import VOs.RecipeVO;

public class MealkitDAO {
	private DBConnector dbConnector;

	public MealkitDAO() {
		dbConnector = new DBConnector();
	}

	public ArrayList<Map<String, Object>> selectMealkits(int category) {

		ArrayList<Map<String, Object>> mealkits = new ArrayList<>();

		String sql = "SELECT mk.*, mem.nickname " + "FROM mealkit mk JOIN member mem " + "ON mk.id = mem.id ";

		if (category != 0)
			sql += "WHERE mk.category=? ";

		sql += "ORDER BY mk.post_date DESC";

		ResultSet rs = (category != 0 ? dbConnector.executeQuery(sql, category) : dbConnector.executeQuery(sql));

		try {
			while (rs.next()) {
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
	
	public HashMap<String, Object> selectMealkit(String no) {
		
		HashMap<String, Object> mealkit = new HashMap<String, Object>();
		
		String sql = "SELECT "
				+ "k.*, coalesce(avg_table.avg_rating, 0) AS average_rating, m.nickname "
				+ "FROM mealkit k "
				+ "LEFT JOIN ( "
				+ "SELECT "
				+ "mr.mealkit_no, AVG(rating) as avg_rating "
				+ "FROM mealkit_review mr "
				+ "GROUP BY mr.mealkit_no "
				+ ") avg_table ON k.no=avg_table.mealkit_no "
				+ "JOIN member m "
				+ "ON k.id=m.id "
				+ "WHERE no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, Integer.parseInt(no));
		
		try {
			if (resultSet.next()) {
				MealkitVO mealkitVO = new MealkitVO(
						resultSet.getInt("no"), 
						resultSet.getString("id"), 
						resultSet.getString("title"), 
						resultSet.getString("contents"), 
						resultSet.getInt("category"), 
						resultSet.getString("price"), 
						resultSet.getInt("stock"), 
						resultSet.getString("pictures"), 
						resultSet.getString("orders"), 
						resultSet.getString("origin"), 
						resultSet.getInt("views"), 
						resultSet.getInt("soldout"), 
						resultSet.getTimestamp("post_date"));
				
				float averageRating = resultSet.getFloat("average_rating");
				
				MemberVO memberVO = new MemberVO();
				memberVO.setNickname(resultSet.getString("nickname"));
				
				mealkit.put("mealkitVO", mealkitVO);
				mealkit.put("averageRating", averageRating);
				mealkit.put("memberVO", memberVO);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return mealkit;
	}

	public MealkitVO InfoMealkit(int no) {

		MealkitVO mealkit = null;

		String sql = "SELECT * FROM mealkit WHERE no = ?";

		ResultSet rs = dbConnector.executeQuery(sql, no);

		try {
			if (rs.next()) {
				mealkit = new MealkitVO(rs.getInt("no"), rs.getString("id"), rs.getString("title"),
						rs.getString("contents"), rs.getInt("category"), rs.getString("price"), rs.getInt("stock"),
						rs.getString("pictures"), rs.getString("orders"), rs.getString("origin"), rs.getInt("views"),
						rs.getInt("soldout"), rs.getTimestamp("post_date"));
			}

		} catch (Exception e) {
			System.out.println("MealkitDAO - InfoMealkit 예외발생 ");
			e.printStackTrace();
		}

		dbConnector.release();

		return mealkit;
	}

	public ArrayList<HashMap<String, Object>> InfoReview(int no) {

		ArrayList<HashMap<String, Object>> reviews = new ArrayList<>();

		String sql = "SELECT mr.*, mem.nickname FROM mealkit_review mr JOIN member mem " + "ON mr.id = mem.id "
				+ "WHERE mr.mealkit_no = ?";

		ResultSet rs = dbConnector.executeQuery(sql, no);

		try {
			while (rs.next()) {
				HashMap<String, Object> review = new HashMap<>();
				
				MealkitReviewVO reviewVO = new MealkitReviewVO(
						rs.getInt("no"), 
						rs.getString("id"), 
						rs.getInt("mealkit_no"), 
						rs.getString("pictures"), 
						rs.getString("contents"), 
						rs.getInt("rating"), 
						rs.getTimestamp("post_date"));
				
				MemberVO memberVO = new MemberVO();
				memberVO.setNickname(rs.getString("nickname"));
				
				review.put("reviewVO", reviewVO);
				review.put("memberVO", memberVO);
				
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

		String sql = "INSERT INTO mealkit_wishlist(id, mealkit_no, choice_date) " + "VALUES(?, ?, CURRENT_TIMESTAMP)";

		int result = dbConnector.executeUpdate(sql, id, no);

		dbConnector.release();

		return result;
	}

	public int insertMealkitCartlist(int mealkitNo, int quantity, String id) {

		String sql = "INSERT INTO mealkit_cart(id, mealkit_no, quantity, choice_date) "
				+ "VALUES(?, ?, ?, CURRENT_TIMESTAMP)";

		int result = dbConnector.executeUpdate(sql, id, mealkitNo, quantity);

		dbConnector.release();

		return result;
	}

	public int insertNewContent(MealkitVO vo) {
		int no = 0;

		String sql = "INSERT INTO mealkit(id, title, contents, category, price, stock, pictures, orders, origin, "
				+ "views, soldout, post_date) VALUES(?,?,?,?,?,?,?,?,?,0,0,NOW())";

		dbConnector.executeUpdate(sql, vo.getId(), vo.getTitle(), vo.getContents(), vo.getCategory(), vo.getPrice(),
				vo.getStock(), vo.getPictures(), vo.getOrders(), vo.getOrigin());

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

		int result = 0;

		String sql = "INSERT INTO mealkit_review(id, mealkit_no, pictures, contents, rating, post_date) "
				+ "VALUES(?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

		result = dbConnector.executeUpdate(sql, vo.getId(), vo.getMealkitNo(), vo.getPictures(), vo.getContents(),
				vo.getRating());

		dbConnector.release();

		return result;
	}

	public String selectNickName(String id) {

		String nickName = null;

		String sql = "SELECT nickname FROM member WHERE id = ?";

		ResultSet rs = dbConnector.executeQuery(sql, id);

		try {
			if (rs.next()) {
				nickName = rs.getString("nickname");
			}
		} catch (SQLException e) {
			System.out.println("MealkitDAO - selectNickName 예외발생");
			e.printStackTrace();
		}

		dbConnector.release();

		return nickName;
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

		int result = dbConnector.executeUpdate(sql, vo.getTitle(), vo.getContents(), vo.getPrice(), vo.getOrigin(),
				vo.getOrders(), vo.getStock(), vo.getPictures(), vo.getNo());

		dbConnector.release();

		return result;
	}

	public void incrementViewCount(int no) {

		String sql = "UPDATE mealkit SET views = views + 1 WHERE no = ?";

		dbConnector.executeUpdate(sql, no);

		dbConnector.release();
	}

	public float getRatingAvr(int no) {

		float avr = 0;

		String sql = "select AVG(rating) rating_avr from mealkit_review " + "where mealkit_no = ?";

		ResultSet rs = dbConnector.executeQuery(sql, no);

		try {
			if (rs.next()) {
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

		if (!word.equals("")) {
			if (key.equals("title")) {
				sql = "select * from mealkit " + "where title like '%" + word + "%' order by no desc";
			} else {
				sql = "select * from mealkit " + "where id like '%" + word + "%' order by no desc";
			}
		} else {
			sql = "select * from mealkit order by no desc";
		}

		ResultSet rs = dbConnector.executeQuery(sql);

		try {
			while (rs.next()) {
				MealkitVO mealkit = new MealkitVO(rs.getInt("no"), rs.getString("id"), rs.getString("title"),
						rs.getString("contents"), rs.getInt("category"), rs.getString("price"), rs.getInt("stock"),
						rs.getString("pictures"), rs.getString("orders"), rs.getString("origin"), rs.getInt("views"),
						rs.getInt("soldout"), rs.getTimestamp("post_date"));

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

		String sql = "SELECT "
				+ "mk.no, mk.id, mk.pictures, mk.title, mk.contents, mk.price, m.nickname AS author_nickname, mr.average_rating "
				+ "FROM mealkit_wishlist mw " + "JOIN mealkit mk ON mw.mealkit_no = mk.no "
				+ "JOIN member m ON mk.id = m.id " + "LEFT JOIN ( "
				+ "SELECT mealkit_no, AVG(rating) AS average_rating " + "FROM mealkit_review " + "GROUP BY mealkit_no "
				+ ") mr ON mw.mealkit_no = mr.mealkit_no " + "WHERE mw.id = ?" + "ORDER BY mw.choice_date DESC;";

		ResultSet resultSet = dbConnector.executeQuery(sql, userId);

		try {
			while (resultSet.next()) {
				HashMap<String, Object> mealkitInfo = new HashMap<String, Object>();

				MealkitVO mealkitVO = new MealkitVO();
				mealkitVO.setNo(resultSet.getInt("no"));
				mealkitVO.setId(resultSet.getString("id"));
				mealkitVO.setPictures(resultSet.getString("pictures"));
				mealkitVO.setTitle(resultSet.getString("title"));
				mealkitVO.setContents(resultSet.getString("contents"));
				mealkitVO.setPrice(resultSet.getString("price"));

				String authorNickname = resultSet.getString("author_nickname");
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
	public int insertMealkitOrder(String id, String[] mealkitNos, String[] quantities, String address, String isCart) {

		String sql = "INSERT INTO mealkit_order (id, mealkit_no, address, quantity, delivered, refund, post_date) "
				+ "VALUES ";		
		for (int i = 0; i < mealkitNos.length; i++) {
			sql += "('" + id + "', '" + mealkitNos[i] + "', '" + address + "', " + quantities[i] + ", 0, 0, NOW())" ;
			
			if (i != mealkitNos.length - 1) sql += ", ";
		}
		
		int result = dbConnector.executeUpdate(sql);
		
		dbConnector.release();
		
		System.out.println("isCart : " + isCart);
		System.out.println("Integer.parseInt(isCart) : " + Integer.parseInt(isCart));
		
		if (result <= 0 || Integer.parseInt(isCart) == 0) return result;
		
		sql = "DELETE FROM mealkit_cart WHERE";
		for (int i = 0; i < mealkitNos.length; i++) {
			sql += " mealkit_no=" + mealkitNos[i];
			if (i != mealkitNos.length - 1) sql += " OR";
		}

		result = dbConnector.executeUpdate(sql);
		
		dbConnector.release();

		return result;
	}

	public ArrayList<HashMap<String, Object>> selectMealkitReviewsById(String id) {

		ArrayList<HashMap<String, Object>> reviews = new ArrayList<HashMap<String, Object>>();

		String sql = "SELECT " + "k.title, k.category, "
				+ "kr.no, kr.mealkit_no, kr.pictures, kr.contents, kr.rating, kr.post_date, " + "m.nickname "
				+ "FROM mealkit_review kr " + "JOIN mealkit k " + "ON kr.mealkit_no=k.no " + "JOIN member m "
				+ "ON k.id=m.id " + "WHERE kr.id=? " + "ORDER BY kr.post_date DESC";

		ResultSet resultSet = dbConnector.executeQuery(sql, id);

		try {
			while (resultSet.next()) {
				HashMap<String, Object> review = new HashMap<String, Object>();

				MealkitVO mealkitVO = new MealkitVO();
				mealkitVO.setNo(resultSet.getInt("mealkit_no"));
				mealkitVO.setTitle(resultSet.getString("title"));
				mealkitVO.setCategory(resultSet.getInt("category"));

				MealkitReviewVO reviewVO = new MealkitReviewVO();
				reviewVO.setNo(resultSet.getInt("no"));
				reviewVO.setMealkitNo(resultSet.getInt("mealkit_no"));
				reviewVO.setPictures(resultSet.getString("pictures"));
				reviewVO.setContents(resultSet.getString("contents"));
				reviewVO.setRating(resultSet.getInt("rating"));
				reviewVO.setPostDate(resultSet.getTimestamp("post_date"));

				MemberVO memberVO = new MemberVO();
				memberVO.setNickname(resultSet.getString("nickname"));

				review.put("mealkit", mealkitVO);
				review.put("review", reviewVO);
				review.put("member", memberVO);

				reviews.add(review);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return reviews;
	}

	public ArrayList<HashMap<String, Object>> selectMealkitsById(String id) {

		ArrayList<HashMap<String, Object>> mealkits = new ArrayList<HashMap<String, Object>>();

		String sql = "SELECT m.*, COALESCE(avg_rating.average_rating, 0) AS average_rating " + "FROM mealkit m "
				+ "LEFT JOIN ( " + "SELECT mealkit_no, AVG(rating) AS average_rating " + "FROM mealkit_review "
				+ "GROUP BY mealkit_no " + ") avg_rating ON m.no = avg_rating.mealkit_no " + "WHERE m.id=?";

		ResultSet rs = dbConnector.executeQuery(sql, id);

		try {
			while (rs.next()) {

				HashMap<String, Object> mealkit = new HashMap<String, Object>();

				MealkitVO mealkitVO = new MealkitVO(rs.getInt("no"), rs.getString("id"), rs.getString("title"),
						rs.getString("contents"), rs.getInt("category"), rs.getString("price"), rs.getInt("stock"),
						rs.getString("pictures"), rs.getString("orders"), rs.getString("origin"), rs.getInt("views"),
						rs.getInt("soldout"), rs.getTimestamp("post_date"));

				float averageRating = rs.getFloat("average_rating");

				mealkit.put("mealkitVO", mealkitVO);
				mealkit.put("averageRating", averageRating);

				mealkits.add(mealkit);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		return mealkits;
	}

	public ArrayList<HashMap<String, Object>> selectCartList(String userId) {
		
		ArrayList<HashMap<String, Object>> cartListInfos = new ArrayList<>();
		String sql = "SELECT "
				+ "mk.no, mk.id, mk.pictures, mk.title, mk.price, mk.stock, "
				+ "m.nickname AS author_nickname, "
				+ "mc.quantity "
				+ "FROM mealkit_cart mc " 
				+ "JOIN mealkit mk ON mc.mealkit_no = mk.no "
				+ "JOIN member m ON mk.id = m.id "
				+ "WHERE mc.id = ?";

		 try (ResultSet resultSet = dbConnector.executeQuery(sql, userId)) {
		        if (resultSet == null) {
		            System.err.println("ResultSet is null");
		        }

		        while (resultSet != null && resultSet.next()) {
		        	
		        	 // 값 출력 (디버깅용)
		            System.out.println("mealkitNo: " + resultSet.getInt("no"));
		            System.out.println("mealkitTitle: " + resultSet.getString("title"));
		            System.out.println("price: " + resultSet.getString("price"));
		            
		            HashMap<String, Object> cartListInfo = new HashMap<>();
			
				MealkitVO mealkitVO = new MealkitVO();
				mealkitVO.setNo(resultSet.getInt("no"));
				mealkitVO.setId(resultSet.getString("id"));
				mealkitVO.setPictures(resultSet.getString("pictures"));
				mealkitVO.setTitle(resultSet.getString("title"));
				mealkitVO.setPrice(resultSet.getString("price"));
				mealkitVO.setStock(resultSet.getInt("stock"));

				String authorNickname = resultSet.getString("author_nickname");
				int quantity = resultSet.getInt("quantity"); // quantity 추가

				cartListInfo.put("mealkitVO", mealkitVO);
				cartListInfo.put("nickname", authorNickname);
				cartListInfo.put("quantity", quantity); // 수량 추가
				cartListInfos.add(cartListInfo);
				
			}
		} catch (SQLException e) {
			System.err.println("Error while fetching cart list: " + e.getMessage());
		}

		return cartListInfos;
	}

	public ArrayList<Integer> selectCountOrderDelivered(String id) {

		ArrayList<Integer> counts = new ArrayList<Integer>();

		String sql = "";

		for (int i = 0; i < 3; i++) {
			sql = "SELECT COUNT(*) " + "FROM mealkit_order o " + "WHERE o.delivered=? AND o.id=?";

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

	public ArrayList<Integer> selectCountOrderSended(String id) {

		ArrayList<Integer> counts = new ArrayList<Integer>();

		String sql = "";

		for (int i = 0; i < 3; i++) {
			sql = "SELECT COUNT(*) " + 
					"FROM mealkit k " + 
					"JOIN mealkit_order o " + 
					"ON k.no=o.mealkit_no " + 
					"WHERE k.id=? AND o.delivered=?";

			ResultSet resultSet = dbConnector.executeQuery(sql, id, i);

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

	public int deleteWishMealkit(String userId, String mealkitNo) {
		String sql = "SELECT * FROM mealkit_wishlist WHERE id=? AND mealkit_no=?";

		// 위시리스트에서 해당 레시피가 있는지 확인
		ResultSet resultSet = dbConnector.executeQuery(sql, userId, Integer.parseInt(mealkitNo));

		try {
			// 레시피가 존재하지 않으면 삭제할 필요 없음
			if (!resultSet.next()) {
				return 0; // 레시피가 위시리스트에 없으므로 삭제 실패
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return 0; // 예외 발생 시 삭제 실패 처리
		}

		// 레시피가 있으면 삭제 작업 수행
		sql = "DELETE FROM mealkit_wishlist WHERE id=? AND mealkit_no=?";

		int result = dbConnector.executeUpdate(sql, userId, mealkitNo);

		dbConnector.release();

		return result; // 삭제 성공 시 1 반환, 실패 시 0 반환
	}

	public int deleteCartList(String userId, String mealkitNo) {

		// 값이 제대로 넘어오는지 확인
		System.out.println("다오userId: " + userId);
		System.out.println("다오mealkitNo: " + mealkitNo);

		String sql = "SELECT * FROM mealkit_cart WHERE id=? AND mealkit_no=?";

		// 위시리스트에서 해당 레시피가 있는지 확인
		ResultSet resultSet = dbConnector.executeQuery(sql, userId, Integer.parseInt(mealkitNo));

		try {
			// 레시피가 존재하지 않으면 삭제할 필요 없음
			if (!resultSet.next()) {
				return 0; // 레시피가 위시리스트에 없으므로 삭제 실패
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return 0; // 예외 발생 시 삭제 실패 처리
		}

		// 레시피가 있으면 삭제 작업 수행
		sql = "DELETE FROM mealkit_cart WHERE id=? AND mealkit_no=?";

		int result = dbConnector.executeUpdate(sql, userId, mealkitNo);

		dbConnector.release();

		return result; // 삭제 성공 시 1 반환, 실패 시 0 반환
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
		dbConnector.executeUpdate(sql, Integer.parseInt(deliveryStatus), Integer.parseInt(refundStatus),
				Integer.parseInt(orderId));
	}

	public int insertRecentView(String id, int mealkitNo) {
		
		String sql = "SELECT COUNT(*) AS result FROM recent_view WHERE id=? AND item_no=? AND type=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, id, mealkitNo, 1);
		
		boolean isExistRecent = false;
		try {
			if (resultSet.next()) {
				int result = resultSet.getInt("result");
				
				isExistRecent = result > 0;
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		int result = 0;
		
		if (!isExistRecent) {
			
			sql = "INSERT INTO recent_view(id, item_no, type, view_date) "
					+ "VALUES(?, ?, 1, CURRENT_TIMESTAMP)";
			
			result = dbConnector.executeUpdate(sql, id, mealkitNo);
			
			dbConnector.release();
		}
		
		return result;
	}
	
	public int deleteMealkitReview(int no, int mealkitNo) {
		
		String sql = "DELETE FROM mealkit_review WHERE mealkit_no = ? AND no = ?";
		
		int result = dbConnector.executeUpdate(sql, mealkitNo, no);
		
		dbConnector.release();
		
		return result;
	}

	public String selectMealkitNickName(MealkitVO mealkit) {
		String nickName = null;
		
		String sql = "SELECT nickName FROM member JOIN mealkit "
				+ "ON member.id = mealkit.id "
				+ "WHERE mealkit.no = ?";
		
		ResultSet rs = dbConnector.executeQuery(sql, mealkit.getNo());
		
		try {
			if(rs.next()) nickName = rs.getString("nickName");
		} catch (SQLException e) {
			System.out.println("MealkitDAO - selectMealkitNickName 예외발생");
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return nickName;
	}

	public MealkitReviewVO selectReview(int reviewNo) {
		
		MealkitReviewVO reviewvo = null;
		
		String sql = "SELECT * FROM mealkit_review WHERE no = ?";
		
		ResultSet rs = dbConnector.executeQuery(sql, reviewNo);
		
		try {
			if(rs.next()) {
				reviewvo = new MealkitReviewVO(
						rs.getInt("no"),
						rs.getString("id"),
						rs.getInt("mealkit_no"),
						rs.getString("pictures"),
						rs.getString("contents"),
						rs.getInt("rating"));
			}
		} catch (SQLException e) {
			System.out.println("MealkitDAO - selectReview 예외발생");
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return reviewvo;
	}
	
	public MealkitVO InfoMealkitReview(int no) {
		MealkitVO mealkit = null;

		String sql = "SELECT * FROM mealkit WHERE no = "
				+ "(SELECT mealkit_no FROM mealkit_review WHERE no = ?);";

		ResultSet rs = dbConnector.executeQuery(sql, no);

		try {
			if (rs.next()) {
				mealkit = new MealkitVO(rs.getInt("no"), rs.getString("id"), rs.getString("title"),
						rs.getString("contents"), rs.getInt("category"), rs.getString("price"), rs.getInt("stock"),
						rs.getString("pictures"), rs.getString("orders"), rs.getString("origin"), rs.getInt("views"),
						rs.getInt("soldout"), rs.getTimestamp("post_date"));
			}

		} catch (Exception e) {
			System.out.println("MealkitDAO - InfoMealkitReview 예외발생 ");
			e.printStackTrace();
		}

		dbConnector.release();

		return mealkit;
	}

	public void updateReview(MealkitReviewVO review) {
		
		String sql = "UPDATE mealkit_review SET pictures = ?, contents = ?, rating = ? "
				+ "WHERE no = ?";
		
		dbConnector.executeUpdate(sql, review.getPictures(), review.getContents(), review.getRating(), review.getNo());
		
		dbConnector.release();
	}

	public int updateCartList(String userId, String mealkitNo, int quantity) {

	    String sql = "SELECT * FROM mealkit_cart WHERE id=? AND mealkit_no=?";
	    
	    ResultSet resultSet = dbConnector.executeQuery(sql, userId, Integer.parseInt(mealkitNo));

	    try {

	        if (!resultSet.next()) {
	            return 0; 
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return 0;
	    }


	    sql = "UPDATE mealkit_cart SET quantity=? WHERE id=? AND mealkit_no=?";
	    
	    int result = dbConnector.executeUpdate(sql, quantity, userId, mealkitNo);

	    dbConnector.release(); 

	    return result; 
	}

	public boolean updateOrder(String userId, int mealkitNo, int quantity, String fullAddress) {
		 // 주문 정보 삽입
	    String sql = "INSERT INTO mealkit_order (id, mealkit_no, address, quantity, delivered, refund, post_date) "
	               + "VALUES (?, ?, ?, ?, 0, 0, NOW())";  // delivered와 refund는 기본값 0으로 설정
	    int result = dbConnector.executeUpdate(sql, userId, mealkitNo, fullAddress, quantity);

	    // 재고 업데이트
	    sql = "UPDATE mealkit SET stock = stock - ? WHERE no = ?";
	    dbConnector.executeUpdate(sql, quantity, mealkitNo);

	    return result == 1;  // 성공적으로 주문이 저장되었으면 true 반환
	}
	
	public ArrayList<HashMap<String, Object>> selectPurchaseMealkits(String[] nos, String[] quantities) {
		
		ArrayList<HashMap<String, Object>> mealkits = new ArrayList<HashMap<String,Object>>();
		
		String sql = "SELECT "
				+ "k.no, k.title, k.category, k.price, k.pictures, "
				+ "m.nickname "
				+ "FROM mealkit k "
				+ "JOIN member m "
				+ "ON k.id=m.id "
				+ "WHERE k.no=? ";
		
		for (int i = 1; i < nos.length; i++) {
			sql += " OR k.no=?";
		}
		
		//Object[] objNo = new Object[no.length];
		
		ResultSet resultSet = dbConnector.executeQuery(sql, nos);
		
		try {
			int i = 0;
			while (resultSet.next()) {
				HashMap<String, Object> mealkit = new HashMap<String, Object>();
				
				MealkitVO mealkitVO = new MealkitVO();
				mealkitVO.setNo(resultSet.getInt("no"));
				mealkitVO.setTitle(resultSet.getString("title"));
				mealkitVO.setCategory(resultSet.getInt("category"));
				mealkitVO.setPrice(resultSet.getString("price"));
				mealkitVO.setPictures(resultSet.getString("pictures"));
				
				MemberVO memberVO = new MemberVO();
				memberVO.setNickname(resultSet.getString("nickname"));
				
				mealkit.put("mealkitVO", mealkitVO);
				mealkit.put("memberVO", memberVO);
				mealkit.put("quantity", quantities[i++]);
				
				mealkits.add(mealkit);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return mealkits;
	}
}
