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
	<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
	<link href="resource/css/styles.css" rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
	<style>
		.content {
		  display: flex;
		  flex-direction: column;
		  justify-content: center;
		  min-height: 100vh;
		}	
	</style>
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
	<div class="content">
		<main>
			<div class="container-fluid px-4">
			    <h1 class="mt-4"></h1>
			    <div class="card mb-4">
			        <div class="card-header">
			            <i class="fas fa-table me-1"></i>
			            RANKING
			        </div>
			        <div class="card-body">
			            <table id="datatablesSimple">
			                <thead>
			                    <tr>
			                        <th>#</th>
			                        <th>ID</th>
			                        <th>TOTAL_ASSET</th>
			                    </tr>
			                </thead>		           
			                <tbody>
<% 
	Oracle orcl = Oracle.getInstance();
	ResultSet rs = orcl.getRanking();

	while(rs.next()){
		
		int row = rs.getInt(1);
		String userId = rs.getString(2);
		int total_asset = rs.getInt(3);
		
				out.println("<tr>");
				out.println("<td>" + row + "</td>");	
				out.println("<td>" + userId + "</td>");
				out.println("<td>" + total_asset + "</td>");
				out.println("</tr>");
	}
%>			                
			                </tbody>
			            </table>
			        </div>
			    </div>
			</div>
		</main>
	</div>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="resource/js/scripts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" crossorigin="anonymous"></script>
    <script src="resource/js/datatables-simple-demo.js"></script>
    
</body>
</html>