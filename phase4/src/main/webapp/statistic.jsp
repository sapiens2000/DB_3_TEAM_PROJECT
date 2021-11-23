<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="java.util.ArrayList" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Statistic</title>
	<link href="resource/css/styles.css" rel="stylesheet" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" crossorigin="anonymous"></script>
  	<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.bundle.min.js"></script>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js"></script>>
</head>
<body>
	<nav class="navbar navbar-expand-sm navbar-dark bg-dark">
		<div class="container-fluid">
			<a class="navbar-brand" href="#">STOCK</a>
			<button class="navbar-toggler" type="button"
				data-bs-toggle="collapse" data-bs-target="#navbarNavAltMarkup"
				aria-controls="navbarNavAltMarkup" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<div class="collapse navbar-collapse" id="navbarNavAltMarkup">
				<ul class="navbar-nav">
					<li class="nav-item">
				    	<a class="nav-link active" aria-current="page" href="main.jsp">홈</a>
				    </li>
				    <li class="nav-item">
				        <a class="nav-link" href="#">주식</a>
				    </li>
				    <li class="nav-item">
				        <a class="nav-link" href="#">뉴스</a>
				    </li>	
				    <li class="nav-item">
				    	<a class="nav-link" href="ranking.jsp">랭킹</a>				
					</li>
					<li class="nav-item">
						<a class="nav-link" href="logout.jsp">로그아웃</a>
					</li>
					<li class="nav-item dropdown">
			        	<a class="nav-link dropdown-toggle" href="#" id="navbarDarkDropdownMenuLink" role="button" data-bs-toggle="dropdown" aria-expanded="false">
			            관리자 메뉴
			          	</a>
			          	<ul class="dropdown-menu dropdown-menu-dark" aria-labelledby="navbarDarkDropdownMenuLink">
			            	<li><a class="dropdown-item" href="userManagement.jsp">회원관리</a></li>
			            	<li><a class="dropdown-item" href="dataManagement.jsp">데이터관리</a></li>
			            	<li><a class="dropdown-item" href="statistic.jsp">통계</a></li>
			          	</ul>
			        </li>
				</ul>
			</div>
		</div>
	</nav>
		
<%
	Oracle orcl = Oracle.getInstance();
	ArrayList<Integer> numOfUsers = orcl.getUsersByAge();
%>		
		
	<div class="container-fluid px-4">
        <h2 class="mt-4"> Statistics</h2>
		<div class="card mb-4">
	        <div class="card-body">
	            Several Charts.
	        </div>
	    </div>
		<div class="col-lg-6">
		    <div class="card mb-4">
		        <div class="card-header">
		            <i class="fas fa-chart-bar me-1"></i>
		            USERS BY AGE
		        </div>
		        <div class="card-body"><canvas id="myBarChart" width="100%" height="50"></canvas></div>
		        <div class="card-footer small text-muted">Updated yesterday at 11:59 PM</div>
		    </div>
		</div>
	</div>
	
	<script type="text/javascript">
		//Set new default font family and font color to mimic Bootstrap's default styling
		Chart.defaults.global.defaultFontFamily = '-apple-system,system-ui,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,sans-serif';
		Chart.defaults.global.defaultFontColor = '#292b2c';
		
		// Bar Chart	
		var ctx = document.getElementById("myBarChart");
		var myBarChart = new Chart(ctx, {
		  type: 'bar',
		  data: {
		    labels: ["10대", "20대", "30대", "40대", "50대", "60+"],
		    datasets: [{
		      label: "USERS",
		      backgroundColor: "rgba(2,117,216,1)",
		      borderColor: "rgba(2,117,216,1)",
		      data: [<%=numOfUsers.get(0)%>, 
		      		 <%=numOfUsers.get(1)%>,
		      		 <%=numOfUsers.get(2)%>,
		      		 <%=numOfUsers.get(3)%>,
		      		 <%=numOfUsers.get(4)%>,
		      		 <%=numOfUsers.get(5)%>],
		    }],
		  },
		  options: {
		    scales: {
		      xAxes: [{
		        gridLines: {
		          display: false
		        },
		        ticks: {
		          maxTicksLimit: 6
		        }
		      }],
		      yAxes: [{
		        ticks: {
		          min: 0,
		          max: 10,
		          maxTicksLimit: 5
		        },
		        gridLines: {
		          display: true
		        }
		      }],
		    },
		    legend: {
		      display: false
		    }
		  }
		});

	</script>
	
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="resource/js/scripts.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.8.0/Chart.min.js" crossorigin="anonymous"></script>
    <script src="resource/assets/demo/barChart.jsp"></script>
</body>
</html>