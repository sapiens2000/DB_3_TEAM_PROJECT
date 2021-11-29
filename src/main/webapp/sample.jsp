<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="java.sql.ResultSet" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>STOCK</title>
	<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
	<link href="resource/css/styles.css" rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" ></script>
	<link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css" />
	
	<!-- Google fonts-->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css" />
    <link href="https://fonts.googleapis.com/css?family=Roboto+Slab:400,100,300,700" rel="stylesheet" type="text/css" />
    <link href="resource/css/main-styles.css" rel="stylesheet" />
    <!--  fonts  -->
    <link href="resource/css/team-styles.css" rel="stylesheet" />

	<script type="text/Javascript">
	function goToChart() {
	    let table = document.getElementById('datatablesSimple');
	
	    for (let i = 1; i < table.rows.length; i++) {
	    	table.rows[i].onclick = function () {
	        	var sname = table.rows[i].cells[0].innerText;
		        location.href = "chartView.jsp?sname="+sname;
	    	}
	    }
	} 
	
	function goToSector() {
	    let table2 = document.getElementById('datatablesSimple1');
	
	    for (let i = 1; i < table2.rows.length; i++) {
	    	table2.rows[i].onclick = function () {
	        	var sector = table2.rows[i].cells[0].innerText;
		        location.href = "sectorView.jsp?sector="+sector;
	    	}
	    }
	} 
	</script>

</head>
<body>

<%	
	// No login
	if(session.getAttribute("uNum") == null){%>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container px-5">
            <a class="navbar-brand" href="#!">주식박사</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link active" aria-current="page" href="main.jsp">홈</a></li>
                    <li class="nav-item"><a class="nav-link" href="stock.jsp">주식</a></li>
                    <li class="nav-item"><a class="nav-link" href="ranking.jsp">랭킹</a></li>
                    <li class="nav-item"><a class="nav-link" href="login.jsp">로그인</a></li>
                    <li class="nav-item"><a class="nav-link" href="register.jsp">회원가입</a></li>
                </ul>
            </div>
        </div>
    </nav> 
<%
	} 
	// Admin
	else if((int)session.getAttribute("uNum") == -1){ %>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container px-5">
            <a class="navbar-brand" href="#!">주식박사</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
					<li class="nav-item"><a class="nav-link active" aria-current="page" href="main.jsp">홈</a></li>
				    <li class="nav-item"><a class="nav-link" href="stock.jsp">주식</a></li>
				    <li class="nav-item"><a class="nav-link" href="ranking.jsp">랭킹</a></li>
					<li class="nav-item dropdown">
			        	<a class="nav-link dropdown-toggle" href="#" id="navbarDarkDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">
			            관리자 메뉴
			          	</a>
			          	<ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDarkDropdownMenuLink">
			            	<li><a class="dropdown-item" href="userManagement.jsp">회원관리</a></li>
			            	<li><a class="dropdown-item" href="dataManagement.jsp">데이터관리</a></li>
			            	<li><a class="dropdown-item" href="statistic.jsp">통계</a></li>
			            	<li><hr class="dropdown-divider" /></li>
                        	<li><a class="dropdown-item" href="logout.jsp">로그아웃</a></li>
			          	</ul>
			        </li>
                </ul>
            </div>
        </div>
    </nav>		
<%
	} else{ 
%>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container px-5">
            <a class="navbar-brand" href="#!">주식박사</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
                    <li class="nav-item"><a class="nav-link active" aria-current="page" href="main.jsp">홈</a></li>
                    <li class="nav-item"><a class="nav-link" href="stock.jsp">주식</a></li>
                    <li class="nav-item"><a class="nav-link" href="ranking.jsp">랭킹</a></li>
                </ul>
                <ul class="navbar-nav ms-auto ms-md-0 me-3 me-lg-4">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" id="navbarDropdown" href="#" role="button" data-bs-toggle="dropdown" aria-expanded="false"><i class="fas fa-user fa-fw"></i>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="navbarDropdown">
                        <li><a class="dropdown-item" href="userSetting.jsp">설정</a></li>
                        <li><a class="dropdown-item" href="history.jsp">거래내역</a></li>
                        <li><a class="dropdown-item" href="curAssets.jsp">보유자산</a></li>
                        <li><hr class="dropdown-divider" /></li>
                        <li><a class="dropdown-item" href="logout.jsp">로그아웃</a></li>
                    </ul>
                </li>
            	</ul>
            </div>
        </div>
    </nav>
<% 
	}
%>	
<form method="post" action="sample.jsp">
<%
	request.setCharacterEncoding("UTF-8");
	String Sname = request.getParameter("Sname");
	String Cstart_date = request.getParameter("Cstart_date");
	String round = request.getParameter("round");
	String Cstart_price = request.getParameter("Cstart_price");
	String Cclose_price = request.getParameter("Cclose_price");
	String Chigh_price = request.getParameter("Chigh_price");
	String Clow_price = request.getParameter("Clow_price");
	String Smarket = request.getParameter("Smarket");
	String Smarket_cap = request.getParameter("Smarket_cap");
	String Sforeign_rate = request.getParameter("Sforeign_rate");
	String Sper = request.getParameter("Sper");
	String Spbr = request.getParameter("Spbr");
	String Sroe = request.getParameter("Sroe");
	String Cscale = request.getParameter("Cscale");
%>

	Sname : <input type="text" id=Sname name="Sname"><br></br>
	Cstart_date : <input type="text" id=Cstart_date name="Cstart_date"><br></br>
	round : <input type="text" id=round name="round"><br></br>
	Cstart_price : <input type="text" id=Cstart_price name="Cstart_price"><br></br>
	Cclose_price : <input type="text" id=Cclose_price name="Cclose_price"><br></br>
	Chigh_price : <input type="text" id=Chigh_price name="Chigh_price"><br></br>
	Clow_price : <input type="text" id=Clow_price name="Clow_price"><br></br>
	Smarket : <input type="text" id=Smarket name="Smarket"><br></br>
	Smarket_cap : <input type="text" id=Smarket_cap name="Smarket_cap"><br></br>
	Sforeign_rate : <input type="text" id=Sforeign_rate name="Sforeign_rate"><br></br>
	Sper : <input type="text" id=Sper name="Sper"><br></br>
	Spbr : <input type="text" id=Spbr name="Spbr"><br></br>
	Sroe : <input type="text" id=Sroe name="Sroe"><br></br>
	Cscale : <input type="text" id=Cscale name="Cscale"><br></br>
	<input type="reset" name="Reset" value="Reset">
	<input type="submit" name="Submit" value="Summit"><br></br><br></br><br></br>

	<div class="content">
		<main>
			<div class="container-fluid px-4">
				<h2 class="mt-4">STOCK</h2>
				<div class="card mb-4">
			       <div class="card-body">
			       	Search stocks. Watch detail on double click.
			       </div>
				</div>
			    <h1 class="mt-4"></h1>
			    <div class="card mb-4">
			        <div class="card-header">
			            <i class="fas fa-table me-1"></i>
			            KOSPI
			        </div>
			        <div class="card-body">
			            <table id="datatablesSimple">
			                <thead>
			                    <tr>
			                        <th scope="col">STOCK</th>
							    	<th scope="col">CHANGE RATE</th>
							    	<th scope="col">시가</th>
							    	<th scope="col">종가</th>
							    	<th scope="col">고가</th>
							    	<th scope="col">저가</th>
							    	<th scope="col">분류</th>
							    	<th scope="col">자산</th>
							    	<th scope="col">외국인비율</th>
							    	<th scope="col">per</th>
							    	<th scope="col">pbr</th>
							    	<th scope="col">roe</th>
							    	<th scope="col">scale</th>
			                    </tr>
			                </thead>		           
			                <tbody>
<% 
	Oracle orcl = Oracle.getInstance();
	ResultSet rs = orcl.searchStock(Sname, round, Cstart_price, Cclose_price, Chigh_price, Clow_price, Smarket, Smarket_cap, Sforeign_rate, Sper, Spbr, Sroe, Cscale);
	if(Sname != null){
		while(rs.next()){
			
			String sname = rs.getString(1);
		
					
			String change = "";
			
			float temp = rs.getFloat(3);
			
			if(temp > 0){
				change = "<td><span style=\"color:red\">" + temp + "%</span></td>";
			}
			else if(temp < 0){
				change = "<td><span style=\"color:blue\">" + temp + "%</span></td>";
			}
			else{
				change = "<td>" + temp + "%</td>";
			}
			
			int start = rs.getInt(4);
			int close = rs.getInt(5);
			int high = rs.getInt(6);
			int low = rs.getInt(7);
			int Smarket_q = rs.getInt(8);
			int Smarket_cap_q = rs.getInt(9);
			int Sforeign_rate_q = rs.getInt(10);
			int Sper_q = rs.getInt(11);
			int Spbr_q = rs.getInt(12);
			int Sroe_q = rs.getInt(13);
			String Cscale_q = rs.getString(14);
		
			out.println("<tr onClick='goToChart()'>");
			out.println("<td>" + sname + "</td>");
			out.println(change);
			out.println("<td>" + start + "</td>");
			out.println("<td>" + close + "</td>");
			out.println("<td>" + high + "</td>");
			out.println("<td>" + low + "</td>");
			out.println("<td>" + Smarket_q + "</td>");
			out.println("<td>" + Smarket_cap_q + "</td>");
			out.println("<td>" + Sforeign_rate_q + "</td>");
			out.println("<td>" + Sper_q + "</td>");
			out.println("<td>" + Spbr_q + "</td>");
			out.println("<td>" + Sroe_q + "</td>");
			out.println("<td>" + Cscale_q + "</td>");
			out.println("</tr>");
		}
	}
%>			                
			                </tbody>
			            </table>
			        </div>			    		   			 			    
			    </div>
			    	    
			</div>
		</main>
	</div>
</form>

    <footer class="py-5 bg-dark">
        <div class="container px-5"><p class="m-0 text-center text-white">Copyright &copy; TEAM 3</p></div>
    </footer>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
</body>
</html>