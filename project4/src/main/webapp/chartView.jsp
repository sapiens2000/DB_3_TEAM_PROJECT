<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="phase4.getChart" %>
<!DOCTYPE html>
<html>
<head>
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="https://code.highcharts.com/stock/highstock.js"></script>
<script src="https://code.highcharts.com/stock/modules/exporting.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>STOCK CHART</title>
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
</head>
<body>
	<div id="container" style="height: 400px; min-width: 310px"></div>
	<input type="text" id="company" placeholder="주식 검색">   
	<input type="button" id="send" value="검색"><br><br>
</body>
</html>