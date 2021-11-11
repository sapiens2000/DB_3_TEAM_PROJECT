package project3;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Date;
import java.util.Scanner;
import java.util.StringTokenizer;

public class mainUI {
	
	// Need modification according to your oracle env
	public static final String URL = "jdbc:oracle:thin:@localhost:1521:orcl";
	public static final String USER_UNIVERSITY ="hr";
	public static final String USER_PASSWD ="hr";
	
	
	static mainUI start;
	static Scanner scanner;
	static Connection conn;
	static Statement stmt;
	
	static final String ADMIN_ID = "ADMIN";
	static final String ADMIN_PW = "TEAM3";
	
	public static void main(String[] args) {
		
		scanner = new Scanner(System.in);
		start = new mainUI();
		
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
		
		while(true) {
			
			int inputNumber = 0;
			
			start.displayMenu();
			inputNumber = start.selectMenu(5);
			
			switch (inputNumber) {

            case 1:
                start.inStock();
                break;
            case 2:
                start.inNews();
                break;
            case 3:
                start.inCompany();
                break;
            case 4:
                start.inLogin();
                break;
            case 5:
            	start.inAdmin();
            	break;
            case 0:
               start.exitProgram();

            default:
                System.out.println("다시 선택하세요!");
			}
		}
	}
	
	public void displayMenu() {

        System.out.println("");
        System.out.println("..............................");
        System.out.println("Team3 주식 프로그램");
        System.out.println("..............................");
        System.out.println(" 1. 주식 검색");
        System.out.println(" 2. 뉴스 검색");
        System.out.println(" 3. 기업 검색");
        System.out.println(" 4. 유저 메뉴");
        System.out.println(" 5. 관리자 메뉴");
        System.out.println("..............................");
        System.out.println(" 0. 프로그램 종료");
        System.out.println("..............................");
    }
	
	public int selectMenu (int num) {

        System.out.print("선택: ");
        int menuNumber = scanner.nextInt();

        if (menuNumber >= 0 && menuNumber <= num) {
            scanner.nextLine();
            return menuNumber;
        } else {
        	System.out.println("없는 번호입니다. " + menuNumber);
            return -1;
        }
    }

	public void exitProgram() {

        System.out.println("프로그램을 종료합니다.");
        scanner.close();
        System.exit(0);
    }
	
	public void inStock() {
		
		while(true) {
			
			int inputNumber = 0;
			
			start.displayStockMenu();
			inputNumber = start.selectMenu(6);
			
			switch (inputNumber) {

            case 1:
                 start.foreign();
                break;
            case 2:
                start.PBR();
                break;
            case 3:
                start.change();
                break;
            case 4:
                start.totalDeal();
                break;
            case 5:
            	start.upRate();
            	break;
            case 6:
            	start.marketCpaitalization();
            	break;
            case 0:
               return;

            default:
                System.out.println("다시 선택하세요!");
			}
		}
	}
	
	public void displayStockMenu() {

        System.out.println("");
        System.out.println("..............................");
        System.out.println("주식 검색");
        System.out.println("..............................");
        System.out.println(" 1. 외국인 보유 비율 확인");
        System.out.println(" 2. PBR 검색");
        System.out.println(" 3. 변동률 검색");
        System.out.println(" 4. 총 거래량 검색");
        System.out.println(" 5. 상승률 검색");
        System.out.println(" 6. 섹터별 시가 총액 검색");
        System.out.println("..............................");
        System.out.println(" 0. 이전 메뉴");
        System.out.println("..............................");
    }
	
	public void foreign() {
		 System.out.print("외국인 보유비율 (0 - 100 사이의 정수 입력) : ");
	        float input = scanner.nextFloat();
	        
	        if (input >= 0 && input <= 100) {
	        	ResultSet rs = null;
	    		
	    		try {			
	    			
	    			String sql = "";
	    			sql = 	"SELECT Sname, Scode " +
	    					"FROM STOCK S " +
	    					"WHERE Sforeign_rate > " + input;
	    			rs = stmt.executeQuery(sql);
	    			System.out.println("");
	    			System.out.println("<< result >>");
	    			System.out.println("이름	|	코드");
	    			System.out.println("---------------------------");
	    			while(rs.next()) {
	    				String Sname	= rs.getString(1);
	    				String Scode	= rs.getString(2);
	    				System.out.println(Sname +"		|	" + Scode);
	    			}
	    			rs.close();
	    			
	    			System.out.println();
	    			
	    		} catch (SQLException e) {
	    			e.printStackTrace();
	    		}
	        } else {
	        	System.out.println("0 이상 100 이하의 정수를 입력해주세요. ");
	        }
	}

	public void PBR() {
		System.out.print("ROE % (0 - 100 사이의 정수 입력) : ");
        float input = scanner.nextFloat();
        
        if (input >= 0 && input <= 100) {
        	ResultSet rs = null;
    		
    		try {			
    			
    			String sql = "";
    			sql = 	"SELECT S.Sname, S.spbr " +
    					"FROM STOCK S " +
    					"WHERE S.spbr IN (SELECT S.spbr " +
    					"					FROM STOCK S " + 
    					"					WHERE S.sroe > " + input + ")";
    			rs = stmt.executeQuery(sql);
    			System.out.println("");
    			System.out.println("<< result >>");
    			System.out.println("이름	|	PBR");
    			System.out.println("---------------------------");
    			while(rs.next()) {
    				String Sname	= rs.getString(1);
    				String Spbr	= rs.getString(2);
    				System.out.println(Sname +"		|	" + Spbr);
    			}
    			rs.close();
    			
    			System.out.println();
    			
    		} catch (SQLException e) {
    			e.printStackTrace();
    		}
        } else {
        	System.out.println("0 이상 100 이하의 정수를 입력해주세요. ");
        }
	}
	
	public void change() {
		System.out.print("변동률 (% 제외한 비율만 입력) : ");
        float input = scanner.nextFloat();
        
       	ResultSet rs = null;
    		
   		try {			
    			
   			String sql = "";
   			sql = 	"SELECT Cstart_date, Cend_date, Sname, Cclose_price, Cscale " +
   					"FROM STOCK, CHART " +
   					"WHERE Scode = Ccode " +
   					"	AND Ccode IN (SELECT C.Ccode " + 
   					"					FROM CHART C " + 
   					"					WHERE C.Cscale = 'D'" + 
   					"					AND (C.Cstart_price - C.Cclose_price) / C.Cclose_price * 100 < " + input + ")";
   			rs = stmt.executeQuery(sql);
   			System.out.println("");
   			System.out.println("<< result >>");
   			System.out.println("시작일	|	종료일	|	주식이름	|	종료가격	|	차트 구분");
   			System.out.println("---------------------------");
   			
   			boolean hasData = false;
   			
   			while(rs.next()) {
   				String startDate	= rs.getString(1);
   				String endDate		= rs.getString(2);
   				String Sname 		= rs.getString(3);
   				int close_price		= rs.getInt(4);
   				String scale		= rs.getString(5);
   				System.out.println(startDate + "		|	" + endDate + "		|	" + Sname + "		|	" +
    									close_price + "		|	" + scale);
   				hasData = true;
   			}
   			if( !hasData ) {
   				System.out.println("데이터가 없습니다.");
   			}
   			rs.close();
    			
   			System.out.println();
    			
   		} catch (SQLException e) {
   			e.printStackTrace();
   		}
        
	}
	
	public void totalDeal() {
		System.out.print("날짜 입력 (yyyymmdd - yyyymmdd) : ");
        String input = scanner.nextLine();
        
    	StringTokenizer temp1;
        temp1 = new StringTokenizer(input, "-");
        
        if (true) {
        	ResultSet rs = null;
    		
    		try {			
    			
    			String sql = "";
    			sql = 	"SELECT HS.Tname, HS.Type, SortByType.SumofTrans " +
    					"FROM (SELECT TS.Type, SUM(TS.Tvolume) SumofTrans " +
    					"		FROM TRANSACTION_LIST TS " +
    					"		GROUP BY TS.Type) SortByType " + 
    					"		, TRANSACTION_LIST HS " + 
    					"WHERE HS.Twhen > '" + temp1.nextToken() +"' AND HS.Twhen <= '" + temp1.nextToken() +"'";
    			rs = stmt.executeQuery(sql);
    			System.out.println("");
    			System.out.println("<< result >>");
    			System.out.println("거래명	|	타입	|	거래량	");
    			System.out.println("---------------------------");
    			
    			boolean hasData = false;
    			
    			while(rs.next()) {
    				String Tname	= rs.getString(1);
    				String Type		= rs.getString(2);
    				float sum 		= rs.getFloat(3);
    				System.out.println(Tname + "		|	" + Type + "		|	" + sum);
    				
    				hasData = true;
    			}
    			if( !hasData ) {
    				System.out.println("데이터가 없습니다.");
    			}
    			rs.close();
    			
    			System.out.println();
    			
    		} catch (SQLException e) {
    			e.printStackTrace();
    		}
        } else {
        	System.out.println("날짜 형식을 맞춰서 입력해주세요. ");
        }
	}
	
	public void upRate() {
		System.out.print("상승률 (% 제외한 비율만 입력) : ");
        float input = scanner.nextFloat();
        
 
       	ResultSet rs = null;
    		
   		try {			
    			
   			String sql = "";
   			sql = 	"SELECT DISTINCT S.Sname " +
   					"FROM STOCK S, CHART C " +
   					"WHERE S.Scode = C.Ccode " +
   					"	AND S.Scode IN (SELECT S.Scode " + 
   					"					FROM STOCK S, CHART C " +
   					"					WHERE S.Scode = C.Ccode" +
   					"						AND C.Cstart_date >= '20201001'" +
   					"						AND (C.Cstart_price / C.Cclose_price) >= " + input +")";
   			rs = stmt.executeQuery(sql);
   			System.out.println("");
   			System.out.println("<< result >>");
   			System.out.println("주식명");
   			System.out.println("---------------------------");
   			
   			boolean hasData = false;
   			while(rs.next()) {
   				String Sname	= rs.getString(1);
   				System.out.println(Sname);
   				hasData = true;
   			}
   			if( !hasData ) {
   				System.out.println("데이터가 없습니다.");
   			}
   			rs.close();
   			
   			System.out.println();
   			
   		} catch (SQLException e) {
   			e.printStackTrace();
   		}
	}
	
	public void marketCpaitalization() {
		System.out.print("날짜 입력 및 시가총액 검색 하한선 (조단위) (yyyymmdd - 시가총액) : ");
        String input = scanner.nextLine();
        
    	StringTokenizer temp1;
        temp1 = new StringTokenizer(input, "-");

       	ResultSet rs = null;
    		
   		try {			
    			
   			String sql = "";
   			sql = 	"SELECT ST.Sector_name, COUNT(S.Sname) AS CT " +
   					"FROM STOCK S, CHART C, SECTOR ST " +
   					"WHERE S.Scode = C.Ccode " +
   					"   AND ST.Scode = S.Scode " + 
   					"   AND C.Cstart_date > '" + temp1.nextToken() +"' " +
   					"	AND C.Cscale = 'D' " +
   					"	AND S.Smarket_cap >= " + temp1.nextToken() + " " +
   					"GROUP BY ST.Sector_name " +
   					"ORDER BY CT ";
   			rs = stmt.executeQuery(sql);
   			System.out.println("");
   			System.out.println("<< result >>");
   			System.out.println("주식명");
   			System.out.println("---------------------------");
   			
   			boolean hasData = false;
   			while(rs.next()) {
   				String Sname	= rs.getString(1);
   				int sum			= rs.getInt(2);
   				System.out.println(Sname + "	|	" + sum);
   				hasData = true;
   			}
   			if( !hasData ) {
				System.out.println("데이터가 없습니다.");
			}
   			rs.close();
   			
   			System.out.println();
   			
   		} catch (SQLException e) {
   			e.printStackTrace();
   		}
	}
	
	public void inNews() {
			
			while(true) {
				
				int inputNumber = 0;
				
				start.displayNewsMenu();
				inputNumber = start.selectMenu(3);
				
				switch (inputNumber) {
	
	            case 1:
	                 start.title();
	                break;
	            case 2:
	                start.PerNews();
	                break;
	            case 3:
	                start.companyNews();
	                break;
	            case 0:
	               return;
	
	            default:
	                System.out.println("다시 선택하세요!");
				}
			}
	}
	
	public void displayNewsMenu() {

        System.out.println("");
        System.out.println("..............................");
        System.out.println("뉴스 검색");
        System.out.println("..............................");
        System.out.println(" 1. 제목 검색");
        System.out.println(" 2. PER 검색");
        System.out.println(" 3. 기업 이름 검색");
        System.out.println("..............................");
        System.out.println(" 0. 이전 메뉴");
        System.out.println("..............................");
    }
	
	public void title() {
		
		System.out.print("제목 검색 : ");
        String input = scanner.nextLine();

       	ResultSet rs = null;
    		
   		try {			
    			
   			String sql = "";
   			sql = 	"SELECT N.Ntitle, N.Nurl " +
   					"FROM NEWS N " +
   					"WHERE N.Ntitle LIKE '%" + input + "%' ";
   			rs = stmt.executeQuery(sql);
   			System.out.println("");
   			System.out.println("<< result >>");
   			System.out.println("뉴스 제목	|	URL");
   			System.out.println("---------------------------");
   			
   			boolean hasData = false;
   			while(rs.next()) {
   				String company	= rs.getString(1);
   				String url			= rs.getString(2);
   				System.out.println(company + "	|	" + url);
   				hasData = true;
   			}
   			if( !hasData ) {
				System.out.println("데이터가 없습니다.");
			}
   			rs.close();
   			
   			System.out.println();
   			
   		} catch (SQLException e) {
   			e.printStackTrace();
   		}
	}
	
	public void PerNews() {
		System.out.print("날짜 및 PER 입력 (yyyymmdd - yyyymmdd - PER수치(% 제외한 비율만 입력)) : ");
        String input = scanner.nextLine();
        
        StringTokenizer temp1;
        temp1 = new StringTokenizer(input, " - ");
        
        String date1 = temp1.nextToken();
        String date2 = temp1.nextToken();
        String PERNUM = temp1.nextToken();

       	ResultSet rs = null;
    		
   		try {			
    			
   			String sql = "";
   			sql = 	"SELECT N.Nwhen, N.Nurl " +
   					"FROM STOCK S, NEWS N, MENTION M " +
   					"WHERE  S.Scode = M.Mcode " +
   					"	AND M.Murl = N.Nurl " +
   					"	AND S.sper > " + PERNUM + " " +
   					"	AND (N.Nwhen >= '" + date1 +"' " +
   					"         AND N.Nwhen < '" + date2 +"')";
   			rs = stmt.executeQuery(sql);
   			System.out.println("");
   			System.out.println("<< result >>");
   			System.out.println("날짜	|	URL");
   			System.out.println("---------------------------");
   			
   			boolean hasData = false;
   			while(rs.next()) {
   				String date	= rs.getString(1);
   				String url			= rs.getString(2);
   				System.out.println(date + "	|	" + url);
   				hasData = true;
   			}
   			if( !hasData ) {
				System.out.println("데이터가 없습니다.");
			}
   			rs.close();
   			
   			System.out.println();
   			
   		} catch (SQLException e) {
   			e.printStackTrace();
   		}
	}
	
	public void companyNews() {
		System.out.print("날짜 및 회사명 입력 (yyyymmdd - 회사명) : ");
        String input = scanner.nextLine();
        
        StringTokenizer temp1;
        temp1 = new StringTokenizer(input, " - ");
                

       	ResultSet rs = null;
    		
   		try {			
    			
   			String sql = "";
   			sql = 	"SELECT NC.Ncompany, NC.Nurl " +
   					"FROM (SELECT N.Nurl, N.Ncompany " +
   					"		FROM NEWS N " +
   					"		WHERE N.Nwhen >= '" + temp1.nextToken() + "') NC " +
   					"WHERE NC.Ncompany = '" + temp1.nextToken() + "' ";
   			rs = stmt.executeQuery(sql);
   			System.out.println("");
   			System.out.println("<< result >>");
   			System.out.println("회사	|	URL");
   			System.out.println("---------------------------");
   			
   			boolean hasData = false;
   			while(rs.next()) {
   				String company	= rs.getString(1);
   				String url			= rs.getString(2);
   				System.out.println(company + "	|	" + url);
   				hasData = true;
   			}
   			if( !hasData ) {
				System.out.println("데이터가 없습니다.");
			}
   			rs.close();
   			
   			System.out.println();
   			
   		} catch (SQLException e) {
   			e.printStackTrace();
   		}
	}
	
	public void inCompany() {
		
		while(true) {
			
			int inputNumber = 0;
			
			start.displayCompanyMenu();
			inputNumber = start.selectMenu(1);
			
			switch (inputNumber) {
	
	        case 1:
	             start.sector();
	        case 0:
	           return;
	
	        default:
	            System.out.println("다시 선택하세요!");
			}
		}
	}
	
	public void displayCompanyMenu() {

        System.out.println("");
        System.out.println("..............................");
        System.out.println("기업 검색");
        System.out.println("..............................");
        System.out.println(" 1. 섹터 비교");
        System.out.println("..............................");
        System.out.println(" 0. 이전 메뉴");
        System.out.println("..............................");
    }
	
	public void sector() {
		
		System.out.print("섹터 입력 (섹터1 - 섹터2) : ");
        String input = scanner.nextLine();
        
        StringTokenizer temp1;
        temp1 = new StringTokenizer(input, " - ");

       	ResultSet rs = null;
    		
   		try {			
    			
		String sql = "";
		sql = 	"SELECT S.Sname, S.Smarket_cap " +
				"FROM STOCK S, SECTOR SS " +
				"WHERE S.Smarket_cap > ALL (SELECT S.Smarket_cap " +
				"							FROM STOCK " +
				"							WHERE Sector_name = '" + temp1.nextToken() +"') " + 
				"    AND S.scode = ss.scode " +
				"    AND SS.sector_name = '" + temp1.nextToken() + "'";
		rs = stmt.executeQuery(sql);
		System.out.println("");
		System.out.println("<< result >>");
		System.out.println("주식명	|	cap");
		System.out.println("---------------------------");
		
		boolean hasData = false;
		while(rs.next()) {
			String Sname	= rs.getString(1);
			String cap			= rs.getString(2);
			System.out.println(Sname + "	|	" + cap);
			hasData = true;
		}
		if( !hasData ) {
			System.out.println("데이터가 없습니다.");
		}
		rs.close();
   			
		System.out.println();
   			
   		} catch (SQLException e) {
   			e.printStackTrace();
   		}

	}
	
	public void inLogin() {
		
		while(true) {
			
			int inputNumber = 0;
			
			start.displayLoginMenu();
			inputNumber = start.selectMenu(2);
			
			switch (inputNumber) {
	
	        case 1:
	             start.login();
	            break;
	        case 2:
	            start.join();
	            break;
	        case 0:
	           return;
	
	        default:
	            System.out.println("다시 선택하세요!");
			}
		}
	}
	
	public void displayLoginMenu() {

        System.out.println("");
        System.out.println("..............................");
        System.out.println("로그인 메뉴");
        System.out.println("..............................");
        System.out.println(" 1. 로그인");
        System.out.println(" 2. 회원 가입");
        System.out.println("..............................");
        System.out.println(" 0. 이전 메뉴");
        System.out.println("..............................");
    }
	
	public void login() {
		System.out.print("ID : ");
        String loginID = scanner.nextLine();
        System.out.print("Password : ");
        String loginPW = scanner.nextLine();
                
       	ResultSet rs = null;
    		
   		try {			
    			
   			String sql = "";
   			sql = 	"SELECT Unum " +
   					"FROM USERS " +
   					"WHERE User_id = '" + loginID +"' and Upassword = '" + loginPW +"' ";
   			rs = stmt.executeQuery(sql);
   			if(rs.next()) {
   				int Unum	= rs.getInt(1);
   				start.inUser(Unum);
   			}
   			else {
   				System.out.println("존재하지 않는 회원입니다.");
   			}
   			rs.close();
   			
   			System.out.println();
   			
   		} catch (SQLException e) {
   			e.printStackTrace();
   		}
	}
	
	public void inUser(int userNum) {
		
		while(true) {
			
			int inputNumber = 0;
			
			start.displayUserMenu();
			inputNumber = start.selectMenu(6);
			
			switch (inputNumber) {
	
	        case 1:
	             start.userInfo(userNum);
	            break;
	        case 2:
	            start.totalCash(userNum);
	            break;
	        case 3:
	            start.totalAsset(userNum);
	            break;
	        case 4:
	            start.transactionList(userNum);
	            break;
	        case 5:
	        	start.buy(userNum);
	        	break;
	        case 6:
	        	start.sell(userNum);
	        	break;
	        case 0:
	           return;
	
	        default:
	            System.out.println("다시 선택하세요!");
			}
		}
	}
	
	public void displayUserMenu() {

        System.out.println("");
        System.out.println("..............................");
        System.out.println("유저 메뉴");
        System.out.println("..............................");
        System.out.println(" 1. 회원 정보");
        System.out.println(" 2. 보유 자산");
        System.out.println(" 3. 보유 주식");
        System.out.println(" 4. 거래 내역");
        System.out.println(" 5. 매수");
        System.out.println(" 6. 매도");
        System.out.println("..............................");
        System.out.println(" 0. 이전 메뉴");
        System.out.println("..............................");
        System.out.println("");
    }
	
	public void userInfo(int Unum) {
                

       	ResultSet rs = null;
    		
   		try {			
    			
   			String sql = "";
   			sql = 	"SELECT * " +
   					"FROM USERS " +
   					"WHERE Unum = " + Unum;

   			System.out.println("");
   			System.out.println("<< result >>");
   			System.out.println("ID	|	나이	|	성별	|	이메일	|	전화번호");
   			System.out.println("---------------------------");
    			
   			rs = stmt.executeQuery(sql);
   			if(rs.next()) {
   				String UserId 	= rs.getString(1);
   				int Ucurrent_asset	= rs.getInt(4);
   				int Ucash 		= rs.getInt(5);
   				int Uage		= rs.getInt(6);
   				String Usex		= rs.getString(7);
   				String Uemail	= rs.getString(8);
   				String Uphone	= rs.getString(9);
   				
       			System.out.println(UserId +  "	|	" + Uage + "	|	" + Usex + "	|	" + Uemail + "	|	" + Uphone);
   			}
   			rs.close();
    			
   			System.out.println();
    			
   		} catch (SQLException e) {
   			e.printStackTrace();
   		}

	}
	
	public void totalCash(int Unum) {
		ResultSet rs = null;
		
		try {			
			
			String sql = "";
			sql = 	"SELECT * " +
					"FROM USERS " +
					"WHERE Unum = " + Unum;

			System.out.println("");
			System.out.println("<< result >>");
			System.out.println("보유 자산");
			System.out.println("---------------------------");
			
			rs = stmt.executeQuery(sql);
			if(rs.next()) {
				int Ucash	= rs.getInt(5);
				
    			System.out.println(Ucash);
			}
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void totalAsset(int Unum) {
		ResultSet rs = null;
		
		try {			
			
			String sql = "";
			
			sql = 	"SELECT DISTINCT Sname, I.Quantity " +
					"FROM USERS U, INTEREST I, STOCK S " +
					"WHERE U.Unum = I.In_unum  " + 
					"	AND I.In_Scode = S.Scode " +
					"	AND U.Unum = " + Unum;

			System.out.println("");
			System.out.println("<< result >>");
			System.out.println("주식	|	총계");
			System.out.println("---------------------------");
			
			rs = stmt.executeQuery(sql);
			
			boolean hasData = false;
			
			while(rs.next()) {	
				String Sname 		= rs.getString(1);
				int sum		= rs.getInt(2);
					
	    		System.out.println(Sname + "	|	" + sum);
	    		hasData = true;
			}
			
			if( !hasData ) {
				System.out.println("보유 주식이 없습니다.");
			}
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void transactionList(int Unum) {
		System.out.print("거래기간 (yyyymmdd - yyyymmdd) : ");
        String input = scanner.nextLine();
        
        StringTokenizer temp1;
        temp1 = new StringTokenizer(input, " - ");
		
		ResultSet rs = null;
		
		try {			
			
			String sql = "";
			sql = 	"SELECT T.Twhen, T.Tname, T.Type, T.Tvolume " +
					"FROM USERS U, HISTORY H, TRANSACTION_LIST T " +
					"WHERE U.Unum = H.Hunum " +
					"	AND H.Htnum = T.Tnum " + 
					"	AND T.Twhen >= '" + temp1.nextToken() + "' " +
					"	AND T.Twhen < '" + temp1.nextToken() + "' " +
					"	AND U.Unum = " + Unum;

			System.out.println("");
			System.out.println("<< result >>");
			System.out.println("거래일시	|	주식명	|	거래종류	|	거래량");
			System.out.println("---------------------------");
			
			rs = stmt.executeQuery(sql);
			
			boolean hasData = false;
			while(rs.next()) {
				String date 	= rs.getString(1);
				String Sname	= rs.getString(2);
				String type 	= rs.getString(3);
				int Uage		= rs.getInt(4);
				
    			System.out.println(date +  "	|	" + Sname + "	|	" + type + "	|	" + Uage);
    			hasData = true;
			}
			if( !hasData ) {
				System.out.println("거래기록이 없습니다.");
			}
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void buy(int Unum) {
		
		String stockName = "";
		String stockCode = "";
		int price = 0;
		int amount = 0;
		
		ResultSet rs = null;
				
		System.out.print("매수할 주식명과 수량을 입력해주세요. (주식명 - 수량) : ");
			
		String nameAndCnt = scanner.nextLine();
			
        StringTokenizer temp1;
        temp1 = new StringTokenizer(nameAndCnt, " - ");
		stockName = temp1.nextToken();
		amount = Integer.parseInt(temp1.nextToken());	        
			
		try {			
				
			String sql = "";
			sql = 	"SELECT S.Scode, C.Cclose_price " +
					"FROM CHART C, STOCK S " +
					"WHERE S.Scode = C.Ccode AND Sname = '" + stockName + "' " +
					"ORDER BY C.Cstart_date DESC ";
				
			rs = stmt.executeQuery(sql);
				
			if(rs.next()) {
				stockCode = rs.getString(1);
				price = rs.getInt(2);
			}
			else {
				System.out.println("현재 매수가 불가합니다.");
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
			
			rs = stmt.executeQuery(sql);
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
				stmt.executeUpdate(sql);
				int listNum = 0;
				
				sql = 	"SELECT MAX(Tnum) " +
						"FROM TRANSACTION_LIST ";
				rs = stmt.executeQuery(sql);
				if(rs.next()) {
					listNum = rs.getInt(1) + 1;
				}
				
				sql = 	"INSERT INTO TRANSACTION_LIST VALUES ( " + listNum + ", SYSDATE, '" + stockName + "', '매수', " + price +", " + amount + " )";
				stmt.addBatch(sql);
				sql =	"INSERT INTO HISTORY VALUES ( " + Unum + ", " + listNum + " )";
				stmt.addBatch(sql);
				sql = 	"UPDATE INTEREST " +
						"SET " +
						"Quantity = Quantity + " + amount + " " +
						"WHERE In_unum = " + Unum + " AND In_scode = '" + stockCode + "' ";
				stmt.addBatch(sql);
				stmt.executeBatch();
				
				System.out.println("");
				System.out.println("<< result >>");
				System.out.println("주식명	|	주식코드	|	수량");
				System.out.println("---------------------------");
				System.out.println(stockName + "	" + stockCode + "	" + amount + "	매수 완료");
				conn.commit();
			}
			else {
				System.out.println("잔액이 부족합니다.");
			}

			
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void sell(int Unum) {
		String stockName = "";
		String stockCode = "";
		int price = 0;
		int amount = 0;
		

		ResultSet rs = null;
		String sql = "";
		
		try {
			
			sql = 	"SELECT DISTINCT Sname, I.Quantity " +
					"FROM USERS U, INTEREST I, STOCK S " +
					"WHERE U.Unum = I.In_unum  " + 
					"	AND I.In_Scode = S.Scode " +
					"	AND U.Unum = " + Unum;
			
			rs = stmt.executeQuery(sql);
			
			boolean hasData = false;
			
			
			System.out.println("");
			System.out.println("<< result >>");
			System.out.println("보유주식	|	총계");
			System.out.println("---------------------------");
			
			while(rs.next()) {	
				
				String Sname 		= rs.getString(1);
				int sum		= rs.getInt(2);
					
	    		System.out.println(Sname + "	|	" + sum);
	    		hasData = true;
			}
			
			if( !hasData ) {
				System.out.println("보유주식이 없습니다.");
				return;
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
				
		System.out.print("매도할 주식명과 수량을 입력해주세요. (주식명 - 수량) : ");
			
		String nameAndCnt = scanner.nextLine();
			
        StringTokenizer temp1;
        temp1 = new StringTokenizer(nameAndCnt, " - ");
		stockName = temp1.nextToken();
		amount = Integer.parseInt(temp1.nextToken());	        
			
		try {			

			sql = 	"SELECT S.Scode, C.Cclose_price " +
					"FROM CHART C, STOCK S " +
					"WHERE S.Scode = C.Ccode AND Sname = '" + stockName + "' " +
					"ORDER BY C.Cstart_date DESC ";
				
			rs = stmt.executeQuery(sql);
				
			if(rs.next()) {
				stockCode = rs.getString(1);
				price = rs.getInt(2);
			}
			else {
				System.out.println("현재 매도가 불가합니다.");
			}
			
			sql = 	"SELECT DISTINCT Sname, I.Quantity " +
					"FROM USERS U, INTEREST I, STOCK S " +
					"WHERE U.Unum = I.In_unum  " + 
					"	AND I.In_Scode = S.Scode " +
					"	AND U.Unum = " + Unum + " " +
					"	AND S.Sname = '" + stockName + "' ";
	
			rs = stmt.executeQuery(sql);
			
			if(rs.next()) {
				String checkName 		= rs.getString(1);
				int checkSum			= rs.getInt(2);
				
				if(amount > checkSum) {
					System.out.println("보유 수량이 부족합니다.");
					return;
				}
			}
			else {
				System.out.println("보유 수량이 부족합니다.");
				return;
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
			rs = stmt.executeQuery(sql);
			
			if(rs.next()) {
				cash	= rs.getInt(1);
			}

			sql = 	"UPDATE USERS " +
					"SET " +
					"Ucash = Ucash + " + totalPrice + ", " +
					"Ucurrent_total_asset = Ucurrent_total_asset - " + totalPrice + " " + 
					"WHERE Unum = " + Unum;
			
			stmt.executeUpdate(sql);
			
			int listNum = 0;
			sql = 	"SELECT MAX(Tnum) " +
					"FROM TRANSACTION_LIST ";
			rs = stmt.executeQuery(sql);
			
			if(rs.next()) {
				listNum = rs.getInt(1) + 1;
			}
			
			sql = 	"INSERT INTO TRANSACTION_LIST VALUES ( " + listNum + ", SYSDATE, '" + stockName + "', '매도', " + price +", " + amount + " )";
			stmt.addBatch(sql);
			sql =	"INSERT INTO HISTORY VALUES ( " + Unum + ", " + listNum + " )";
			stmt.addBatch(sql);
			
			sql = 	"UPDATE INTEREST " +
					"SET " +
					"Quantity = Quantity - " + amount + " " +
					"WHERE In_unum = " + Unum + " AND In_scode = '" + stockCode + "' ";
			stmt.addBatch(sql);
			
			stmt.executeBatch();
			
			System.out.println("");
			System.out.println("<< result >>");
			System.out.println("주식명	|	주식코드	|	수량");
			System.out.println("---------------------------");
			System.out.println(stockName + "	" + stockCode + "	" + amount + "	매도 완료");
			conn.commit();
			
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void join() {
		
		String joinID;
		do {
			System.out.print("ID (필수, 종료: 0) : ");
	        joinID = scanner.nextLine();
	        
	        if(joinID.equals("0"))
	        	return;
	        
	        try {			
	        	ResultSet rs = null;
				
				String sql = "";
				sql = 	"SELECT User_id " +
						"FROM USERS " +
						"WHERE User_id = '"+ joinID +"' ";
				rs = stmt.executeQuery(sql);
				if(rs.next()) {
					System.out.println("이미 존재하는 아이디입니다.");
				}
				else if(joinID.length() < 4) {
					System.out.println("아이디는 4글자 이상이여야 합니다.");
				}
				else {
					break;
				}
				rs.close();
				
				System.out.println();
				
			} catch (SQLException e) {
				e.printStackTrace();
			}
		} while(true);
        
        System.out.print("Password (필수) : ");
        String joinPW = scanner.nextLine();
        
        int newUnum = 0;
        // Unum 생성, 가장 마지막 Unum + 1
        try {			
        	ResultSet rs = null;
			
			String sql = "";
			sql = 	"SELECT MAX(Unum) " +
					"FROM USERS ";
			rs = stmt.executeQuery(sql);
			
			if(rs.next()) {
				newUnum = rs.getInt(1) + 1;
			}
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
                
        System.out.print("나이 (선택) : ");
        String age = scanner.nextLine();
        int intAge = 0;
        if(!age.equals("")) {
        	intAge = Integer.parseInt(age);
        }
        
        System.out.print("성별 (선택) : ");
        String sex = scanner.nextLine();
        
        System.out.print("이메일 (선택) : ");
        String email = scanner.nextLine();
        
        System.out.print("휴대폰 번호 (선택 010-xxxx-xxxx) : ");
        String phone = scanner.nextLine();
        
 
   		try {			
    			
   			String sql = "";
   			sql = 	"INSERT INTO USERS VALUES ('" + joinID + "', '" + joinPW +"', " + newUnum + 
   												", 0, 0, " + intAge + ", '" + sex + "', '" + email + "', '" + phone + "') ";
   			int rs = stmt.executeUpdate(sql);
   			System.out.println("회원 가입 완료");
    			
   			System.out.println();
    			
   			conn.commit();
    			
   		} catch (SQLException e) {
   			e.printStackTrace();
   		}

	}
	
	public void inAdmin() {

		
		System.out.print("ADMIN ID : ");
		String adminID = scanner.nextLine();
		System.out.print("ADMIN PW : ");
		String adminPW = scanner.nextLine();
		
		if( adminID.equals(ADMIN_ID) && adminPW.equals(ADMIN_PW)) {
			System.out.println("관리자 로그인 완료");
		}
		else {
			System.out.println("관리자 로그인 실패");
			return;
		}
		
		
		while(true) {			
			
			int inputNumber = 0;
			
			start.displayAdminMenu();
			inputNumber = start.selectMenu(2);
			
			switch (inputNumber) {
	
	        case 1:
	             start.userManage();
	            break;
	        case 2:
	            start.dataManage();
	            break;
	        case 0:
	           return;
	
	        default:
	            System.out.println("다시 선택하세요!");
			}
		}
	}
	
	public void displayAdminMenu() {

        System.out.println("");
        System.out.println("..............................");
        System.out.println("관리자 메뉴");
        System.out.println("..............................");
        System.out.println(" 1. 회원 관리");
        System.out.println(" 2. 데이터 관리");
        System.out.println("..............................");
        System.out.println(" 0. 이전 메뉴");
        System.out.println("..............................");
    }
	
	public void userManage() {
		
		while(true) {
			
			int inputNumber = 0;
			
			start.displayUserManageMenu();
			inputNumber = start.selectMenu(4);
			
			switch (inputNumber) {
	
	        case 1:
	             start.lookUserInfoID();
	            break;
	        case 2:
	            start.lookUserInfoUnum();
	            break;
	        case 3:
	        	start.deleteUserID();
	        	break;
	        case 4:
	        	start.deleteUserUnum();
	        case 0:
	           return;
	
	        default:
	            System.out.println("다시 선택하세요!");
			}
		}
	}
	
	public void displayUserManageMenu() {

        System.out.println("");
        System.out.println("..............................");
        System.out.println("회원 관리 메뉴");
        System.out.println("..............................");
        System.out.println(" 1. 회원 조회(ID)");
        System.out.println(" 2. 회원 조회(유저 번호)");
        System.out.println(" 3. 회원 삭제(ID)");
        System.out.println(" 4. 회원 삭제(유저 번호)");
        System.out.println("..............................");
        System.out.println(" 0. 이전 메뉴");
        System.out.println("..............................");
    }
	
	
	public void lookUserInfoID() {
		
		System.out.print("회원 ID : ");
        String input = scanner.nextLine();
        
		ResultSet rs = null;
		
		try {			
			
			String sql = "";
			sql = 	"SELECT * " +
					"FROM USERS " +
					"WHERE User_id = '" + input + "'";

			System.out.println("");
			System.out.println("<< result >>");
			System.out.println("ID	|	PW	|	회원 번호	|	보유 주식	|	보유 자산	|	나이	|	성별	|	이메일	|	휴대폰");
			System.out.println("---------------------------");
			
			rs = stmt.executeQuery(sql);
			if(rs.next()) {
				String ID 		= rs.getString(1);
				String PW		= rs.getString(2);
				int	Unum 		= rs.getInt(3);
				int total_asset		= rs.getInt(4);
				int cash		= rs.getInt(5);
				int age			= rs.getInt(6);
				String sex		= rs.getString(7);
				String email	= rs.getString(8);
				String phone	= rs.getString(9);
				
    			System.out.println(ID +  "	|	" + PW + "	|	" + Unum + "	|	" + total_asset + "	|	" +
    								cash + "	|	" + age + "	|	" + sex + "	|	" + email + "	|	" + phone);
			}
			else {
				System.out.println("없는 회원 ID 입니다.");
			}
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void lookUserInfoUnum() {
		System.out.print("회원 번호 : ");
        int input = scanner.nextInt();
        
		ResultSet rs = null;
		
		try {			
			
			String sql = "";
			sql = 	"SELECT * " +
					"FROM USERS " +
					"WHERE Unum = " + input;

			System.out.println("");
			System.out.println("<< result >>");
			System.out.println("ID	|	PW	|	회원 번호	|	보유 주식	|	보유 자산	|	나이	|	성별	|	이메일	|	휴대폰");
			System.out.println("---------------------------");
			
			rs = stmt.executeQuery(sql);
			if(rs.next()) {
				String ID 		= rs.getString(1);
				String PW		= rs.getString(2);
				int	Unum 		= rs.getInt(3);
				int total_asset		= rs.getInt(4);
				int cash		= rs.getInt(5);
				int age			= rs.getInt(6);
				String sex		= rs.getString(7);
				String email	= rs.getString(8);
				String phone	= rs.getString(9);
				
    			System.out.println(ID +  "	|	" + PW + "	|	" + Unum + "	|	" + total_asset + "	|	" +
    								cash + "	|	" + age + "	|	" + sex + "	|	" + email + "	|	" + phone);
			}
			else {
				System.out.println("없는 회원 번호입니다.");
			}
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void deleteUserID() {
		System.out.print("회원 ID : ");
        String input = scanner.nextLine();
        
		ResultSet rs = null;
		
		try {			
			
			String sql = "";
			sql = 	"SELECT * " +
					"FROM USERS " +
					"WHERE User_id = '" + input + "'";
	
			rs = stmt.executeQuery(sql);
			if(rs.next()) {
				
				sql = 	"DELETE FROM USERS " +
						"WHERE User_id = '" + input + "'";
		
				stmt.executeUpdate(sql);
				
				System.out.print(input + " 삭제 완료 ");
				conn.commit();
			}
			else {
				System.out.println("없는 회원 번호입니다.");
			}
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void deleteUserUnum() {
		System.out.print("회원 번호 : ");
        int input = scanner.nextInt();
        
		ResultSet rs = null;
		
		try {			
			
			String sql = "";
			sql = 	"SELECT * " +
					"FROM USERS " +
					"WHERE Unum = " + input;
	
			rs = stmt.executeQuery(sql);
			if(rs.next()) {
				
				sql = 	"DELETE FROM USERS " +
						"WHERE Unum = " + input;
		
				stmt.executeUpdate(sql);
				
				System.out.print(input + " 삭제 완료 ");
				conn.commit();
			}
			else {
				System.out.println("없는 회원 번호입니다.");
			}
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	
	public void dataManage() {
		
		while(true) {
			
			int inputNumber = 0;
			
			start.displayDataManageMenu();
			inputNumber = start.selectMenu(4);
			
			switch (inputNumber) {
	
	        case 1:
	             start.stockHoldingStat();
	            break;
	        case 2:
	            start.ageHoldingStat();
	            break;
	        case 3:
	        	start.userHoldingStat();
	        	break;
	        case 4:
	        	start.rankingStat();
	        	break;
	        case 0:
	           return;
	
	        default:
	            System.out.println("다시 선택하세요!");
			}
		}
	}
	
	public void displayDataManageMenu() {

        System.out.println("");
        System.out.println("..............................");
        System.out.println("데이터 관리 메뉴");
        System.out.println("..............................");
        System.out.println(" 1. 주식 소유자 통계");
        System.out.println(" 2. 나이대별 주식 보유량");
        System.out.println(" 3. 유저별 주식 보유량");
        System.out.println(" 4. 주식 랭킹");
        System.out.println("..............................");
        System.out.println(" 0. 이전 메뉴");
        System.out.println("..............................");
    }
	
	public void stockHoldingStat() {
		System.out.print("주식명 : ");
        String input = scanner.nextLine();
        
		ResultSet rs = null;
		
		try {			
			
			String sql = "";
			sql = 	"SELECT  I.In_scode, COUNT(U.Unum) as NumUser " +
					"FROM USERS U, STOCK S, INTEREST I " +
					"WHERE I.In_unum = U.Unum " + 
					"	AND I.In_scode = S.Scode " +
					" 	AND I.Quantity > 0 " +
					"	AND S.Sname LIKE '" + input + "%' " +
					"GROUP BY I.In_scode ";

			System.out.println("");
			System.out.println("<< result >>");
			System.out.println("주식코드	|	총계");
			System.out.println("---------------------------");
			
			rs = stmt.executeQuery(sql);
			if(rs.next()) {
				String code 		= rs.getString(1);
				int	sum		= rs.getInt(2);
				
    			System.out.println(code +  "	|	" + sum );
			}
			else {
				System.out.println("데이터가 없습니다.");
			}
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void ageHoldingStat() {
		System.out.print("주식명 : ");
        String input = scanner.nextLine();
        
		ResultSet rs = null;
		
		try {			
			
			String sql = "";
			sql = 	"SELECT U.Uage, SUM(I.Quantity) " +
					"FROM USERS U, INTEREST I, STOCK S " +
					"WHERE I.In_unum = U.Unum " + 
					"	AND I.In_scode = S.Scode " +
					"	AND S.Sname = '" + input + "' " +
					"GROUP BY Uage ";

			System.out.println("");
			System.out.println("<< result >>");
			System.out.println("나이	|	총계");
			System.out.println("---------------------------");
			
			rs = stmt.executeQuery(sql);
			if(rs.next()) {
				int age 		= rs.getInt(1);
				int	sum		= rs.getInt(2);
				
    			System.out.println(age +  "	|	" + sum );
			}
			else {
				System.out.println("데이터가 없습니다.");
			}
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void userHoldingStat() {
		System.out.print("유저 번호 : ");
        int input = scanner.nextInt();
        
		ResultSet rs = null;
		
		try {			
			
			String sql = "";
			sql = 	"SELECT DISTINCT Sname, U.Unum, I.Quantity " +
					"FROM USERS U, INTEREST I, STOCK S " +
					"WHERE U.Unum = I.In_unum  " + 
					"	AND I.In_Scode = S.Scode " +
					"	AND U.Unum = " + input;

			System.out.println("");
			System.out.println("<< result >>");
			System.out.println("주식	|	유저 번호 |	총계");
			System.out.println("---------------------------");
			
			rs = stmt.executeQuery(sql);
			if(rs.next()) {
				String Sname 		= rs.getString(1);
				int	Unum		= rs.getInt(2);
				int sum		= rs.getInt(3);
				
    			System.out.println(Sname +  "	|	" + Unum +  "	|	" + sum);
			}
			else {
				System.out.println("데이터가 없습니다.");
			}
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
	
	public void rankingStat() {
		
		System.out.print("랭킹 입력 : ");
        int input = scanner.nextInt();
        
		ResultSet rs = null;
		
		try {			
			
			String sql = "";
			sql = 	"SELECT ROWNUM, U.User_id, U.Uage " +
					"FROM USERS U, RANKING R, RANKING RK " +
					"WHERE U.User_id = R.Ruser_id  " + 
					"	AND R.Ruser_id = RK.Ruser_id " +
					"	AND R.Rank < " + input;

			System.out.println("");
			System.out.println("<< result >>");
			System.out.println("랭킹	|	유저 ID |	나이");
			System.out.println("---------------------------");
			
			rs = stmt.executeQuery(sql);
			while(rs.next()) {
				int rank 		= rs.getInt(1);
				String ID		= rs.getString(2);
				int age		= rs.getInt(3);
				
    			System.out.println(rank +  "	|	" + ID +  "	|	" + age);
			}
			rs.close();
			
			System.out.println();
			
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}
}

