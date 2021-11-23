<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page language="java" import="java.text.*, java.sql.*" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<title>My page</title>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
$(function(){
	$( "#dp1" ).datepicker({
		dateFormat: 'yy-mm-dd',
		changeMonth: true,
		changeYear: true
		});
});

$(function(){
	$( "#dp2" ).datepicker({
		dateFormat: 'yy-mm-dd',
		changeMonth: true,
		changeYear: true
		});
});
</script>
</head>
<body>
<form method="post" action="Trans_history.jsp">
<%
	// No Login Session
	if(session.getAttribute("uNum") == null){ 
		out.println("<script>alert('로그인이 필요합니다.');</script>");
		out.println("<script>location.href='main.jsp';</script>");	
	}
%>
	<jsp:include page="NavBar/navbar-login.jsp"/>
	



<%
	String serverIP = "localhost";
	String strSID = "orcl";
	String portNum = "1521";
	String user = "hr";
	String pass = "hr";
	String url = "jdbc:oracle:thin:@"+serverIP+":"+portNum+":"+strSID;
	Connection conn = null;
	PreparedStatement pstmt;
	ResultSet rs;
	Class.forName("oracle.jdbc.driver.OracleDriver");
	conn = DriverManager.getConnection(url, user, pass);
%>

<%
	request.setCharacterEncoding("UTF-8");
	String Find_URL_Q1 = request.getParameter("Find_URL_Q1");
	String Find_Transaction_start_date_Q2 = request.getParameter("Find_Transaction_start_date_Q2");
	String Find_Transaction_end_date_Q2 = request.getParameter("Find_Transaction_end_date_Q2");
	String Find_Transaction_user_id_Q2 = session.getAttribute("uNum").toString();
	String Find_User_amount_Q3 = request.getParameter("Find_User_amount_Q3");
	String Find_high_fluctuation_start_date_Q4 = request.getParameter("Find_high_fluctuation_start_date_Q4");
	String Find_high_fluctuation_rate_Q4 = request.getParameter("Find_high_fluctuation_rate_Q4");
	
	String query;
	ResultSetMetaData rsmd;
	int cnt;
%>

  <div class="container-fluid">
    <div class="row">
      <div class="col-md-2">
		<div class="user_option">
		    <div class="user_option_title">
		      <h3 class="panel-title">Option</h3>
		    </div>
		    <!-- 사이드바 메뉴목록1 -->
		    <ul class="user_option_op">
		      <li class="list-group-item"><a href="User_info.jsp">User info</a></li>
		      <li class="list-group-item"><a href="Trans_history.jsp">Trans history</a></li>
		      <li class="list-group-item"><a href="Asset.jsp">Asset</a></li>
		      <li class="list-group-item"><a href="Asset_of_stock.jsp">Asset of stock</a></li>
		    </ul>
		</div>
      </div>
      
      <div class="col-md-1">
      	<div class="user_blank">
      	</div>
      </div>

      <div class="col-md-15">
		<div class="user_result">
		    <div class="user_result_title">
		      <h3 class="panel-title">Result</h3>
		    </div>
		    <!-- 사이드바 메뉴목록1 -->
		start date (yyyy-MM-dd): <input type="text" id="dp1" name="Find_Transaction_start_date_Q2"><br></br>
		end date (yyyy-MM-dd): <input type="text" id="dp2" name="Find_Transaction_end_date_Q2"><br></br>
		<input type="reset" name="Reset" value="Reset">
		<input type="submit" name="Submit" value="Summit"><br></br><br></br><br></br>
		<%
			if(Find_Transaction_start_date_Q2 != null ||
			Find_Transaction_end_date_Q2 != null){
				query =
				"SELECT U.User_id, T.Twhen, T.Tname, T.Type, T.Tvolume\n"
				+ "FROM USERS U, HISTORY H, TRANSACTION_LIST T\n"
				+ "WHERE U.Unum = H.Hunum\n"
					+ "AND H.Htnum = T.Tnum\n"
					+ "AND T.Twhen >= " + "\'" + Find_Transaction_start_date_Q2 + "\'" + "\n"
					+ "AND T.Twhen < " + "\'" + Find_Transaction_end_date_Q2 + "\'" + "\n"
					+ "AND U.Unum = " + Find_Transaction_user_id_Q2 + "\n";
				System.out.println(query + "\n");
				pstmt = conn.prepareStatement(query);
				rs = pstmt.executeQuery();
			
				out.println("<table border=\"1\">");
				rsmd = rs.getMetaData();
				cnt = rsmd.getColumnCount();
				for(int i=1;i <=cnt; i++){
					out.println("<th>"+rsmd.getColumnName(i)+"</th>");
				}
				while(rs.next()){
					out.println("<tr>");
					out.println("<td>"+rs.getString(1)+"</td>");
					out.println("<td>"+rs.getString(2)+"</td>");
					out.println("<td>"+rs.getString(3)+"</td>");
					out.println("<td>"+rs.getString(4)+"</td>");
					out.println("<td>"+rs.getString(5)+"</td>");
					out.println("</tr>");
				}
				out.println("</table>");
				rs.close();
				pstmt.close();
			}
		%>

		</div>
      </div>
     </div>
   </div>





</form>
</body>
</html>