package DAOs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

import VOs.CommunityVO;

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

			String sql = "select * from community";

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

}
