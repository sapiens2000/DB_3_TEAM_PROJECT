<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
	<title>User Management</title>
	<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
    <link href="resource/css/styles.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
</head>
<script type="text/javaScript">
	function deleteUser() {
	    let table = document.getElementById('datatablesSimple');
	
	    for (let i = 1; i < table.rows.length; i++) {
	    	table.rows[i].cells[2].onclick = function () {
	        	var userId = table.rows[i].cells[1].innerText;
	        	var result = confirm(userId + " 을/를 정말 삭제할까요?");

		        if(result){
		        	location.href = "deleteUser.jsp?userId="+userId;
		        }
	    	}
	    }
	} 
	
	function updateUser() {
	    let table = document.getElementById('datatablesSimple');
	
	    for (let i = 1; i < table.rows.length; i++) {
	    	table.rows[i].cells[2].onclick = function () {
	        	var userId = table.rows[i].cells[1].innerText;
	        	var result = confirm(userId + " 을/를 수정할까요?");
	        	
		        if(result){
		        	location.href = "updateUser.jsp?userId="+userId;
		        }
	    	}
	    }
	} 
</script>

<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container px-5">
<<<<<<< HEAD
            <a class="navbar-brand" href="#!">주식박사</a>
=======
            <a class="navbar-brand" href="#!">STOCK</a>
>>>>>>> main
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
					<li class="nav-item"><a class="nav-link active" aria-current="page" href="main.jsp">홈</a></li>
<<<<<<< HEAD
				    <li class="nav-item"><a class="nav-link" href="stock.jsp">주식</a></li>
				    <li class="nav-item"><a class="nav-link" href="ranking.jsp">랭킹</a></li>
=======
				    <li class="nav-item"><a class="nav-link" href="#">주식</a></li>
				    <li class="nav-item"><a class="nav-link" href="#">뉴스</a></li>	
				    <li class="nav-item"><a class="nav-link" href="ranking.jsp">랭킹</a></li>
					<li class="nav-item"><a class="nav-link" href="logout.jsp">로그아웃</a></li>
>>>>>>> main
					<li class="nav-item dropdown">
			        	<a class="nav-link dropdown-toggle" href="#" id="navbarDarkDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">
			            관리자 메뉴
			          	</a>
			          	<ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDarkDropdownMenuLink">
			            	<li><a class="dropdown-item" href="userManagement.jsp">회원관리</a></li>
			            	<li><a class="dropdown-item" href="dataManagement.jsp">데이터관리</a></li>
			            	<li><a class="dropdown-item" href="statistic.jsp">통계</a></li>
<<<<<<< HEAD
			            	<li><hr class="dropdown-divider" /></li>
                        	<li><a class="dropdown-item" href="logout.jsp">로그아웃</a></li>
=======
>>>>>>> main
			          	</ul>
			        </li>
                </ul>
            </div>
        </div>
    </nav> 

	<div class="container-fluid px-4">
        <h2 class="mt-4"> User Management</h2>
        <div class="card mb-4">
            <div class="card-body">
            	Search, Delete, Update Users.
            </div>
        </div>
        <div class="card mb-4">
            <div class="card-header">
                <i class="fas fa-table me-1"></i>
                USERS
            </div>
            <div class="card-body">
                <table id="datatablesSimple">
                    <thead>
                        <tr style="text-align: center;">
                            <th># USER NUM</th>
                            <th># USER ID</th>
                            <th width="150">버튼</th>
                        </tr>
                    </thead>                                 
                    <tbody>         
<% 
	Oracle orcl = Oracle.getInstance();
	ResultSet rs = orcl.getUsers();

	while(rs.next()){
		
		int unum = rs.getInt(1);
		String userId = rs.getString(2);
		
				out.println("<tr>");
				out.println("<td>" + unum + "</td>");	
				out.println("<td>" + userId + "</td>");
				out.println("<td><button class='btn btn-danger pull-right' onclick='deleteUser()'>삭제</button> / " +
							"<button class='btn btn-secondary pull-right' onclick='updateUser()'>수정</button></td>");
				out.println("</tr>");
	}
%>		                                 
                    </tbody>
                </table>
            </div>
        </div>
    </div>
<<<<<<< HEAD
	
=======
    <!-- Footer-->
    <footer class="py-5 bg-dark">
        <div class="container px-5"><p class="m-0 text-center text-white">Copyright &copy; TEAM 3</p></div>
    </footer>
>>>>>>> main
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="resource/js/scripts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest" crossorigin="anonymous"></script>
    <script src="resource/js/datatables-simple-demo.js"></script>
</body>
</html>