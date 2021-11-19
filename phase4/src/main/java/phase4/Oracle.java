package phase4;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Oracle {
	// Need modification according to your oracle env
	private final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	private final String USER_UNIVERSITY ="hr";
	private final String USER_PASSWD ="hr";
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public Oracle() {
		// connect 
		try {		
            Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("Driver Loading : Success!");
		} catch(ClassNotFoundException e) {
			System.err.println("error = " + e.getMessage());
			System.exit(1);
		}
    
        try {
            conn = DriverManager.getConnection(URL, USER_UNIVERSITY, USER_PASSWD);
            rs = null;
            System.out.println("Oracle Connected.");
        } catch(SQLException ex) {
            ex.printStackTrace();
            System.err.println("Cannot get a connection: " + ex.getLocalizedMessage());
            System.err.println("Cannot get a connection: " + ex.getMessage());
            System.exit(1);
        }
        
        try {
			conn.setAutoCommit(false);		
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
		
		
	public int login(String userId, String userPw) {               
		try {			
			String sql = "SELECT  User_id, Upassword " +
						 "FROM USERS " +
						 "WHERE User_id = '" + userId +"' and Upassword = '" + userPw +"' ";
			pstmt = conn.prepareStatement(sql);

			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				if(rs.getString(1).equals(userPw)) {
					return 0; // Success
				}else
					return 1; // Wrong passWd
			}
			return -1; // No Id
			
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return -2; // error
	}
	
	public void close() {
		try {
			conn.close();
			pstmt.close();
			rs.close();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

