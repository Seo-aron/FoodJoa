package DAOs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import VOs.CommunityShareVO;
import VOs.CommunityVO;
import VOs.MemberVO;

public class CommunityDAO {

	DataSource dataSource;
	Connection connection;
	PreparedStatement preparedStatement;
	ResultSet resultSet;

	public CommunityDAO() {
		try {
			Context context = new InitialContext();
			dataSource = (DataSource) context.lookup("java:/comp/env/jdbc/FoodJoa");
		} catch (Exception e) {
			System.out.println("DB 연결 실패");
			e.printStackTrace();
		}
	}

	public void release() {

		try {
			if (resultSet != null)
				resultSet.close();
			if (preparedStatement != null)
				preparedStatement.close();
			if (connection != null)
				connection.close();
		} catch (Exception e) {
			System.out.println("자원 해제 실패");
			e.printStackTrace();
		}
	}

	public ArrayList<CommunityVO> communityListAll() {
		ArrayList<CommunityVO> communities = new ArrayList<CommunityVO>();

		try {

			connection = dataSource.getConnection();

			String sql = "select c.*, m.nickname "
					+ "FROM community c "
					+ "LEFT OUTER JOIN member m "
					+ "ON c.id = m.id "
					+ "order by post_date desc";
			
			preparedStatement = connection.prepareStatement(sql);

			resultSet = preparedStatement.executeQuery();

			while (resultSet.next()) {

				CommunityVO community = new CommunityVO(resultSet.getInt("no"), resultSet.getString("id"),
						resultSet.getString("title"), resultSet.getString("contents"), resultSet.getInt("views"),
						resultSet.getTimestamp("post_date"));

				communities.add(community);

			}
		}

		catch (Exception e) {
			e.printStackTrace();
		} finally {
			release();
		}

		return communities;
	}
	
	public void insertCommunity(CommunityVO communityVO) {

		int result = 0;
		String sql = null;

		try {
			connection = dataSource.getConnection();

			sql = "insert into community(id, title, contents, views, post_date) values(?,?,?,0,now())";

			preparedStatement = connection.prepareStatement(sql);

			preparedStatement.setString(1, communityVO.getId());
			preparedStatement.setString(2, communityVO.getTitle());
			preparedStatement.setString(3, communityVO.getContents());

			preparedStatement.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			release();
		}

	}

	public CommunityVO readCommunity(String no) {

		CommunityVO vo = null;
		String sql = null;
		
		try {
			connection = dataSource.getConnection();
			
			sql = "update community set views=views+1  where no=?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, Integer.parseInt(no));
			
			preparedStatement.executeUpdate();
			
			sql = "select * from community where no=?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, Integer.parseInt(no));
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next()) {
				
				vo = new CommunityVO(
						resultSet.getInt("no"),
						resultSet.getString("id"),
						resultSet.getString("title"),
						resultSet.getString("contents"),
						resultSet.getInt("views"),
						resultSet.getTimestamp("post_date"));
			}
		
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			release();
		}
		
		return vo;
	}

	public int updateCommunity(CommunityVO vo) {
		
		int result = 0;
		
		try {
			connection = dataSource.getConnection();
			
			String sql = "update community set title=?, contents=? where no=?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, vo.getTitle());
			preparedStatement.setString(2, vo.getContents());
			preparedStatement.setInt(3, vo.getNo());
			
			result = preparedStatement.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			release();
		}
		
		return result;
	}

	public int deleteCommunity(String no) {
		
		int result = 0;
		
		try {
		
			connection = dataSource.getConnection();
			
			String sql = "delete from community where no=?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, Integer.parseInt(no));

			result = preparedStatement.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			release();
		}
		
		return result;
	}

	public ArrayList<CommunityVO> communityList(String key, String word) {

		String sql = null;
		
		ArrayList list = new ArrayList();
		
		if(!word.equals("")) {
			
			if(key.equals("titleContent")) {
				
				sql = "select * from community"
					+ " where title like '%"+word+"%' "
					+ " OR contents like '%"+word+"%' "
					+ " order by no asc";
				
			}else {
				sql = "select * from community"
					+ " where id like '%"+word+"%' "
					+ " order by no asc";
			}
		
		}else {
			
			sql = "select * from community"
				+ " order by no asc";
		}
		
		try {
			connection=dataSource.getConnection();
			
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			
			while(resultSet.next()) {
				CommunityVO vo = new CommunityVO(resultSet.getInt("no"),
												resultSet.getString("id"),
												resultSet.getString("title"),
												resultSet.getString("contents"),
												resultSet.getInt("views"),
												resultSet.getTimestamp("post_date"));
				list.add(vo);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			release();
		}
		return list;
	}
	
	public ArrayList<HashMap<String, Object>> selectCommunityShareList() {
		
		ArrayList<HashMap<String, Object>> shareList = new ArrayList<HashMap<String, Object>>();
		
		try {
			connection = dataSource.getConnection();
			
			String sql = "select c.*, m.profile, m.nickname "
					+ "from community_share c "
					+ "LEFT OUTER JOIN member m "
					+ "ON c.id = m.id "
					+ "ORDER BY c.post_date DESC";
			preparedStatement = connection.prepareStatement(sql);
			
			resultSet = preparedStatement.executeQuery();
			
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
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			release();
		}		
		
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
			else {
				sql = "SELECT c.*, m.profile, m.nickname "
						+ "FROM community_share c "
						+ "LEFT OUTER JOIN member m "
						+ "ON c.id = m.id "
						+ "WHERE m.nickname like '%" + word + "%' "
						+ "ORDER BY c.post_date DESC";
			}
		
		}else {
			sql = "select c.*, m.profile, m.nickname "
					+ "from community_share c "
					+ "LEFT OUTER JOIN member m "
					+ "ON c.id = m.id "
					+ "ORDER BY c.post_date DESC";
		}
		
		try {
			connection=dataSource.getConnection();
			
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			
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
			
		} catch (Exception e) {
			e.printStackTrace();
		}finally {
			release();
		}
		
		return shareList;
	}

	public int selectNoInsertedShare(CommunityShareVO share) {
		
		int no = 0;

		try {
			connection = dataSource.getConnection();
			
			String sql = "insert into community_share(id, thumbnail, title, contents, lat, lng, type, views, post_date) "
					+ "values(?, ?, ?, ?, ?, ?, ?, 0, CURRENT_TIMESTAMP)";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, share.getId());
			preparedStatement.setString(2, share.getThumbnail());
			preparedStatement.setString(3, share.getTitle());
			preparedStatement.setString(4, share.getContents());
			preparedStatement.setDouble(5, share.getLat());
			preparedStatement.setDouble(6, share.getLng());
			preparedStatement.setInt(7, share.getType());
			
			preparedStatement.executeUpdate();
			
			sql = "SELECT no FROM community_share ORDER BY no DESC LIMIT 1";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			
			if (resultSet.next()) {
				no = resultSet.getInt("no");
			}
			else {
				no = -1;
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			release();
		}
		
		return no;
	}

	public HashMap<String, Object> selectCommunityShareMap(String no) {
		
		HashMap<String, Object> share = new HashMap<String, Object>();
		
		try {
			connection = dataSource.getConnection();
			
			String sql = "update community_share set views = views + 1 "
						+ "where no='" + no + "'";
			preparedStatement = connection.prepareStatement(sql);
			
			preparedStatement.executeUpdate();
			
			sql = "SELECT c.*, m.profile, m.nickname "
					+ "FROM community_share c "
					+ "LEFT OUTER JOIN member m "
					+ "ON c.id = m.id "
					+ "WHERE no=?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, Integer.parseInt(no));
			
			resultSet = preparedStatement.executeQuery();
			
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
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			release();
		}
		
		return share;
	}

	public CommunityShareVO selectCommunityShare(String no) {
		
		CommunityShareVO share = null;
		
		try {
			
			connection = dataSource.getConnection();
			
			String sql = "select * from community_share where no=?";
			preparedStatement = connection.prepareStatement(sql);
			
			preparedStatement.setInt(1, Integer.parseInt(no));
			
			resultSet = preparedStatement.executeQuery();
			
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
			
		} catch (Exception e) {
			e.printStackTrace();
			
		}finally {
			release();
		}
		
		return share;
	}

	public int updateCommunityShare(CommunityShareVO share) {
		
		int result = 0;
		
		try {
			connection = dataSource.getConnection();
			
			String sql = "UPDATE community_share SET thumbnail=?, title=?, contents=?, lat=?, lng=?, type=? "
					+ "WHERE no=? AND id=?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, share.getThumbnail());
			preparedStatement.setString(2, share.getTitle());
			preparedStatement.setString(3, share.getContents());
			preparedStatement.setDouble(4, share.getLat());
			preparedStatement.setDouble(5, share.getLng());
			preparedStatement.setInt(6, share.getType());
			preparedStatement.setInt(7, share.getNo());
			preparedStatement.setString(8, share.getId());
			
			result = preparedStatement.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			release();
		}

		return result;
	}

	public int deleteCommunityShare(String no) {
		
		int result = 0;
		
		try {
			connection = dataSource.getConnection();
			
			String sql = "DELETE FROM community_share WHERE no=?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setInt(1, Integer.parseInt(no));
			
			result = preparedStatement.executeUpdate();
			
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			release();
		}
		
		return result;
	}
}
