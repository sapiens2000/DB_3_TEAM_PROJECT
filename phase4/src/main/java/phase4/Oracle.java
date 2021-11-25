package phase4;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class Oracle {
	
	// 싱글톤 패턴
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
						 "WHERE User_id = '" + userId +"' ";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(); 
							
			if(rs.next()) {
				if(rs.getString(2).equals(userPw)) {						
					return Integer.parseInt(rs.getString(3)); // return uNum
				}else
					return -2; // Wrong passWd
			}
			else
				return -3; // No Id					
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return -4; // error
	}
	
	// unum을 세션으로 활용
	public int register(UserBean user) {
		try {	
			String userId = user.getUserId();
			String sql = "SELECT User_id " +
						 "FROM USERS " +
						 "WHERE User_id = '" + userId + "' ";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				if(rs.getString(1).equals(userId)) {
					return -1;	// id 중복
				}else {
					return -2;  // error
				}

			}else {				
				user.setuNum(getUnum() + 1);
				
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
										
					// Add to Ranking 
					addRanking(user);
					
					pstmt = conn.prepareStatement(sql);
					pstmt.setString(1, user.getUserId());
					pstmt.setInt(2, user.getuNum());
					
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

	public int getUnum() {
		String sql = "SELECT COUNT(Unum) " +
			  	 "FROM USERS ";
		int uNum = 0;
		try {
		pstmt = conn.prepareStatement(sql);
		rs = pstmt.executeQuery(); 
		
			// new user num
			if(rs.next()) {
				uNum = rs.getInt(1);
				return uNum;
			}
		} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}
		// error
		return -1;
	}
	
	public ResultSet getRanking() {
		String sql = "SELECT RANK, USER_ID, Ucurrent_total_asset " + 
					 "FROM RANKING, USERS " + 
					 "WHERE USER_ID = Ruser_id " + 
					 "ORDER BY RANK ";
		
		try {
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				rs.beforeFirst();
				return rs;
			}
			
		} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}
		return null;	// error
	}
	
	// When User do Registration, add data to ranking table.
	public void addRanking(UserBean user) {
		String sql = "SELECT COUNT(*) " + 
				 	 "FROM RANKING, USERS " + 
				 	 "WHERE USER_ID = Ruser_id AND Ucurrent_total_asset > " + user.getCurrent_total_asset() + " " ;
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				// New user's ranking
				int rank = rs.getInt(1);
				
				sql = "INSERT INTO RANKING VALUES(?, ?) ";
				pstmt = conn.prepareStatement(sql);
				
				pstmt.setString(1, user.getUserId());
				pstmt.setInt(2, rank);

				rs = pstmt.executeQuery();		
				
				// after add, update old ranking
				//updateRanking(user, rank);
								
				commit();
			
			}			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	// After insert data to ranking, need update db
	public void updateRanking(UserBean user, int rank) {
		String sql = "SELECT * " + 
					 "FROM RANKING, USERS " +
					 "WHERE User_id = Ruser_id " + 
					 "ORDER BY Ucurrent_total_asset ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(); 
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
				
	}
	
	public ResultSet getUsers() {
		String sql = "SELECT Unum, User_id " + 
				 	 "FROM USERS " +
				 	 "ORDER BY Unum ASC ";
		try {
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				rs.beforeFirst();
				return rs;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}
	
	public int getUserNum() {
		String sql = "SELECT COUNT(*)" + 
			 	 	 "FROM USERS " +
			 	 	 "ORDER BY Unum ASC ";
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				return rs.getInt(1);
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}
	
	public UserBean getUserData(String userId) {
		UserBean user = new UserBean();
		
		String sql = "SELECT * " + 
			 	 	 "FROM USERS " +
			 	 	 "WHERE User_id = '" + userId + "' ";
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				
				user.setUserId(rs.getString(1));
				user.setUserPw(rs.getString(2));
				user.setuNum(rs.getInt(3));
				user.setCurrent_total_asset(rs.getInt(4));
				user.setCash(rs.getInt(5));
				user.setAge(rs.getInt(6));
				user.setGender(rs.getString(7));
				user.setEmail(rs.getString(8));
				user.setPhone_num(rs.getString(9));
				
				return user;
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return null;
	}
	
	public boolean deleteUser(String userId) {
		// delete ranking -> ...users
		String sql = "DELETE RANKING WHERE RUSER_ID = '" + userId +"' " ;		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		}
		
		sql = "DELETE USERS WHERE USER_ID = '" + userId + "' " ;	
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			this.commit();
			return true;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		}
		return false;
	}
	
	public boolean updateUser(UserBean User) { 
		// �쑀���뒗 id, �꽦蹂� �닔�젙 湲덉� �떆�궗寃�		
		String sql = "UPDATE USERS " +
					 "SET " +
					 "USER_ID = '" + User.getUserId() + "', " +
					 "UPassword = '" + User.getUserPw() + "', " +
					 "UCash = '" + User.getCash() + "', " +
					 "UEmail = '" + User.getEmail() + "', " +
					 "UCELL_PHONE_NUMBER = '" + User.getPhone_num() + "' " +
					 "WHERE USER_ID = '" + User.getUserId() + "' ";
			
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			this.commit();
			return true;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			
		}
		return false;
	}
	
	public ArrayList<Integer> getUsersByAge(){
		ArrayList<Integer> numOfUsers = new ArrayList<Integer>();
		String sql = "";
		int index = 1;
					
		while(index <= 5) {
			sql = "SELECT COUNT(*) " +
				  "FROM USERS " + 
				  "WHERE UAge >= " + index*10 + "AND UAGE < " + (index+1)*10 + " ";
			
			try {
				pstmt = conn.prepareStatement(sql);
				rs = pstmt.executeQuery();
				
				if(rs.next()){
					numOfUsers.add(rs.getInt(1));					
				}else
					numOfUsers.add(0);
				
			}catch(SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			index++;
		}
				
		sql = "SELECT COUNT(*) " +
			  "FROM USERS " + 
			  "WHERE UAge >= " + index*10 + " ";
			
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				numOfUsers.add(rs.getInt(1));					
			}else
				numOfUsers.add(0);
			
		}catch(SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return numOfUsers;
	}
	
	public int getUserByGender(String gender) {
		String sql = "SELECT COUNT(*) " +
					 "FROM USERS " + 
					 "WHERE Usex='" + gender +"' ";
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			
			if(rs.next())
				return rs.getInt(1);
			
		}catch(SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return 0;
	}

	public void commit() {
		try {
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void rollback() {
		try {
			conn.rollback();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void cursorClose() {
		try {

			pstmt.close();
			rs.close();
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

