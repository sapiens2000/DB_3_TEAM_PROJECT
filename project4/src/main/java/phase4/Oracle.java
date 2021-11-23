package phase4;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import phase4.GraphDto;

public class Oracle {
	
	// �ߺ� ���� ������ ���� �̱��� ����
	private static Oracle instance;
	
	// Need modification according to your oracle env
	private final String URL = "jdbc:oracle:thin:@localhost:1521:xe";
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
	
	
	// ���ü� ���� �ʿ�
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
					return -1;	// �̹� �����ϴ� id
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
					 "ORDER BY RANK ASC ";
		
		try {
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery(); 
			
			if(rs.next())
				rs.beforeFirst();
				return rs;
			
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
				 	 "WHERE USER_ID = Ruser_id AND Ucurrent_total_asset >= " + user.getCurrent_total_asset() + " " ;
		
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
				
				// ��ŷ ���� ������Ʈ 
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
					 "ORDER BY ";
		
		
		

	}
	
	public ArrayList<GraphDto> stockChart(String company) {
		
		ArrayList<GraphDto> dataList = new ArrayList<GraphDto>();	
		
		String sql = "SELECT C.CSTART_DATE, C.CSTART_PRICE, C.CHIGH_PRICE, C.CLOW_PRICE, C.CCLOSE_PRICE " + 
			 	 	 "FROM CHART C, STOCK S " +
			 	 	 "WHERE S.Scode = C.Ccode AND Sname = '" + company + "' " +
			 	 	 "ORDER BY C.Cstart_date DESC ";
		System.out.println(company);
		System.out.println(sql);
		
//		String resultJson = "";		
//		resultJson += "[";
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(); 
			
			while(rs.next()) {
				
				String date	= rs.getString("CSTART_DATE");
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
				
				long datelong = 0;				
				
				try {
				Date date1 = simpleDateFormat.parse(date); 
				datelong = date1.getTime();
				}
				catch(Exception e) {
					e.printStackTrace();
				}
/*				
				if(rs.getRow() > 1){
					resultJson += ", ";
				}
*/				
				
				double open		= (double)rs.getInt("CSTART_PRICE");
				double high		= (double)rs.getInt("CHIGH_PRICE");
				double low		= (double)rs.getInt("CLOW_PRICE");
				double close	= (double)rs.getInt("CCLOSE_PRICE");
				
				datelong = datelong;
/*				
				resultJson += "{ \"date\":" + datelong + ", \"high\":" + high + ", \"low\":" + low + ", \"open\":" + open +
						 	  ", \"close\":" + close + " } ";
*/				
				dataList.add(new GraphDto(datelong, high, low, open, close));
			
			}			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
//		resultJson += "]";
//		System.out.println(resultJson);
//		return resultJson;
		
		System.out.println(dataList);
		return dataList;
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

