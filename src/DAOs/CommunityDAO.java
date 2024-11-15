package DAOs;

import java.sql.ResultSet;
import java.util.ArrayList;

import Common.DBConnector;
import VOs.CommunityVO;

public class CommunityDAO {

	private DBConnector dbConnecter;
	
	public CommunityDAO() {
		dbConnecter = new DBConnector();
	}

	public ArrayList<CommunityVO> communityListAll() {

		ArrayList<CommunityVO> communities = new ArrayList<CommunityVO>();

		String sql = "select * from community";

		ResultSet resultSet = dbConnecter.executeQuery(sql);
		
		try {
			while (resultSet.next()) {
			
			CommunityVO community = new CommunityVO(
					resultSet.getInt("no"),
					resultSet.getString("id"),
					resultSet.getString("title"),
					resultSet.getString("contents"),
					resultSet.getInt("views"),
					resultSet.getTimestamp("post_date"));
			
			communities.add(community);
			
			}			
		} 
			
		catch (Exception e) {
			e.printStackTrace();
		}
		
		dbConnecter.release();
		
		return communities;
	}
		
}
