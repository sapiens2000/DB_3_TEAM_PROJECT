<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="java.sql.ResultSet" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FOREIGN Rate</title>
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
	<table class="table table-striped" >			
		<thead>
			<tr>
				<th scope="col">N</th>
		    	<th scope="col">STOCK</th>
		    	<th scope="col">FOREIGN RATE</th>
		    	<th scope="col">PER</th>
		    	<th scope="col">ROE</th>
		  	</tr>
		</thead>
		<tbody>
<% 
	Oracle orcl = Oracle.getInstance();
	ResultSet rs = orcl.foreignRatePerRoe();
	
	int i = 1;

	while(rs.next()){
		
		String row = "    <th scope='row'>" + (i++) + "</th>";
		String stock = "    <td>" + rs.getString(1) + "</td>";
		String foreign = "    <td>" + rs.getFloat(2) + "%</td>";
		String per = "    <td>" + rs.getFloat(3) + "</td>";
		String roe = "    <td>" + rs.getFloat(4) + "</td>";
		
		out.println("<tr>");
		out.println(row);	
		out.println(stock);
		out.println(foreign);
		out.println(per);
		out.println(roe);
		out.println("</tr>");
	}
%>	

		</tbody>
	
		
	</table>
</body>
</html></html>