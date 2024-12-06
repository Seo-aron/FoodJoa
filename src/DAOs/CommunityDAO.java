package DAOs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;

import Common.DBConnector;
import VOs.CommunityShareVO;
import VOs.CommunityVO;
import VOs.MemberVO;
import VOs.NoticeVO;

public class CommunityDAO {

	private DBConnector dbConnector;

	public CommunityDAO() {
		
		dbConnector = new DBConnector();
	}
	
	public ArrayList<HashMap<String, Object>> communityListAll() {
		
		ArrayList<HashMap<String, Object>> communities = new ArrayList<HashMap<String, Object>>();

		String sql = "select c.*, m.nickname "
				+ "FROM community c "
				+ "LEFT OUTER JOIN member m "
				+ "ON c.id = m.id "
				+ "order by post_date desc";
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
		try {
			while (resultSet.next()) {
				HashMap<String, Object> data = new HashMap<String, Object>();
				
				CommunityVO community = new CommunityVO(
						resultSet.getInt("no"),
						resultSet.getString("id"),
						resultSet.getString("title"),
						resultSet.getString("contents"),
						resultSet.getInt("views"),
						resultSet.getTimestamp("post_date"));

				MemberVO member = new MemberVO();
				member.setNickname(resultSet.getString("nickname"));
				
				data.put("community", community);
				data.put("member", member);
				
				communities.add(data);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return communities;
	}
	
	public void insertCommunity(CommunityVO communityVO) {

		int result = 0;
		String sql = "insert into community(id, title, contents, views, post_date) values(?,?,?,0,now())";
		
		result = dbConnector.executeUpdate(sql, 
				communityVO.getId(),
				communityVO.getTitle(),
				communityVO.getContents());
		
		dbConnector.release();
	}

	public HashMap<String, Object> readCommunity(String no) {

		String sql = "update community set views=views+1  where no=? ";
		
		dbConnector.executeUpdate(sql, Integer.parseInt(no));
		
		dbConnector.release();
		

		HashMap<String, Object> community = new HashMap<String, Object>();
		
		sql = "SELECT c.*, m.nickname, m.profile "
				+ "FROM community c "
				+ "LEFT OUTER JOIN member m "
				+ "ON c.id = m.id "
				+ "WHERE c.no=? ";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, Integer.parseInt(no));
		
		try {
			if(resultSet.next()) {
				CommunityVO	communityVO = new CommunityVO(
						resultSet.getInt("no"),
						resultSet.getString("id"),
						resultSet.getString("title"),
						resultSet.getString("contents"),
						resultSet.getInt("views"),
						resultSet.getTimestamp("post_date"));
			
				MemberVO memberVO = new MemberVO();
				memberVO.setNickname(resultSet.getString("nickname"));
				memberVO.setProfile(resultSet.getString("profile"));
				
				community.put("communityVO", communityVO);
				community.put("memberVO", memberVO);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return community;
	}

	public int updateCommunity(CommunityVO vo) {
		
		String sql = "update community set title=?, contents=? where no=? and id=?";
		
		int result = dbConnector.executeUpdate(sql, 
				vo.getTitle(),
				vo.getContents(),
				vo.getNo(),
				vo.getId());
		
		dbConnector.release();

		return result;
	}

	public int deleteCommunity(String no) {
		
		String sql = "delete from community where no=?";
		
		int result = dbConnector.executeUpdate(sql, Integer.parseInt(no));
		
		dbConnector.release();
		
		return result;
	}
	
	public ArrayList<HashMap<String, Object>> communityList(String key, String word) {

		String sql = null;
		
		ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		
		if(!word.equals("")) {
			
			if(key.equals("titleContent")) {
				
				sql = "SELECT c.*, m.nickname "
						+ "FROM community c "
						+ "JOIN member m "
						+ "ON c.id = m.id "
						+ "where title like '%" + word + "%' "
						+ "OR contents like '%" + word + "%' "
						+ "ORDER BY post_date desc";
				
			}else {
				sql = "SELECT c.*, m.nickname "
					+ "FROM community c "
					+ "JOIN member m "
					+ "ON c.id = m.id "
					+ "WHERE nickname like '%"+word+"%' "
					+ "ORDER BY post_date desc";
			}
		
		}else {
			
			sql = "SELECT c.*, m.nickname "
				+ "FROM community c "
				+ "JOIN member m "
				+ "ON c.id = m.id "
				+ "ORDER BY post_date desc";
		}
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
		try {
			while(resultSet.next()) {
				
				HashMap<String, Object> data = new HashMap<String, Object>();
				
				CommunityVO communityVO = new CommunityVO(
						resultSet.getInt("no"),
						resultSet.getString("id"),
						resultSet.getString("title"),
						resultSet.getString("contents"),
						resultSet.getInt("views"),
						resultSet.getTimestamp("post_date"));
				
				MemberVO memberVO = new MemberVO();
				memberVO.setNickname(resultSet.getString("nickname"));
					
				data.put("community", communityVO);
				data.put("member", memberVO);
				
				list.add(data);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return list;
	}
	
	public ArrayList<HashMap<String, Object>> selectCommunityShareList() {
		
		ArrayList<HashMap<String, Object>> shareList = new ArrayList<HashMap<String, Object>>();
		
		String sql = "select c.*, m.profile, m.nickname "
				+ "from community_share c "
				+ "LEFT OUTER JOIN member m "
				+ "ON c.id = m.id "
				+ "ORDER BY c.post_date DESC";
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
		try {
			while (resultSet.next()) {
				HashMap<String, Object> data = new HashMap<String, Object>();
				
				CommunityShareVO share = new CommunityShareVO(
						resultSet.getInt("no"), 
						resultSet.getString("id"),
						resultSet.getString("thumbnail"),
						resultSet.getString("title"), 
						resultSet.getString("contents"), 
						resultSet.getDouble("lat"), 
						resultSet.getDouble("lng"), 
						resultSet.getInt("type"), 
						resultSet.getInt("views"), 
						resultSet.getTimestamp("post_date"));
				
				MemberVO member = new MemberVO();
				member.setProfile(resultSet.getString("profile"));
				member.setNickname(resultSet.getString("nickname"));
				
				data.put("share", share);
				data.put("member", member);
				
				shareList.add(data);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		dbConnector.release();

		return shareList;
	}

	public ArrayList<HashMap<String, Object>> selectSearchedShareList(String key, String word) {
		
		ArrayList<HashMap<String, Object>> shareList = new ArrayList<HashMap<String,Object>>();
		String sql = "";

		if(!word.equals("")) {			
			if(key.equals("title")) {				
				sql = "SELECT c.*, m.profile, m.nickname "
						+ "FROM community_share c "
						+ "LEFT OUTER JOIN member m "
						+ "ON c.id = m.id "
						+ "WHERE c.title like '%" + word + "%' "
						+ "ORDER BY c.post_date DESC";				
			}
			else if(key.equals("nickname")){
				sql = "SELECT c.*, m.profile, m.nickname "
						+ "FROM community_share c "
						+ "LEFT OUTER JOIN member m "
						+ "ON c.id = m.id "
						+ "WHERE m.nickname like '%" + word + "%' "
						+ "ORDER BY c.post_date DESC";
			}
			else {
				sql = "SELECT c.*, m.profile, m.nickname "
						+ "From community_share c "
						+ "left outer join member m "
						+ "on c.id = m.id "
						+ "where c.type like if('재료나눔' like '%" + word + "%', 0, IF('같이 먹어요' like '%" + word + "%', 1, -1)) "
						+ "order by c.post_date desc";
						
			}
		
		}
		else {
			sql = "select c.*, m.profile, m.nickname "
					+ "from community_share c "
					+ "LEFT OUTER JOIN member m "
					+ "ON c.id = m.id "
					+ "ORDER BY c.post_date DESC";
		}
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
		try {
			while(resultSet.next()) {
				HashMap<String, Object> data = new HashMap<String, Object>();
				
				CommunityShareVO share = new CommunityShareVO(
						resultSet.getInt("no"), 
						resultSet.getString("id"), 
						resultSet.getString("thumbnail"),
						resultSet.getString("title"), 
						resultSet.getString("contents"), 
						resultSet.getDouble("lat"), 
						resultSet.getDouble("lng"), 
						resultSet.getInt("type"), 
						resultSet.getInt("views"), 
						resultSet.getTimestamp("post_date"));
				
				MemberVO member = new MemberVO();
				member.setProfile(resultSet.getString("profile"));
				member.setNickname(resultSet.getString("nickname"));
				
				data.put("share", share);
				data.put("member", member);
				
				shareList.add(data);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		dbConnector.release();
		
		return shareList;
	}

	public int selectNoInsertedShare(CommunityShareVO share) {
		
		String sql = "insert into community_share(id, thumbnail, title, contents, lat, lng, type, views, post_date) "
				+ "values(?, ?, ?, ?, ?, ?, ?, 0, CURRENT_TIMESTAMP)";
		
		dbConnector.executeUpdate(sql,
				share.getId(),
				share.getThumbnail(),
				share.getTitle(),
				share.getContents(),
				share.getLat(),
				share.getLng(),
				share.getType());
		
		dbConnector.release();

		
		int no = 0;
		sql = "SELECT no FROM community_share ORDER BY no DESC LIMIT 1";
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
		try {
			if (resultSet.next()) {
				no = resultSet.getInt("no");
			}
			else {
				no = -1;
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		dbConnector.release();

		return no;
	}

	public HashMap<String, Object> selectCommunityShareMap(String no) {
		
		String sql = "update community_share set views = views + 1 "
				+ "where no='" + no + "'";
		
		dbConnector.executeUpdate(sql);
		
		dbConnector.release();
		
		
		HashMap<String, Object> share = new HashMap<String, Object>();
		
		sql = "SELECT c.*, m.profile, m.nickname "
				+ "FROM community_share c "
				+ "LEFT OUTER JOIN member m "
				+ "ON c.id = m.id "
				+ "WHERE no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, Integer.parseInt(no));
		
		try {
			if(resultSet.next()) {
				CommunityShareVO shareVO = new CommunityShareVO(
						resultSet.getInt("no"), 
						resultSet.getString("id"), 
						resultSet.getString("thumbnail"),
						resultSet.getString("title"), 
						resultSet.getString("contents"), 
						resultSet.getDouble("lat"), 
						resultSet.getDouble("lng"), 
						resultSet.getInt("type"), 
						resultSet.getInt("views"), 
						resultSet.getTimestamp("post_date"));
				
				MemberVO memberVO = new MemberVO();
				memberVO.setNickname(resultSet.getString("nickname"));
				memberVO.setProfile(resultSet.getString("profile"));
				
				share.put("share", shareVO);
				share.put("member", memberVO);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		dbConnector.release();

		return share;
	}

	public CommunityShareVO selectCommunityShare(String no) {
		
		CommunityShareVO share = null;
		String sql = "select * from community_share where no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, Integer.parseInt(no));
		
		try {
			if(resultSet.next()) {
				share = new CommunityShareVO(
						resultSet.getInt("no"), 
						resultSet.getString("id"), 
						resultSet.getString("thumbnail"),
						resultSet.getString("title"), 
						resultSet.getString("contents"), 
						resultSet.getDouble("lat"), 
						resultSet.getDouble("lng"), 
						resultSet.getInt("type"), 
						resultSet.getInt("views"), 
						resultSet.getTimestamp("post_date"));
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}

		dbConnector.release();

		return share;
	}

	public int updateCommunityShare(CommunityShareVO share) {
		
		String sql = "UPDATE community_share SET thumbnail=?, title=?, contents=?, lat=?, lng=?, type=? "
				+ "WHERE no=? AND id=?";
		
		int result = dbConnector.executeUpdate(sql,
				share.getThumbnail(),
				share.getTitle(),
				share.getContents(),
				share.getLat(),
				share.getLng(),
				share.getType(),
				share.getNo(),
				share.getId());

		dbConnector.release();
		
		return result;
	}

	public int deleteCommunityShare(String no) {

		String sql = "DELETE FROM community_share WHERE no=?";
		
		int result = dbConnector.executeUpdate(sql, Integer.parseInt(no));
		
		dbConnector.release();

		return result;
	}
	
	public ArrayList<NoticeVO> selectNoticeList() {
		
		ArrayList<NoticeVO> noticeList = new ArrayList<NoticeVO>();
		
		String sql = "SELECT * FROM notice ORDER BY post_date DESC";
		
		ResultSet resultSet = dbConnector.executeQuery(sql);
		
		try {
			while (resultSet.next()) {
				NoticeVO noticeVO = new NoticeVO(
						resultSet.getInt("no"),
						resultSet.getString("title"),
						resultSet.getString("contents"),
						resultSet.getInt("views"),
						resultSet.getTimestamp("post_date"));
				
				noticeList.add(noticeVO);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		dbConnector.release();
		
		return noticeList;
	}
	
	public NoticeVO selectNotice(String no) {

		NoticeVO noticeVO = null;
		String sql = "SELECT * FROM notice WHERE no=?";
		
		ResultSet resultSet = dbConnector.executeQuery(sql, Integer.parseInt(no));
		
		try {
			if (resultSet.next()) {
				noticeVO = new NoticeVO(
						resultSet.getInt("no"),
						resultSet.getString("title"),
						resultSet.getString("contents"),
						resultSet.getInt("views"),
						resultSet.getTimestamp("post_date"));
			}
		} 
		catch (SQLException e) {
			e.printStackTrace();
		}
		
		return noticeVO;
	}
	
	public int insertNotice(String title, String contents) {
		
		String sql = "INSERT INTO notice(title, contents) VALUES(?, ?)";
		
		int result = dbConnector.executeUpdate(sql, title, contents);
		
		return result;
	}
	
	public int updateNotice(String no, String title, String contents) {
		
		String sql = "UPDATE notice SET title=?, contents=? WHERE no=?";
		
		int result = dbConnector.executeUpdate(sql, title, contents, Integer.parseInt(no));
		
		dbConnector.release();
		
		return result;
	}
	
	public int deleteNotice(String no) {
		
		String sql = "DELETE FROM notice WHERE no=?";
		
		int result = dbConnector.executeUpdate(sql, Integer.parseInt(no));
		
		dbConnector.release();
		
		return result;
	}
}
