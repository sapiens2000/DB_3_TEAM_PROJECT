package phase4;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.eclipse.jdt.internal.compiler.ast.ThisReference;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;



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
	
	public static synchronized Oracle getInstance() {
		if(instance == null) {
			instance = new Oracle();
		}
		return instance;
	}
		
	// return Unum for Session
	public synchronized int login(String userId, String userPw) {               
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
	public synchronized int register(UserDto user) {
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
			this.rollback();
			e.printStackTrace();
		}
		return -2; // error
	}

	public synchronized int getUnum() {
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
	
	public synchronized ResultSet getRanking() {
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
	public synchronized void addRanking(UserDto user) {
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
			
			
			}			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			this.rollback();
			e.printStackTrace();
		}
		this.commit();
	}
	
	public synchronized ResultSet getStock() {
		String sql = "SELECT * " + 
					 "FROM STOCK "; 
		
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
	
	// get sector and num of stocks in that.
	public synchronized ResultSet getSector() {
		String sql = "SELECT SECTOR_NAME, COUNT(*) " +
					 "FROM SECTOR " + 
					 "GROUP BY SECTOR_NAME ";
		
		
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
	
	// overload : get stock in sector
	public synchronized ResultSet getSector(String sector) {
		String sql = "SELECT ROWNUM, S2.Sname " +
					 "FROM SECTOR S1, STOCK S2 " +
					 "WHERE S1.SNAME = S2.SNAME AND SECTOR_NAME = '" + sector + "' " ;
				
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
	
	public synchronized ResultSet getUsers() {
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
	
	public synchronized int getUserNum() {
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
	
	public synchronized UserDto getUserData(String userId) {
		UserDto user = UserDto.getUserInstance();
		
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
	
	public synchronized boolean deleteUser(String userId) {
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
			this.rollback();
			e.printStackTrace();
			
		}
		this.commit();
		return false;
	}
	
	public synchronized boolean updateUser(UserDto User) { 
		// update user.
		String sql = "UPDATE USERS " +
					 "SET " +
					 "USER_ID = '" + User.getUserId() + "', " +
					 "UPassword = '" + User.getUserPw() + "', " +
					 "UCash = '" + User.getCash() + "', " +
					 "UAge = " + User.getAge() + ", " + 
					 "UEmail = '" + User.getEmail() + "', " +
					 "UCELL_PHONE_NUMBER = '" + User.getPhone_num() + "' " +
					 "WHERE USER_ID = '" + User.getUserId() + "' ";

		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();
			return true;

		} catch (SQLException e) {
			// TODO Auto-generated catch block
			this.rollback();
			e.printStackTrace();
			
		}
		this.commit();
		return false;
	}
	
	public synchronized ArrayList<Integer> getUsersByAge(){
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
	
	public synchronized int getUserByGender(String gender) {
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
	
	public synchronized int getCompanyNum() {
		String sql = "SELECT COUNT(*) " +
				 	 "FROM STOCK ";
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
	
	public synchronized int getSectorNum() {
		String sql = "SELECT COUNT(*) " +
				 	 "FROM (SELECT DISTINCT(Sector_name) " +
				 	 "FROM SECTOR) ";
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
			
	public synchronized ResultSet getAllDataForChart(String company) {
		String sql = "SELECT C.Chigh_price, C.Clow_price, ROUND((C.Cclose_price - C.Cstart_price) / C.Cstart_price * 100, 2), C.Cstart_price, C.Cclose_price, S.Smarket_cap, " +
					 " S.Smarket, SE.Sector_name, S.Sforeign_rate, S.Sper, S.Spbr, S.Sroe " +
					 "FROM STOCK S, CHART C, SECTOR SE " +
					 "WHERE S.Scode = C.Ccode AND S.Sname = SE.Sname AND SE.Sname ='" + company + "' " +
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
	
	public synchronized String stockChart(String company) {					
		String sql = "SELECT TO_CHAR(CSTART_DATE, 'yyyy-mm-dd') AS CSTART_DATE, C.CSTART_PRICE, CHIGH_PRICE, C.CLOW_PRICE, C.CCLOSE_PRICE " + 
			 	 	 "FROM CHART C, STOCK S " +
			 	 	 "WHERE S.Scode = C.Ccode AND Sname = '" + company + "' " +
			 	 	 "ORDER BY C.Cstart_date ASC ";
		
		JSONArray arr = new JSONArray();
		
		try {
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery(); 
			
			while(rs.next()) {		
				Date date = rs.getDate("CSTART_DATE");
					
				SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.S");
				JSONObject json = new JSONObject();
							
				String newDate = "";		
				Date datelong = null;
				try {
					newDate = simpleDateFormat.format(date);
					datelong = simpleDateFormat.parse(newDate);
				}
				catch(Exception e) {
					e.printStackTrace();
				}

				double open		= rs.getFloat("CSTART_PRICE");
				double high		= rs.getFloat("CHIGH_PRICE");
				double low		= rs.getFloat("CLOW_PRICE");
				double close	= rs.getFloat("CCLOSE_PRICE");

				json.put("date", datelong.getTime());
				json.put("open", open);
				json.put("high", high);
				json.put("close", close);
				json.put("low", low);
				
				arr.add(json);
			}			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}	
				
		
		return arr.toString();
	}

	public synchronized ResultSet getChangeRate() {
		// get latest data
		String sql = "SELECT * " +
					 "FROM LATESTCHANGERATE ";

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
	
	public synchronized ResultSet getTransaction(String userId, String start, String end) {
		String sql;
		
		if((start == null & end == null) || (start.equals("") & end.equals(""))) { // all
			sql = "SELECT TWHEN, TNAME, TYPE, TVALUE, TVOLUME, (TVALUE*TVOLUME) AS TOTAL " +
				  "FROM TRANSACTION_LIST, HISTORY, USERS " +
				  "WHERE UNUM = HUNUM AND HTNUM = TNUM AND User_id = '" + userId + "' ";
		}else if(start.equals("") & !end.equals("")) { // until end date
			sql = "SELECT TWHEN, TNAME, TYPE, TVALUE, TVOLUME, (TVALUE*TVOLUME) AS TOTAL " +
				  "FROM TRANSACTION_LIST, HISTORY, USERS " +
				  "WHERE UNUM = HUNUM AND HTNUM = TNUM AND User_id = '" + userId + "' " + 
				  "AND Twhen <= '" + end + "' ";
		}else if(!start.equals("") & end.equals("")){ // after start date
			sql = "SELECT TWHEN, TNAME, TYPE, TVALUE, TVOLUME, (TVALUE*TVOLUME) AS TOTAL " +
					  "FROM TRANSACTION_LIST, HISTORY, USERS " +
					  "WHERE UNUM = HUNUM AND HTNUM = TNUM AND User_id = '" + userId + "' " + 
					  "AND Twhen >= '" + start + "' ";
		}else { // between start and end date
			sql = "SELECT TWHEN, TNAME, TYPE, TVALUE, TVOLUME, (TVALUE*TVOLUME) AS TOTAL " +
				  "FROM TRANSACTION_LIST, HISTORY, USERS " +
				  "WHERE UNUM = HUNUM AND HTNUM = TNUM AND User_id = '" + userId + "' " + 
				  "AND Twhen BETWEEN '" + start + "' AND '" + end + "' ";
		}
		
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
	
	public synchronized ResultSet getHoldingStock(String company, int Unum) {
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
	
	public synchronized ResultSet getHoldingStock(String userId) {
		// get latest data		
		String sql = "";
		
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
	
	public synchronized ResultSet getHoldingCash(int Unum) {
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
			
	public synchronized int buyStock(String stockName, int Unum, int amount) {
		
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
			this.rollback();
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
				
				this.commit();
				
				return 1;
			}
			else {
				return -1;
			}
			
		} catch (SQLException e) {
			this.rollback();
			e.printStackTrace();
		}
		return -3;
	}
	
	public synchronized int sellStock(String Sname, int Unum, int amount) {
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
			
			sql = 	"SELECT DISTINCT Sname, Quantity " +
					"FROM USERS U, HOLDINGSTOCK HS, STOCK S " +
					"WHERE U.Unum = HS.Hs_unum  " + 
					"	AND Hs.Hs_Scode = S.Scode " +
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
			this.rollback();
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
			
			
			sql =	"SELECT QUANTITY " +
					"FROM HOLDINGSTOCK " +
					"WHERE Hs_unum = " + Unum + " AND Hs_scode = '" + stockCode + "' ";
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				if(rs.getInt(1) == 0){
					sql =	"DELETE HOLDINGSTOCK WHERE Hs_unum = " + Unum + " AND Hs_scode = '" + stockCode + "' ";
					pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
					rs = pstmt.executeQuery();
				}
			}

			this.commit();
			return 1;
			
		} catch (SQLException e) {
			this.rollback();
			e.printStackTrace();
		}
		
		return -3;
	}
	
	public synchronized ResultSet getAsset(int Unum) {
		String sql = "SELECT ROWNUM, Sname, Quantity, Item_assets " + 
					 "FROM USERS, HOLDINGSTOCK, STOCK " +
					 "WHERE UNUM = HS_UNUM AND SCODE = HS_SCODE AND Unum = " + Unum + " ";
			
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
	
	public synchronized ResultSet searchStock(SearchOption option) {
		String sql = "SELECT S.Sname, CHANGERATE, CCLOSE_PRICE, SMARKET_CAP, SFOREIGN_RATE, SPER, SPBR, SROE " +
					 "FROM LATESTCHANGERATE L, STOCK S " +
					 "WHERE S.Sname = L.Sname "; 
				
		// two	
		if(!option.getMinPrice().equals("") && !option.getMaxPrice().equals("")) {
			sql = sql + "AND Cclose_price between " + option.getMinPrice() + " AND " + option.getMaxPrice() + " ";
		}
		// max only
		else if(option.getMinPrice().equals("") && !option.getMaxPrice().equals("")) {
			sql = sql + "AND Cclose_price <= " + option.getMaxPrice() + " ";
		}
		// min only
		else if(!option.getMinPrice().equals("") && option.getMaxPrice().equals("")) {
			sql = sql + "AND Cclose_price >= " + option.getMinPrice() + " ";
		}
				
		// market cap up or down
		if (!option.getMarketCap().equals("")) {
			if(option.getMarketCap().equals("true")) 
				sql = sql + "AND Smarket_cap >= " + option.getMarketCap() + " ";
			else
				sql = sql + "AND Smarket_cap <= " + option.getMarketCap() + " ";		
		}
		// foreign cap up or down
		if (!option.getForeign().equals("")) {
			if(option.getForeignUp().equals("true")) 
				sql = sql + "AND Sforeign_rate >= " + option.getForeign() + " ";
			else
				sql = sql + "AND Sforeign_rate <= " + option.getForeign() + " ";		
		}
		
		// per cap up or down
		if (!option.getPer().equals("")) {
			if(option.getPerUp().equals("true")) 
				sql = sql + "AND Sper >= " + option.getPer() + " ";
			else
				sql = sql + "AND Sper <= " + option.getPer() + " ";
		}
		// pbr cap up or down
		if (!option.getPbr().equals("")) {
			if(option.getPbrUp().equals("true")) 
				sql = sql + "AND Spbr >= " + option.getPbr() + " ";
			else
				sql = sql + "AND Spbr <= " + option.getPbr() + " ";
		}	
		
		// roe cap up or down
		if (!option.getRoe().equals("")) {
			if(option.getRoeUp().equals("true")) 
				sql = sql + "AND Sroe >= " + option.getRoe() + " ";
			else
				sql = sql + "AND Sroe <= " + option.getRoe() + " ";
		}
				
		sql = sql + " ";
		
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
	
	public synchronized ResultSet getNewsInChart(String company) {		
		String sql = "SELECT N.Ntitle, N.Nurl " +
				 	 "FROM NEWS N, MENTION M " + 
				 	 "WHERE N.Ntitle LIKE '%" + company + "%' ";
	
		try {
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			rs = pstmt.executeQuery(); 
			
			if(rs.next()) {
				rs.beforeFirst();
				return rs;
			}
			else {
				News news = News.getNewsInstance();
				// insert new news
				news.setUrl(company);
				news.setCompany(company);
				news.getNews();
				
				try {
					pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
					rs = pstmt.executeQuery(); 
					
					if(rs.next()) {
						rs.beforeFirst();
						return rs;
					}
				}catch(SQLException ex){
					ex.printStackTrace();
				}
			}
			
		} catch (SQLException e) {
		// 	TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
		
	}
	
	public synchronized void insertNews(ArrayList<ArrayList<String>> news, String company) {
		String sql = "";
		String date, title, url= "";
		
		// 뉴스 10개씩 얻어옴. news.java 에서
		
		for(int i=0;i<10;i++) {
			date = news.get(0).get(i);
			title = news.get(1).get(i);
			url = news.get(2).get(i);
			
			sql = "INSERT INTO NEWS ( Nwhen, Ntitle, Nurl, Ncompany ) " + 
				 	 "SELECT '" + date + "', '" + title + "', '" + url + "', '" + company + "' FROM DUAL A " +
				 	 "WHERE NOT EXISTS " +
				 	 "(SELECT Nwhen, Ntitle, Nurl, Ncompany FROM NEWS " +
				 	 "WHERE Nurl = '" + url + "') ";			
			
			try {
				pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
				rs = pstmt.executeQuery(); 
								
				
			} catch (SQLException e) {
			// TODO Auto-generated catch block
				this.rollback();
				e.printStackTrace();
			}
			
						
		}
	}
		
	public synchronized void commit() {
		try {
			conn.commit();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public synchronized void rollback() {
		try {
			conn.rollback();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public synchronized void close() {
		try {
			if(!conn.isClosed()) {
				conn.close();
			}
			if(!pstmt.isClosed()) {
				pstmt.close();
			}
			if(!rs.isClosed()) {
				rs.close();
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}

