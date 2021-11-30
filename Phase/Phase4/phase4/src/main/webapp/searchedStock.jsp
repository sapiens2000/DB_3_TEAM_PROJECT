<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="phase4.SearchOption" %>
<%@ page import="java.sql.ResultSet" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>SEARCHED STOCKS</title>
	<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
	<link href="resource/css/styles.css" rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
	
	<!-- Google fonts-->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css" />
    <link href="https://fonts.googleapis.com/css?family=Roboto+Slab:400,100,300,700" rel="stylesheet" type="text/css" />

    <link href="resource/css/main-styles.css" rel="stylesheet" />
    <link href="resource/css/team-styles.css" rel="stylesheet" />
	<style>
		.content {
		  display: flex;
		  flex-direction: column;
		  min-height: 100vh;
		}	
	</style>
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
	} else if((int)session.getAttribute("uNum") == -1){ %>
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
	}else{
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
				<h2 class="mt-4">SEARCHED STOCKS</h2>
				<div class="card mb-4">
			       <div class="card-body">
			       Corresponding Stocks with your options
			       </div>
				</div>
			    <h1 class="mt-4"></h1>
			    <div class="card mb-4">
			        <div class="card-header">
			            <i class="fas fa-table me-1"></i>
			            STOCKS
			        </div>
			        <div class="card-body">
			            <table id="datatablesSimple">
			                <thead>
			                    <tr>
			                        <th scope="col">STOCK</th>
							    	<th scope="col">CHANGE RATE</th>
							    	<th scope="col">가격</th>
							    	<th scope="col">시가총액</th>
							    	<th scope="col">외국인비율</th>
							    	<th scope="col">per</th>
							    	<th scope="col">pbr</th>
							    	<th scope="col">roe</th>
			                    </tr>
			                </thead>		           	           
			                <tbody>
<%  
	Oracle orcl = Oracle.getInstance();
	SearchOption option = SearchOption.getOptionInstance();		

	option.setMinPrice(request.getParameter("minPrice").toString());	
	
	option.setMaxPrice(request.getParameter("maxPrice").toString());
	;
	option.setMarketCap(request.getParameter("marketCap").toString());
	
	option.setMarketCapUp(request.getParameter("btnradio1").toString());
	
	option.setForeign(request.getParameter("foreign_rate").toString());
	
	option.setForeignUp(request.getParameter("btnradio2").toString());
	
	option.setPer(request.getParameter("per").toString());
	
	option.setPerUp(request.getParameter("btnradio3").toString());
	
	option.setPbr(request.getParameter("pbr").toString());
	
	option.setPbrUp(request.getParameter("btnradio4").toString());
	
	option.setRoe(request.getParameter("roe").toString());
	
	option.setRoeUp(request.getParameter("btnradio5").toString());
	
	ResultSet rs = orcl.searchStock(option);
	
	
	while(rs.next()){
		
		String sname = rs.getString(1);
		float temp = rs.getFloat(2);
		int close = rs.getInt(3);
		int marketCap = rs.getInt(4);
		float foreign = rs.getFloat(5);
		float per = rs.getFloat(6);
		float pbr = rs.getFloat(7);
		float roe = rs.getFloat(8);
		
		String change = null;
		if(temp > 0){
			change = "<td><span style=\"color:red\">" + temp + "%</span></td>";
		}
		else if(temp < 0){
			change = "<td><span style=\"color:blue\">" + temp + "%</span></td>";
		}
		else{
			change = "<td>" + temp + "%</td>";
		}
		


	
	
		out.println("<tr onClick='goToChart()'>");
		out.println("<td>" + sname + "</td>");
		out.println(change);
		out.println("<td>" + close + "</td>");
		out.println("<td>" + marketCap + "</td>");
		out.println("<td>" + foreign + "</td>");
		out.println("<td>" + per + "</td>");
		out.println("<td>" + pbr + "</td>");
		out.println("<td>" + roe + "</td>");
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
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" ></script>
    <script src="resource/js/scripts.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest"></script>
    <script src="resource/js/datatables-simple-demo.js"></script>
    
</body>
</html>
