package phase4;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.StringTokenizer;

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
	
	public String stockChart(String company) {
		
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
		return dataList.toString();
	}
	
	public ResultSet getChangeRate() {
		String sql = "SELECT Sname, Cstart_date, ROUND((Cclose_price - Cstart_price) / Cstart_price * 100, 2), Cstart_price, Cclose_price, Chigh_price, Clow_price " +
				 "FROM " + 
				 "(SELECT * " + 
				 "FROM STOCK, CHART " +
				 "WHERE Scode = Ccode " +
				 "AND Cstart_date = " +
				 "(SELECT CSTART_DATE " +
				 "FROM " +
				 "(SELECT CSTART_DATE " +
				 "FROM STOCK, CHART " + 
				 "WHERE Scode = Ccode " +
				 "GROUP BY CSTART_DATE " +
				 "ORDER BY CSTART_DATE DESC) " +
				 "WHERE ROWNUM = 1) " +				 
				 "ORDER BY Cstart_date DESC) ";

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
	
	public ResultSet foreignRatePerRoe() {
		
		String sql = "SELECT Sname, Sforeign_rate, Sper, Sroe " +
					 "FROM STOCK " + 
					 "ORDER BY Sforeign_rate DESC ";
		
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
	
	public ResultSet getNewsInChart(String company) {
		
		String sql = "SELECT N.Ntitle, N.Nurl " +
				 	 "FROM NEWS N " + 
				 	 "WHERE N.Ntitle LIKE '%" + company + "%' ";
	
		System.out.println(sql);	
		
		try {
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery(); 
			
			if(rs != null) {
				if(rs.next())
					rs.beforeFirst();
					return rs;
			}
			System.out.println("rs is null");
			
		} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}
		return null;
		
	}
	
	public ResultSet getAllDataForChart(String company) {
		String sql = "SELECT C.Chigh_price, C.Clow_price, ROUND((C.Chigh_price - C.Cstart_price) / C.Cstart_price * 100, 2), C.Cstart_price, C.Cclose_price, S.Smarket_cap, " +
					 " S.Smarket, SE.Sector_name, S.Sforeign_rate, S.Sper, S.Spbr, S.Sroe " +
					 "FROM STOCK S, CHART C, SECTOR SE " +
					 "WHERE S.Scode = C.Ccode AND SE.Sname ='" + company + "' " +
					 "ORDER BY C.Cstart_date DESC ";
		
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
	
	public ResultSet getHoldingStock(String company, int Unum) {
		String sql = "SELECT DISTINCT S.Sname, HS.Quantity " +
					 "FROM USERS U, HOLDINGSTOCK HS, STOCK S " +
					 "WHERE U.Unum = HS.Hs_unum " +
					 "	AND HS.Hs_Scode = S.Scode " +
					 "	AND U.Unum = " + Unum + " " +
					 "  AND S.Sname = '" + company + "'";
				
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
	
	public ResultSet getHoldingCash(int Unum) {
		String sql = "SELECT Ucash  " +
					 "FROM USERS " +
					 "WHERE Unum = " + Unum;
				
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
	
	public int buyStock(String stockName, int Unum, int amount) {
		
		String stockCode = "";
		int price = 0;
			
		try {			
				
			String sql = "";
			sql = 	"SELECT S.Scode, C.Cclose_price " +
					"FROM CHART C, STOCK S " +
					"WHERE S.Scode = C.Ccode AND Sname = '" + stockName + "' " +
					"ORDER BY C.Cstart_date DESC ";
				
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
				
			if(rs.next()) {
				stockCode = rs.getString(1);
				price = rs.getInt(2);
			}
			else {
				System.out.println("현재 매수가 불가합니다.");
				return -2;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		
		int totalPrice = amount * price;	
		int cash = 0;
		
		rs = null;
		
		try {			
			
			String sql = "";
			sql = 	"SELECT Ucash " +
					"FROM USERS " +
					"WHERE Unum = " + Unum;

			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				cash	= rs.getInt(1);
			}

			if(cash >= totalPrice) {
				int rest = cash - totalPrice;
				
				sql = 	"UPDATE USERS " +
						"SET " +
						"Ucash = " + rest + ", " +
						"Ucurrent_total_asset = Ucurrent_total_asset + " + totalPrice + " " + 
						"WHERE Unum = " + Unum;
				pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
				rs = pstmt.executeQuery();
				int listNum = 0;
				
				sql = 	"SELECT MAX(Tnum) " +
						"FROM TRANSACTION_LIST ";
				
				pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
				rs = pstmt.executeQuery();
				if(rs.next()) {
					listNum = rs.getInt(1) + 1;
				}
				
				sql = 	"INSERT INTO TRANSACTION_LIST VALUES ( " + listNum + ", SYSDATE, '" + stockName + "', '매수', " + price +", " + amount + " )";
				pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
				rs = pstmt.executeQuery();
				
				sql =	"INSERT INTO HISTORY VALUES ( " + Unum + ", " + listNum + " )";
				pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
				rs = pstmt.executeQuery();
				
				sql =	"SELECT * " +
						"FROM HOLDINGSTOCK " +
						"WHERE Hs_unum = " + Unum + " AND Hs_scode = '" + stockCode + "' ";
				pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
				rs = pstmt.executeQuery();
				
				if(!rs.next()) {
					sql =	"INSERT INTO HOLDINGSTOCK VALUES ( " + Unum + ", '" + stockCode + "', 0, 0 ) ";
					pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
					rs = pstmt.executeQuery();
				}
				
				sql = 	"UPDATE HOLDINGSTOCK " +
						"SET " +
						"Quantity = Quantity + " + amount + " " +
						"WHERE Hs_unum = " + Unum + " AND Hs_scode = '" + stockCode + "' ";
				pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
				rs = pstmt.executeQuery();
				
				commit();
				
				return 1;
			}
			else {
				return -1;
			}
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return -3;
	}
	
	public int sellStock(String Sname, int Unum, int amount) {
		String stockCode = "";
		int price = 0;
		
		ResultSet rs = null;
		String sql = "";
				
		System.out.print("매도할 주식명과 수량을 입력해주세요. (주식명 - 수량) : ");	        
			
		try {			

			sql = 	"SELECT S.Scode, C.Cclose_price " +
					"FROM CHART C, STOCK S " +
					"WHERE S.Scode = C.Ccode AND Sname = '" + Sname + "' " +
					"ORDER BY C.Cstart_date DESC ";
				
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
				
			if(rs.next()) {
				stockCode = rs.getString(1);
				price = rs.getInt(2);
			}
			else {
				System.out.println("현재 매도가 불가합니다.");
				return -2;
			}
			
			sql = 	"SELECT DISTINCT Sname, HS.Quantity " +
					"FROM USERS U, HOLDINGSTOCK HS, STOCK S " +
					"WHERE U.Unum = HS.Hs_unum  " + 
					"	AND HS.Hs_Scode = S.Scode " +
					"	AND U.Unum = " + Unum + " " +
					"	AND S.Sname = '" + Sname + "' ";
	
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				String checkName 		= rs.getString(1);
				int checkSum			= rs.getInt(2);
				
				if(amount > checkSum) {
					System.out.println("보유 수량이 부족합니다.");
					return -1;
				}
			}
			else {
				System.out.println("보유 수량이 부족합니다.");
				return -1;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}

		
		int totalPrice = amount * price;	
		int cash = 0;
		
		rs = null;
		
		try {			
			
			sql = "";
			sql = 	"SELECT Ucash " +
					"FROM USERS " +
					"WHERE Unum = " + Unum;
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				cash	= rs.getInt(1);
			}

			sql = 	"UPDATE USERS " +
					"SET " +
					"Ucash = Ucash + " + totalPrice + ", " +
					"Ucurrent_total_asset = Ucurrent_total_asset - " + totalPrice + " " + 
					"WHERE Unum = " + Unum;
			
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
			
			int listNum = 0;
			sql = 	"SELECT MAX(Tnum) " +
					"FROM TRANSACTION_LIST ";
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				listNum = rs.getInt(1) + 1;
			}
			
			sql = 	"INSERT INTO TRANSACTION_LIST VALUES ( " + listNum + ", SYSDATE, '" + Sname + "', '매도', " + price +", " + amount + " )";
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
			sql =	"INSERT INTO HISTORY VALUES ( " + Unum + ", " + listNum + " )";
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
			
			sql =	"SELECT * " +
					"FROM HOLDINGSTOCK " +
					"WHERE Hs_unum = " + Unum + " AND Hs_scode = '" + stockCode + "' ";
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
			
			if(!rs.next()) {
				sql =	"INSERT INTO HOLDINGSTOCK VALUES ( " + Unum + ", '" + stockCode + "', 0, 0 ) ";
				pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
				rs = pstmt.executeQuery();
			}
			
			sql = 	"UPDATE HOLDINGSTOCK " +
					"SET " +
					"Quantity = Quantity - " + amount + " " +
					"WHERE Hs_unum = " + Unum + " AND Hs_scode = '" + stockCode + "' ";
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();

			commit();
			
			return 1;
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
		
		return -3;
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
