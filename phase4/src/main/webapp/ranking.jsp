<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="java.sql.ResultSet" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Ranking</title>
</head>
<body>
<%	
	// No login
	if(session.getAttribute("uNum") == null){%>
		<jsp:include page="NavBar/navbar.jsp"/>
<%
	} else{ 
%>
		<jsp:include page="NavBar/navbar-login.jsp"/>
<% 
	} 
%>	
	<table class="table table-striped table-hover" >			
		<thead>
			<tr>
		    	<th scope="col">RANK</th>
		    	<th scope="col">USER ID</th>
		    	<th scope="col">TOTAL ASSET</th>
		  	</tr>
		</thead>
		<tbody>
<% 
	Oracle orcl = Oracle.getInstance();
	ResultSet rs = orcl.getRanking();

	while(rs.next()){
		
		String row = "    <th scope='row'>" + rs.getInt(1) + "</th>";
		String userId = "    <td>" + rs.getString(2) + "</td>";
		String total_asset = "    <td>" + rs.getInt(3) + "</td>";
		
		out.println("<tr>");
		out.println(row);	
		out.println(userId);
		out.println(total_asset);
		out.println("</tr>");
	}
%>	

		</tbody>
	
		
	</table>
</body>
</html>