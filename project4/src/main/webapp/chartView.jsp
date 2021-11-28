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

var getParameters = function (paramName) { 
	var returnValue;
	var url = location.href;
	var parameters = (url.slice(url.indexOf('?') + 1, url.length)).split('&'); 
	for (var i = 0; i < parameters.length; i++) {
		var varName = parameters[i].split('=')[0]; 
		if (varName.toUpperCase() == paramName.toUpperCase()) { 
			returnValue = parameters[i].split('=')[1]; 
			return decodeURIComponent(returnValue); 
			} 
		} 
	};

var sname = getParameters('sname');

</script>

<%

	Oracle orcl = Oracle.getInstance();
	ResultSet rs;
	String companyName = request.getParameter("sname");
	
	String data = orcl.stockChart(companyName);
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
						text: sname
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
						name: sname,
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
										<input type="text" style="text-align:right; background-color:#FFFFFF;" value="0" class="form-control" aria-label="aaaaaaa" aria-describedby="inputGroup-sizing-lg" readonly>
								<%
									} else{ 
								%>
										<input type="text" style="text-align:right; background-color:#FFFFFF;" value="<%out.println(UCash);%>" class="form-control" aria-label="aaaaaaa" aria-describedby="inputGroup-sizing-lg" readonly>
								<% 
									} 
								%>								
							</div>						 
						  </div>
						  <div class="row" style="margin: 15px 0px 15px 0px;">
							<div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">매수가격</span>
							 	<input type="text" style="text-align:right; background-color:#FFFFFF;" id="buy_price" value="<%out.println(price_for_cal);%>" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg" readonly>
							</div>
						  </div>
						  <div class="row" style="margin: 15px 0px 15px 0px;">
						    <div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">주문수량</span>
							 	<input type="text" style="text-align:right;" class="form-control" id="buy_cnt" value="0" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg">
							 		<script type="text/javascript">
							 			$("#buy_cnt").keyup(function(){
							 				$("#buy_total").val( parseInt($("#buy_cnt").val() || 0) * parseInt($("#buy_price").val()) );
							 			});
							 		</script>
							</div>
						  </div>
						  <div class="row" style="margin: 15px 0px 15px 0px;">
						    <div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">주문총액</span>
							 	<input type="text" style="text-align:right; background-color:#FFFFFF;" id="buy_total" value="0" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg" readonly>							 	
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
									<button class="btn btn-danger" id="buy_button" type="button" style="text-align:center;">매수</button>
							<% 
								} 
							%>	
								<script type="text/javascript">																
										$(function () {
											$("#buy_button").click(function() {
												
												if(parseInt($("#buy_cnt").val() || 0 ) == 0){
													alert("매수 수량을 입력해주세요.");
													return;
												}
												
												$.ajax({
												      type:'POST',
												      url:"./AjaxPostServlet",
												      data :{Cnt:$("#buy_cnt").val(), uNum:<%out.print(Integer.parseInt((session.getAttribute("uNum")).toString()));%>, stockName:sname, tradeCase:1},
												      async:true,
												      dataType:'json',
												      success : function(data) {
												    	  
												    	  var resultValue = 0;
												    	  
												    	  $.each(data, function(i, item){
																resultValue = item.returnValue;
															});
												    	  
												    	  console.log(resultValue);
												    	  
												    	  if(resultValue == 1){
												    		  alert("매수 완료");
												    		  window.location.reload();
												    	  }
												    	  else if(resultValue == -1){
												    		  alert("잔액 부족");
												    		  window.location.reload();
												    	  }
												    	  else if(resultValue == -2){
												    		  alert("거래 불가 주식");
												    		  window.location.reload();
												    	  }
												    	  else{
												    		  alert("거래 실패");
												    		  window.location.reload();
												    	  }
												      },
												      error : function(error) {
												        alert("error");
												      }
												    });
											});
										});																	
									</script>

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
										<input type="text" style="text-align:right; background-color:#FFFFFF;" value="0" class="form-control" aria-label="aaaaaaa" aria-describedby="inputGroup-sizing-lg" readonly>
								<%
									} else{ 
								%>
										<input type="text" style="text-align:right; background-color:#FFFFFF;" value="<%out.println(SQuantity);%>" class="form-control" aria-label="aaaaaaa" aria-describedby="inputGroup-sizing-lg" readonly>
								<% 
									} 
								%>
							</div>						 
						  </div>
						  <div class="row" style="margin: 15px 0px 15px 0px;">
							<div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">매도가격</span>
							 	<input type="text" style="text-align:right; background-color:#FFFFFF;" id="sell_price" value="<%out.println(price_for_cal);%>" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg" readonly>
							</div>
						  </div>
						  <div class="row" style="margin: 15px 0px 15px 0px;">
						    <div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">판매수량</span>
							 	<input type="text" style="text-align:right;" class="form-control" id="sell_cnt" value="0" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg">
							 		<script type="text/javascript">
							 			$("#sell_cnt").keyup(function(){
							 				$("#sell_total").val( parseInt($("#sell_cnt").val() || 0) * parseInt($("#sell_price").val()) );
							 			});
							 		</script>
							</div>
						  </div>
						  <div class="row" style="margin: 15px 0px 15px 0px;">
						    <div class="input-group input-group-lg">
								<span class="input-group-text" id="inputGroup-sizing-lg">판매총액</span>
							 	<input type="text" style="text-align:right; background-color:#FFFFFF;" id="sell_total" value="0" class="form-control" aria-label="Sizing example input" aria-describedby="inputGroup-sizing-lg" readonly>
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
									<button class="btn btn-primary" id="sell_button" type="button" style="text-align:center;">매도</button>
							<% 
								} 
							%>
									<script type="text/javascript">																
										$(function () {
											$("#sell_button").click(function() {
												
												if(parseInt($("#sell_cnt").val() || 0 ) == 0){
													alert("매도 수량을 입력해주세요.");
													return;
												}
												
												$.ajax({
												      type:'POST',
												      url:"./AjaxPostServlet",
												      data :{Cnt:$("#sell_cnt").val(), uNum:<%out.print(Integer.parseInt((session.getAttribute("uNum")).toString()));%>, stockName:sname, tradeCase:2},
												      async:true,
												      dataType:'json',
												      success : function(data) {
												    	  
												    	  var resultValue = 0;
												    	  
												    	  $.each(data, function(i, item){
																resultValue = item.returnValue;
															});
												    	  
												    	  console.log(resultValue);
												    	  
												    	  if(resultValue == 1){
												    		  alert("매도 완료");
												    		  window.location.reload();
												    	  }
												    	  else if(resultValue == -1){
												    		  alert("보유 수량 부족");
												    		  window.location.reload();
												    	  }
												    	  else if(resultValue == -2){
												    		  alert("거래 불가 주식");
												    		  window.location.reload();
												    	  }
												    	  else{
												    		  alert("거래 실패");
												    		  window.location.reload();
												    	  }
												      },
												      error : function(error) {
												        alert("error");
												      }
												    });
											});
										});																	
									</script>					
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