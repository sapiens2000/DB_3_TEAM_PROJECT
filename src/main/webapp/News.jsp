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
<title>News</title>
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

<%
	// No Login Session
	if(session.getAttribute("uNum") == null){ 
		out.println("<script>alert('로그인이 필요합니다.');</script>");
		out.println("<script>location.href='main.jsp';</script>");	
	}
%>
	<jsp:include page="NavBar/navbar-login.jsp"/>
	<h2>News</h2>
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
	String query;
	ResultSetMetaData rsmd;
	int cnt;
%>
<form method="post" action="News.jsp">
Stock name : <input type="text" name="Find_URL_Q1"><br>
<input type="submit" name="Submit" value="Summit"><br></br><br></br><br></br>
<%	
	if(Find_URL_Q1 != null){
	query = 
	"SELECT N.Nurl, N.Ncompany\n"
	+ "FROM NEWS N\n"
	+ "WHERE N.Ncompany LIKE " + "\'%" + Find_URL_Q1 + "%\'" + "\n";
	
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
			out.println("</tr>");
		}
		out.println("</table>");
		rs.close();
		pstmt.close();
	}
%>
</form>


</body>
</html>