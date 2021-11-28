<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.FileWriter" %>
<%@ page import="java.io.IOException" %>
<%@ page import="phase4.Oracle" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="org.json.simple.JSONArray"%>
<!DOCTYPE>
<html>
<head>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="https://code.highcharts.com/stock/highstock.js"></script>
	<script src="https://code.highcharts.com/stock/modules/exporting.js"></script>	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>STOCK CHART</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/simple-datatables@latest/dist/style.css" rel="stylesheet" />
	<link href="resource/css/styles.css" rel="stylesheet" />
	<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>


	<!--  fonts  -->
    <link href="resource/css/styles.css" rel="stylesheet" />

</head>

<body>
<%	
	// No login
	if(session.getAttribute("uNum") == null){%>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container px-5">
            <a class="navbar-brand" href="#">주식박사</a>
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

<%
	Oracle orcl = Oracle.getInstance();
	ResultSet rs;
	String company = request.getParameter("sname");
	String data = orcl.stockChart(company);

%>	
	<div id="container" style="height: 400px; min-width: 310px"></div>
		<script>	
			function draw(){
				var jsondata = <%=data%>;
				var chartdata = [];
				
				jsondata.forEach(function(item) {
					chartdata.push([item.date, item.open, item.high, item.low, item.close]);
              	});
				
				
				Highcharts.stockChart('container',{
					title: {
						text: '<%=company%>'
					},
					rangeSelector: {
						buttons: [
							{type: 'day',count: 1,text: 'Day'}, 
							{type: 'all',count: 1,text: 'All'}
						],
						selected: 2,
						inputEnabled: true
					},
					plotOptions: {
						candlestick: {
							downColor: 'blue',
							upColor: 'red'
						},
						series: {
							cropThreshold: 3000
						}
					},
					series: [{
						name: '<%=company%>',
						type: 'candlestick',
						data: chartdata,
						tooltip: {
							valueDecimals: 5
						}
					}]
				});
			}				
			draw();
		</script>
	<div class="container" >
 		<div class="row">
    		<div class="col">
				<table class="table table-striped" >			
					<thead>
						<tr>
							<th scope="col">NEWS</th>
					  	</tr>
					</thead>
					<tbody>
<% 
	rs = orcl.getNewsInChart((company));
	
	if(rs.next()){
		int i = 1;
		while(rs.next() && i <= 8){
			
			String title = "    <td><a href=\"" + rs.getString(2) +"\" style=\"color:black\">" + rs.getString(1) + "</a></td>";
			
			out.println("<tr>");
			out.println(title);
			out.println("</tr>");
			
			i++;
		}
	}
%>	
					</tbody>
				</table>
    		</div>
    		<div class="col">
     			<nav>
					<div class="nav nav-tabs" id="nav-tab" role="tablist">
				    	<button class="nav-link active" id="nav-home-tab" data-bs-toggle="tab" data-bs-target="#nav-home" type="button" role="tab" aria-controls="nav-home" aria-selected="true">매수</button>
				    	<button class="nav-link" id="nav-profile-tab" data-bs-toggle="tab" data-bs-target="#nav-profile" type="button" role="tab" aria-controls="nav-profile" aria-selected="false">매도</button>
				  	</div>
				</nav>
				<div class="tab-content" id="nav-tabContent">
					<div class="tab-pane fade show active" id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab">매수 페이지</div>
					<div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">매도 페이지</div>
				</div>
    		</div>
    		<div class="col">
<% 
	rs = orcl.getAllDataForChart(company);

	String high = "";
	String low = "";
	String change = "";
	String start = "";
	String end = "";
	String cap = "";
	String market = "";
	String sector = "";
	String foreign = "";
	String per = "";
	String pbr = "";
	String roe = "";
	if(rs.next()){
		
		high = "    <td>" + rs.getInt(1) + "</td>";
		low = "    <td>" + rs.getInt(2) + "</td>";
		change = "";
		if(rs.getFloat(3) > 0){
			change = "    <td><span style=\"color:red\">" + rs.getFloat(3) + "%</span></td>";
		}
		else if(rs.getFloat(3) < 0){
			change = "    <td><span style=\"color:blue\">" + rs.getFloat(3) + "%</span></td>";
		}
		else{
			change = "    <td>" + rs.getFloat(3) + "%</td>";
		}
		start = "    <td>" + rs.getInt(4) + "</td>";
		end = "    <td>" + rs.getInt(5) + "</td>";
		cap = "    <td>" + rs.getInt(6) + "</td>";
		market = "";
		if(rs.getInt(7) == 1){
			market = "    <td>" + "코스피" + "</td>";
		}
		else{
			change = "    <td>" + "코스닥" + "</td>";
		}
		sector = "    <td>" + rs.getString(8) + "</td>";
		foreign = "    <td>" + rs.getFloat(9) + "%</td>";
		per = "    <td>" + rs.getFloat(10) + "</td>";
		pbr = "    <td>" + rs.getFloat(11) + "</td>";
		roe = "    <td>" + rs.getFloat(12) + "</td>";
	}
%>
     				<div class="row">
	     				<table class="table table-striped" >			
							<thead>
								<tr>
									<th scope="col">고가</th>
									<th scope="col">저가</th>
									<th scope="col">변동률</th>
							  	</tr>
							</thead>
							<tbody>
							<%
							out.println("<tr>");
							out.println(high);
							out.println(low);
							out.println(change);
							out.println("</tr>");
							%>	
							</tbody>
						</table>
     				</div>
     				<div class="row">
     					<table class="table table-striped" >			
							<thead>
								<tr>
									<th scope="col">시작가</th>
									<th scope="col">마감가</th>
									<th scope="col">시가총액</th>
							  	</tr>
							</thead>
							<tbody>
							<%
							out.println("<tr>");
							out.println(start);
							out.println(end);
							out.println(cap);
							out.println("</tr>");
							%>	
							</tbody>
						</table>
     				</div>
     				<div class="row">
     					<table class="table table-striped" >			
							<thead>
								<tr>
									<th scope="col">시장</th>
									<th scope="col">업종</th>
									<th scope="col">외국인보유</th>
							  	</tr>
							</thead>
							<tbody>
							<%
							out.println("<tr>");
							out.println(market);
							out.println(sector);
							out.println(foreign);
							out.println("</tr>");
							%>	
							</tbody>
						</table>
     				</div>
     				<div class="row">
     					<table class="table table-striped" >			
							<thead>
								<tr>
									<th scope="col">PER</th>
									<th scope="col">PBR</th>
									<th scope="col">ROE</th>
							  	</tr>
							</thead>
							<tbody>
							<%
							out.println("<tr>");
							out.println(per);
							out.println(pbr);
							out.println(roe);
							out.println("</tr>");
							%>	
							</tbody>
						</table>
     				</div>
     			</div>
    		</div>
		</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" ></script>
    <script src="resource/js/scripts.js"></script>
</body>
</html>
