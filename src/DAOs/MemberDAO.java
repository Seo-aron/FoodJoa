package DAOs;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import Common.DBConnector;
import VOs.MemberVO;

public class MemberDAO {

	private DBConnector dbConnector;

	public MemberDAO() {
		dbConnector = new DBConnector();
	}

	public ArrayList<MemberVO> selectMembers() {

		ArrayList<MemberVO> members = new ArrayList<MemberVO>();

		String sql = "SELECT * FROM member";

		try (ResultSet resultSet = dbConnector.executeQuery(sql)) {
			while (resultSet.next()) {
				MemberVO member = new MemberVO(resultSet.getString("id"), resultSet.getString("name"),
						resultSet.getString("nickname"), resultSet.getString("phone"), resultSet.getString("address"),
						resultSet.getString("profile"), resultSet.getTimestamp("join_date"));

				members.add(member);
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return members; // ArrayList 반환
	}
}
