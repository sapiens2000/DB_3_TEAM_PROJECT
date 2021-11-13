package project3;
import java.sql.*;

public class oracle {
    
	// Need modification according to your oracle env
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	public static final String USER_UNIVERSITY ="hr";
	public static final String USER_PASSWD ="hr";
		
    private Connection conn;
    private Statement stmt;
    
    public oracle(){
        try {
		
            Class.forName("oracle.jdbc.driver.OracleDriver");
			System.out.println("Driver Loading : Success!");
		} catch(ClassNotFoundException e) {
			System.err.println("error = " + e.getMessage());
			System.exit(1);
		}
    
        try {
            conn = DriverManager.getConnection(URL, USER_UNIVERSITY, USER_PASSWD);
            System.out.println("Oracle Connected.");
        } catch(SQLException ex) {
            ex.printStackTrace();
            System.err.println("Cannot get a connection: " + ex.getLocalizedMessage());
            System.err.println("Cannot get a connection: " + ex.getMessage());
            System.exit(1);
        }
        
        try {
			conn.setAutoCommit(false);
			stmt = conn.createStatement();			
		} catch (SQLException e) {
			e.printStackTrace();
		}
        
        
    }
}
