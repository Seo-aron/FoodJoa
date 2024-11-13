package DAOs;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.sql.DataSource;

public class CommunityDAO {

	Connection connection;
	PreparedStatement statement;
	ResultSet rs;
	DataSource datasource;
	
	public CommunityDAO() {
		
	}
	
}
