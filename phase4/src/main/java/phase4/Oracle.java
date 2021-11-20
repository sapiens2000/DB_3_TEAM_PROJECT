package phase4;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class Oracle {
	
	// 중복 연결 방지를 위한 싱글톤 패턴
	private static Oracle instance;
	
	// Need modification according to your oracle env
	private final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	private final String USER_UNIVERSITY ="hr";
	private final String USER_PASSWD ="hr";
	
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	private Oracle() {
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
	
	public static Oracle getInstance() {
		if(instance == null) {
			instance = new Oracle();
		}
		return instance;
	}
		
	// return Unum for Session
	public int login(String userId, String userPw) {               
		try {			
			String sql = "SELECT  User_id, Upassword, Unum " +
						 "FROM USERS " +
						 "WHERE User_id = '" + userId +"' and Upassword = '" + userPw +"' ";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				if(rs.getString(2).equals(userPw)) {
					return Integer.parseInt(rs.getString(3)); // return uNum
				}else
					return -1; // Wrong passWd
			}
			return -2; // No Id
			
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return -3; // error
	}
	
	
	public int register(UserBean user) {
		try {	
			int uNum;
			String userId = user.getUserId();
			String sql = "SELECT User_id " +
						 "FROM USERS " +
						 "WHERE User_id = '" + userId + "' ";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				if(rs.getString(1).equals(userId)) {
					return -1;	// 이미 존재하는 id
				}else {
					return -2;  // error
				}
			}else {
				sql = "SELECT COUNT(Unum) " +
						  "FROM USERS ";
					pstmt = conn.prepareStatement(sql);
					rs = pstmt.executeQuery(); 
					
					// new user num
					if(rs.next()) {
						uNum = rs.getInt(1) + 1;
					}else {
						return -2;
					}
					user.setuNum(uNum);
					
					try {
						sql = "INSERT INTO USERS VALUES(?, ?, ?, ?, ?, ?, ?, ?, ?) "; 
	
						pstmt = conn.prepareStatement(sql);
						pstmt.setString(1, user.getUserId());
						pstmt.setString(2, user.getUserPw());
						pstmt.setInt(3, user.getuNum());
						pstmt.setInt(4, user.getCurrent_total_asset());
						pstmt.setInt(5, user.getCash());
						pstmt.setInt(6, user.getAge());
						pstmt.setString(7, user.getGender());
						pstmt.setString(8, user.getEmail());
						pstmt.setString(9, user.getPhone_num());
						
						rs = pstmt.executeQuery();
						commit();
						
						return 0; // Success
					}catch(Exception e) {
						e.printStackTrace();
					}
				}		
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return -2; // error
	}
	
	
	public void commit() {
		try {
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
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

