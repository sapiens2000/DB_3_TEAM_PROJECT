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
			                    </tr>
			                </thead>		           
			                <tbody>
<% 
	Oracle orcl = Oracle.getInstance();
	ResultSet rs = orcl.getChangeRate();
	
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
	
		out.println("<tr onClick='goToChart()'>");
		out.println("<td>" + sname + "</td>");
		out.println(change);
		out.println("<td>" + start + "</td>");
		out.println("<td>" + close + "</td>");
		out.println("<td>" + high + "</td>");
		out.println("<td>" + low + "</td>");
		out.println("</tr>");
	}
%>			                
			                </tbody>
			            </table>
			        </div>			    		   			 			    
			    </div>
				<div class="card mb-4">
			       <div class="card-header">
			           <i class="fas fa-table me-1"></i>
			           SECTOR
			        </div>			
					<div class="card-body">
			            <table id="datatablesSimple1">
			                <thead>
			                    <tr>
							    	<th scope="col">SECTOR</th>
							    	<th scope="col">NUM OF STOCKS</th>
			                    </tr>
			                </thead>		           
			                <tbody>
<% 
	orcl = Oracle.getInstance();
	rs = orcl.getSector();
	
	while(rs.next()){
				
		String sector_name = rs.getString(1);				
		int numOfStock = rs.getInt(2);	
		out.println("<tr onClick='goToSector()'>");
		out.println("<td>" + sector_name + "</td>");
		out.println("<td>" + numOfStock + "</td>");
		out.println("</tr>");
	}
%>			                
			                </tbody>
			            </table>
			        </div>
				</div>
				<h2 class="mt-4">SEARCH STOCK</h2>
				<div class="card mb-4" >
			       <div class="card-body" >
			       	CHOOSE OPTIONS
			       </div>
				</div>
				<form method="post" action="searchedStock.jsp">	
					<input type="text" class="form-control" id=minPrice name="minPrice" placeholder="최소 금액" style="width: 200px; float: left">
					<input type="text" class="form-control" id=maxPrice name="maxPrice" placeholder="최대 금액" style="width: 200px; float: left"><br></br>
					<input type="text" class="form-control" id=marketCap name="marketCap" placeholder="시가총액(단위: 만)" style="width: 200px; float: left">
					<div class="form-group" style="text-align: center; float: left; margin-left: 40px;">
						<div class="btn-group" role="group" aria-label="Basic radio toggle button group">
						  <input type="radio" class="btn-check" name="btnradio1" id="marketCapUp" value="true" autocomplete="off" checked>
						  <label class="btn btn-outline-primary" for="marketCapUp">이상</label>			
						  <input type="radio" class="btn-check" name="btnradio1" id="marketCapDown" value="false" autocomplete="off">
						  <label class="btn btn-outline-primary" for="marketCapDown">이하</label>
						</div>
					</div>
					<br></br>
					<input type="text" class="form-control" id=foreign_rate name="foreign_rate" placeholder="외국인 비율" style="width: 200px; float: left">
					<div class="form-group" style="text-align: center; float: left; margin-left: 40px;">
						<div class="btn-group" role="group" aria-label="Basic radio toggle button group">
						  <input type="radio" class="btn-check" name="btnradio2" id="foreignUp" value="true" autocomplete="off" checked>
						  <label class="btn btn-outline-primary" for="foreignUp">이상</label>			
						  <input type="radio" class="btn-check" name="btnradio2" id="foreignDown" value="false" autocomplete="off">
						  <label class="btn btn-outline-primary" for="foreignDown">이하</label>
						</div>
					</div>
					<br></br>
					<input type="text" class="form-control" id=per name="per" placeholder="PER" style="width: 200px; float: left">
					<div class="form-group" style="text-align: center; float: left; margin-left: 40px;">
						<div class="btn-group" role="group" aria-label="Basic radio toggle button group">
						  <input type="radio" class="btn-check" name="btnradio3" id="perUp" value="true" autocomplete="off" checked>
						  <label class="btn btn-outline-primary" for="perUp">이상</label>			
						  <input type="radio" class="btn-check" name="btnradio3" id="perDown" value="false" autocomplete="off">
						  <label class="btn btn-outline-primary" for="perDown">이하</label>
						</div>
					</div>
					<br></br>
					<input type="text" class="form-control" id=pbr name="pbr" placeholder="PBR" style="width: 200px; float: left">
					<div class="form-group" style="text-align: center; float: left; margin-left: 40px;">
						<div class="btn-group" role="group" aria-label="Basic radio toggle button group">
						  <input type="radio" class="btn-check" name="btnradio4" id="pbrUp" value="true" autocomplete="off" checked>
						  <label class="btn btn-outline-primary" for="pbrUp">이상</label>			
						  <input type="radio" class="btn-check" name="btnradio4" id="pbrDown" value="false"autocomplete="off">
						  <label class="btn btn-outline-primary" for="pbrDown">이하</label>
						</div>
					</div>
					<br></br>
					<input type="text" class="form-control" id=roe name="roe" placeholder="ROE" style="width: 200px; float: left">
					<div class="form-group" style="text-align: center; float: left; margin-left: 40px;">
						<div class="btn-group" role="group" aria-label="Basic radio toggle button group">
						  <input type="radio" class="btn-check" name="btnradio5" id="roeUp" value="true" autocomplete="off" checked>
						  <label class="btn btn-outline-primary" for="roeUp">이상</label>			
						  <input type="radio" class="btn-check" name="btnradio5" id="roeDown" value="false" autocomplete="off">
						  <label class="btn btn-outline-primary" for="roeDown">이하</label>
						</div>
					</div>
					<br></br>
					<input type="reset" class="btn btn-primary" name="Reset" value="Reset">
					<input type="submit" class="btn btn-primary" name="Submit" value="Summit">
				</form>	    
			</div>
		</main>
	</div>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.10.2/dist/umd/popper.min.js"></script>
    <script src="resource/js/scripts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest"></script>
    <script src="resource/js/datatables-simple-demo.js"></script>
</body>
</html>