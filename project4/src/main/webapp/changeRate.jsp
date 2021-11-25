<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="java.sql.ResultSet" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Change Rate</title>
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
		    	<th scope="col">DATE</th>
		    	<th scope="col">CHANGE RATE</th>
		    	<th scope="col">START PRICE</th>
		    	<th scope="col">CLOSE PRICE</th>
		    	<th scope="col">HIGH PRICE</th>
		    	<th scope="col">LOW PRICE</th>
		  	</tr>
		</thead>
		<tbody>
<% 
	Oracle orcl = Oracle.getInstance();
	ResultSet rs = orcl.getChangeRate();

	while(rs.next()){
		
		String row = "    <th scope='row'>" + rs.getInt(1) + "</th>";
		
		
		String stock =	"    <td>" + 
						"<form name=\"goToChart\" action=\"chartView.jsp\" method=\"POST\">" + 
						"<input type=\"hidden\" name=\"stockName\" value=\"" + rs.getString(2)  +"\"></form>" + 
						"<a href=\"#\" onclick=\"$(\"#goToChart\").submit();\" style=\"color:black\">" + rs.getString(2) + "</a></td>";
		
		
		
		String date = "    <td>" + rs.getString(3) + "</td>";
		String change = "";
		if(rs.getFloat(4) > 0){
			change = "    <td><span style=\"color:red\">" + rs.getFloat(4) + "%</span></td>";
		}
		else if(rs.getFloat(4) < 0){
			change = "    <td><span style=\"color:blue\">" + rs.getFloat(4) + "%</span></td>";
		}
		else{
			change = "    <td>" + rs.getFloat(4) + "%</td>";
		}
		String start = "    <td>" + rs.getInt(5) + "</td>";
		String close = "    <td>" + rs.getInt(6) + "</td>";
		String high = "    <td>" + rs.getInt(7) + "</td>";
		String low = "    <td>" + rs.getInt(8) + "</td>";
		
		out.println("<tr>");
		out.println(row);	
		out.println(stock);
		out.println(date);
		out.println(change);
		out.println(start);
		out.println(close);
		out.println(high);
		out.println(low);
		out.println("</tr>");
	}
%>	

		</tbody>
	
		
	</table>
</body>
</html>