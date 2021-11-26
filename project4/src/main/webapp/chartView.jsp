<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="phase4.getChart" %>
<%@ page import="phase4.Oracle" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="https://code.highcharts.com/stock/highstock.js"></script>
<script src="https://code.highcharts.com/stock/modules/exporting.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>STOCK CHART</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
<script type="text/javascript">

var chartdata = [];

$(function () {
	$("#send").click(function() {
	
		console.log("click");
		$.ajax({
			url:"./AjaxPostServlet",
			type:"post",
			datatype:"json",
			data:{company:$("#company").val()},
			
			success:function(json){
				$.each(json, function(i, item){
					chartdata.push([item.date, item.open, item.high, item.low, item.close]);
				});
				draw3();
				console.log("call draw3");
			},
			error:function(){
				alert("error");
			}
		});
	});
});

function draw3(){
	console.log("in draw3");
	Highcharts.stockChart('container',{
		title: {
			text: $("#company").val()
		},
		rangeSelector: {
			buttons: [
				{type: 'hour',count: 1,text: '1h'}, 
				{type: 'day',count: 1,text: '1d'}, 
				{type: 'all',count: 1,text: 'All'}
			],
			selected: 2,
			inputEnabled: true
		},
		plotOptions: {
			candlestick: {
				downColor: 'blue',
				upColor: 'red'
			}
		},
		series: [{
			name: $("#company").val(),
			type: 'candlestick',
			data: chartdata,
			tooltip: {
				valueDecimals: 8
			}
		}]
	});
}

</script>
<script type="text/javascript">

$("#buy_cnt").on("propertychange change keyup paste input", function() {

    // 현재 변경된 데이터 셋팅
    var newValue = $(this).val();

    // 현재 실시간 데이터 표츌
    alert("텍스트 :: " + newValue);

 });
</script>
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

<script type="text/javascript">
var el = document.getElementById('company');
console.log(el);
</script>

<%

	// 나중에 인자 받아오기
	String companyName = "삼성전자";	

	Oracle orcl = Oracle.getInstance();
	ResultSet rs;
	String para = request.getParameter("company");
	System.out.println(para);
%>

	<select id="company">
		<option value="삼성전자" selected>삼성전자</option> 
	</select> 
	<input type="button" id="send" value="검색"><br><br>		
	<div id="container" style="height: 400px; min-width: 310px"></div>
	<div class="container" style="min-width: 1300px">
 		<div class="row">
    		<div class="col" style="min-width: 416px">
				<table class="table table-striped" >			
					<thead>
						<tr>
							<th scope="col">NEWS</th>
					  	</tr>
					</thead>
					<tbody>
<% 
	rs = orcl.getNewsInChart(companyName);
	
	int i = 1;

	while(rs.next() && i <= 8){
		
		String title = "    <td><a href=\"" + rs.getString(2) +"\" style=\"color:black\">" + rs.getString(1) + "</a></td>";
		
		out.println("<tr>");
		out.println(title);
		out.println("</tr>");
		
		i++;
	}
%>	
					</tbody>
				</table>
    		</div>

<% 
	rs = orcl.getAllDataForChart(companyName);

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
	String price_for_cal = "";

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
		
		price_for_cal = rs.getString(1);
	}
%>	
    	
    		<div class="col" style="min-width: 416px">
     			<nav>
					<div class="nav nav-tabs" id="nav-tab" role="tablist">
				    	<button class="nav-link active" style="width:50%; color:red; font-weight:bold;" id="nav-home-tab" data-bs-toggle="tab" data-bs-target="#nav-home" type="button" role="tab" aria-controls="nav-home" aria-selected="true">매수</button>
				    	<button class="nav-link" style="width:50%; color:blue; font-weight:bold;" id="nav-profile-tab" data-bs-toggle="tab" data-bs-target="#nav-profile" type="button" role="tab" aria-controls="nav-profile" aria-selected="false">매도</button>
				  	</div>
				</nav>
				<div class="tab-content" id="nav-tabContent">
				<%
					
					int SQuantity = 0;
					int UCash = 0;
				
					if(session.getAttribute("uNum") != null){
						ResultSet rsForDeal;
						
						rsForDeal = orcl.getHoldingStock(companyName, Integer.parseInt((session.getAttribute("uNum")).toString()));
						
						if(rsForDeal.next()){
							SQuantity = rsForDeal.getInt(2);
						}
						
						rsForDeal = orcl.getHoldingCash(Integer.parseInt((session.getAttribute("uNum")).toString()));
						
						if(rsForDeal.next()){
							UCash = rsForDeal.getInt(1);
						}
					}
				
				%>
					<div class="tab-pane fade show active" id="nav-home" role="tabpanel" aria-labelledby="nav-home-tab">
						<div class="container">
						  <div class="row" style="margin: 25px 0px 15px 0px;">
						  	<div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">보유금액</span>
								<%	
									// No login
									if(session.getAttribute("uNum") == null){%>
										<input type="text" style="text-align:right; background-color:#FFFFFF;" placeholder="0" class="form-control" aria-label="aaaaaaa" aria-describedby="inputGroup-sizing-lg" readonly>
								<%
									} else{ 
								%>
										<input type="text" style="text-align:right; background-color:#FFFFFF;" placeholder="<%out.println(UCash);%>" class="form-control" aria-label="aaaaaaa" aria-describedby="inputGroup-sizing-lg" readonly>
								<% 
									} 
								%>								
							</div>						 
						  </div>
						  <div class="row" style="margin: 15px 0px 15px 0px;">
							<div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">매수가격</span>
							 	<input type="text" style="text-align:right; background-color:#FFFFFF;" id="buy_price" placeholder="<%out.println(price_for_cal);%>" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg" readonly>
							</div>
						  </div>
						  <div class="row" style="margin: 15px 0px 15px 0px;">
						    <div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">주문수량</span>
							 	<input type="text" style="text-align:right;" class="form-control" id="buy_cnt" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg">
							</div>
						  </div>
						  <div class="row" style="margin: 15px 0px 15px 0px;">
						    <div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">주문총액</span>
							 	<input type="text" style="text-align:right; background-color:#FFFFFF;" id="fn_total" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg" readonly>
							</div>
						  </div>
						</div>
						<div class="d-grid gap-2 col-6 mx-auto">
							<%	
								// No login
								if(session.getAttribute("uNum") == null){%>
									<button class="btn btn-primary" type="button" style="text-align:center;" onclick="location.href='login.jsp'">로그인</button>
							<%
								} else{ 
							%>
									<button class="btn btn-danger" type="button" style="text-align:center;" onclick="location.href='login.jsp'">매수</button>
							<% 
								} 
							%>	
						</div>
					</div>
					<div class="tab-pane fade" id="nav-profile" role="tabpanel" aria-labelledby="nav-profile-tab">
						<div class="container">
						  <div class="row" style="margin: 25px 0px 15px 0px;">
						  	<div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">보유수량</span>
							 	<%	
									// No login
									if(session.getAttribute("uNum") == null){%>
										<input type="text" style="text-align:right; background-color:#FFFFFF;" placeholder="0" class="form-control" aria-label="aaaaaaa" aria-describedby="inputGroup-sizing-lg" readonly>
								<%
									} else{ 
								%>
										<input type="text" style="text-align:right; background-color:#FFFFFF;" placeholder="<%out.println(SQuantity);%>" class="form-control" aria-label="aaaaaaa" aria-describedby="inputGroup-sizing-lg" readonly>
								<% 
									} 
								%>
							</div>						 
						  </div>
						  <div class="row" style="margin: 15px 0px 15px 0px;">
							<div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">매도가격</span>
							 	<input type="text" style="text-align:right; background-color:#FFFFFF;" placeholder="<%out.println(price_for_cal);%>" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg" readonly>
							</div>
						  </div>
						  <div class="row" style="margin: 15px 0px 15px 0px;">
						    <div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">판매수량</span>
							 	<input type="text" style="text-align:right;" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg">
							</div>
						  </div>
						  <div class="row" style="margin: 15px 0px 15px 0px;">
						    <div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">판매총액</span>
							 	<input type="text" style="text-align:right; background-color:#FFFFFF;" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg" readonly>
							</div>
						  </div>
						</div>
						<div class="d-grid gap-2 col-6 mx-auto">
							<%	
								// No login
								if(session.getAttribute("uNum") == null){%>
									<button class="btn btn-primary" type="button" style="text-align:center;" onclick="location.href='login.jsp'">로그인</button>
							<%
								} else{ 
							%>
									<button class="btn btn-primary" type="button" style="text-align:center;" onclick="location.href='login.jsp'">매도</button>
							<% 
								} 
							%>
						</div>
					</div>
				</div>
    		</div>
    		<div class="col"  style="min-width: 416px">
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
	</div>
</div>
</body>
</html>