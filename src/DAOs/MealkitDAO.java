package DAOs;

import java.sql.ResultSet;
import java.util.ArrayList;

import Common.DBConnector;
import VOs.MealkitOrderVO;
import VOs.MealkitVO;
import VOs.MealkitWishListVO;

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
						rs.getString("content"),
						rs.getInt("category"),
						rs.getString("price"),
						rs.getInt("stock"),
						rs.getString("pictures"),
						rs.getString("orders"),
						rs.getString("origin"),
						rs.getFloat("rating"),
						rs.getInt("views"),
						rs.getInt("soldout"),
						rs.getTimestamp("post_date"));
				
				mealkits.add(mealkit);
						
			}
		} catch (Exception e) {
			System.out.println("MealkitDAO - selectMealkits 예외발생 ");
			e.printStackTrace();
		}
		
		dbConnector.Release();
		
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
						rs.getString("content"),
						rs.getInt("category"),
						rs.getString("price"),
						rs.getInt("stock"),
						rs.getString("pictures"),
						rs.getString("orders"),
						rs.getString("origin"),
						rs.getFloat("rating"),
						rs.getInt("views"),
						rs.getInt("soldout"),
						rs.getTimestamp("post_date"));
			}
			
		} catch (Exception e) {
			System.out.println("MealkitDAO - InfoMealkit 예외발생 ");
			e.printStackTrace();
		}
		
		dbConnector.Release();
		
		return mealkit;
	}

	public int addMyMealkit(int no, int type) {
		// 장바구니 1, 찜목록 0
		String sql = "SELECT id FROM mealkit WHERE no = ?";
		String id = null;
		
		int result = 0;
		
		try {
			ResultSet rs = dbConnector.executeQuery(sql, no);
			
			if(rs.next()) {
				id = rs.getString("id");
			}
			
			rs.close();
		} catch (Exception e) {
			System.out.println("MealkitDAO - addMyMealkit");
			e.printStackTrace();
		}
		
		if(id != null) {
			sql = "INSERT INTO mealkit_wishlist(id, mealkit_no, type) VALUES (?,?,?)";
			result = dbConnector.executeUpdate(sql, id, no, type);
		} else {
			System.out.println("일치하는 ID가 없습니다.");
		}
		
		return result;
	}
}
