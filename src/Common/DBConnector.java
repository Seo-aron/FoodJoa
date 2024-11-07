package Common;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

/**
 * DB 연결 및 쿼리문 전송을 일괄적으로 관리하는 클래스<br>
 * execute 실행 후 Release 함수를 호출하는 편이 좋음
 */
public class DBConnector {

	private DataSource dataSource;
	
	private Connection connection;
	private PreparedStatement statement;
	private ResultSet resultSet;

	/**
	 * DB 연결자 클래스 생성자<br>
	 * 생성자 호출 시 자동으로 커넥션 풀 등록
	 */
	public DBConnector() {
		
		try {
			Context context = new InitialContext();
			dataSource = (DataSource) context.lookup("java:/comp/env/jdbc/FoodJoa");
		}
		catch (Exception e) {
			System.out.println("DB 연결 실패");
			e.printStackTrace();
		}
	}
	
	/**
	 * 사용이 끝난 자원 일괄적으로 할당 해제
	 */
	public void Release() {
		
		try {
			if (resultSet != null) resultSet.close();
			if (statement != null) statement.close();
			if (connection != null) connection.close();
		}
		catch (Exception e) {
			System.out.println("자원 해제 실패");
			e.printStackTrace();
		}
	}
	
	private void prepareQuery(String sql, Object... params) {
		
		Release();		// 사용 중인 자원이 남아 있으면 메모리 할당 해제
		
		try {
			connection = dataSource.getConnection();
			
			statement = connection.prepareStatement(sql);
			for (int i = 0; i < params.length; i++) {
				if (params[i] instanceof String) statement.setString(i+1, (String) params[i]);
				else if (params[i] instanceof Integer) statement.setInt(i+1, (int) params[i]);
				else if (params[i] instanceof Float) statement.setFloat(i+1, (float) params[i]);
				else if (params[i] instanceof Timestamp) statement.setTimestamp(i+1, (Timestamp) params[i]);
			}
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("DBConnector SQLException 발생");
		}
	}
	
	/**
	 * SELECT 구문을 실행하기 위한 함수<br>
	 * 두 번째 매개변수 부터 차례로 SQL에 set<br>
	 * 사용 예) dbConnector.executeQuery("select * from table where col1=? and col2=?", col1열 값, col2열 값);
	 * @param sql SELECT 구문이 포함 된 SQL 쿼리문
	 * @param params 쿼리문에 포함 할 변수들
	 * @return SELECT 구문의 실행 결과인 ResultSet 객체
	 */
	public ResultSet executeQuery(String sql, Object... params) {
		
		prepareQuery(sql, params);
		
		try {
			resultSet = statement.executeQuery();
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("DBConnector SQLException 발생");
		}
		
		
		return resultSet;
	}
	
	/**
	 * SELECT 구문을 제외한 나머지 구문을 실행하기 위한 함수<br>
	 * 두 번째 매개변수 부터 차례로 SQL에 set<br>
	 * 사용 예) dbConnector.executeUpdate("insert into table(col1, col2) values(?, ?), col1열 값, col2열 값);
	 * @param sql SELECT 구문이 포함 된 SQL 쿼리문
	 * @param params 쿼리문에 포함 할 변수들
	 * @return SQL 실행 결과를 int로 반환 (-1 : 예외 발생, 0 : 쿼리문 실행 실패, 1 : 쿼리문 실행 성공)
	 */
	public int executeUpdate(String sql, Object... params) {
		
		prepareQuery(sql, params);
		
		int result = 0;
		
		try {
			result = statement.executeUpdate();
		}
		catch (SQLException e) {
			e.printStackTrace();
			System.out.println("DBConnector SQLException 발생");
			result = -1;
		}
		
		
		return result;
	}
}
