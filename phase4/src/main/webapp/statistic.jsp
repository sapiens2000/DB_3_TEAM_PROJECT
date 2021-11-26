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
	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no" />
	<!-- Google fonts-->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700" rel="stylesheet" type="text/css" />
    <link href="https://fonts.googleapis.com/css?family=Roboto+Slab:400,100,300,700" rel="stylesheet" type="text/css" />
    <link href="resource/css/main-styles.css" rel="stylesheet" />
    <link href="resource/css/team-styles.css" rel="stylesheet" />
	
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js" ></script>
  	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.bundle.min.js"></script>
	<script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.min.js"></script>
	
	<style>
	.row {
	    display: flex;
	    flex-wrap: wrap;
	    margin-right: -.75rem;
	    margin-left: -.75rem;
	}
	</style>

</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container px-5">
            <a class="navbar-brand" href="#!">주식박사</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"><span class="navbar-toggler-icon"></span></button>
            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0">
					<li class="nav-item"><a class="nav-link active" aria-current="page" href="main.jsp">주식박사</a></li>
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
	Oracle orcl = Oracle.getInstance();
	ArrayList<Integer> numOfUsers = orcl.getUsersByAge();
	int userNum = orcl.getUserNum();
	int maleNum = orcl.getUserByGender("M");
	int femaleNum = orcl.getUserByGender("F");
	int companyNum = orcl.getCompanyNum();
	int sectorNum = orcl.getSectorNum();
%>	

	<div class="content">
		<main>
			<div class="container-fluid px-4">			
				<h2 class="mt-4">Statistics</h2>
				<div class="card mb-4">
			       <div class="card-body">
			           Several Statistics & Charts.
			       </div>
				</div>
				<div class="row">
					<div class="col-xl-3 col-md-6 mb-4">
	                     <div class="card border-left-info shadow h-100 py-2">
	                         <div class="card-body">
	                             <div class="row no-gutters align-items-center">
	                                 <div class="col mr-2">
	                                     <div class="text-xs font-weight-bold text-info text-uppercase mb-1">COMPANYS
	                                     </div>
	                                     <div class="row no-gutters align-items-center">
	                                         <div class="col-auto">
	                                             <div class="h5 mb-0 mr-3 font-weight-bold text-gray-800"><%=companyNum%></div>
	                                         </div>
	                                     </div>
	                                 </div>
	                                 <div class="col-auto">
	                                     <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
	                                 </div>
	                             </div>
	                         </div>
	                     </div>
	                </div>
	                <div class="col-xl-3 col-md-6 mb-4">
                            <div class="card border-left-success shadow h-100 py-2">
                                <div class="card-body">
                                    <div class="row no-gutters align-items-center">
                                        <div class="col mr-2">
                                            <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                                SECTORS</div>
                                            <div class="h5 mb-0 font-weight-bold text-gray-800"><%=sectorNum%></div>
                                        </div>
                                        <div class="col-auto">
                                            <i class="fas fa-clipboard-list fa-2x text-gray-300"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                    </div>
	                <div class="col-xl-3 col-md-6 mb-4">
		                <div class="card border-left-primary shadow h-100 py-2">
		                    <div class="card-body">
		                        <div class="row no-gutters align-items-center">
		                            <div class="col mr-2">
		                                <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
		                                    USERS</div>
		                                <div class="h5 mb-0 font-weight-bold text-gray-800"><%=userNum%></div>
		                            </div>
		                            <div class="col-auto">
		                                <i class="fas fa-calendar fa-2x text-gray-300"></i>
		                            </div>
		                        </div>
		                    </div>
		                </div>
	                </div>
                </div>
                
				<div class="col-lg-6" style="float: right; margin-left: 10px">
		        	<div class="card mb-4">
				    	<div class="card-header">
				        	<i class="fas fa-chart-bar me-1"></i>
				            나이대별 유저 수
				        </div>
				    	<div class="card-body"><canvas id="myBarChart" width="110%" height="50"></canvas></div>
					</div>
				</div>
				<div class="col-lg-6" style="margin-right: 10px">
		        	<div class="card mb-4">
		            	<div class="card-header">
		                	<i class="fas fa-chart-pie me-1"></i>
							나이대별 유저 수
		              		</div>
		              	<div class="card-body"><canvas id="myPieChart" width="109%" height="50"></canvas></div>
		         	</div>
				</div>
				<div class="col-lg-6" style="margin-right: 10px">
		        	<div class="card mb-4">
		            	<div class="card-header">
		                	<i class="fas fa-chart-pie me-1"></i>
							유저 성비
		              		</div>
		              	<div class="card-body"><canvas id="myPieChart2" width="109%" height="50"></canvas></div>
		         	</div>
				</div>		
			</div>
		</main>
	</div>
	
	
	<script type="text/javascript">
		// Set new default font family and font color to mimic Bootstrap's default styling
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
		
		// Pie Chart
		var ctx = document.getElementById("myPieChart");
		var myPieChart = new Chart(ctx, {
		  type: 'pie',
		  data: {
		    labels: ["10대", "20대", "30대", "40대", "50대", "60+"],
		    datasets: [{
		    	data: [<%=numOfUsers.get(0)%>, 
		      		 <%=numOfUsers.get(1)%>,
		      		 <%=numOfUsers.get(2)%>,
		      		 <%=numOfUsers.get(3)%>,
		      		 <%=numOfUsers.get(4)%>,
		      		 <%=numOfUsers.get(5)%>],
		      backgroundColor: ['#007bff', '#dc3545', '#ffc107', '#28a745', '#77bf00', '#9B50E7'],
		    }],
		  },
		});
		
		// Pie Chart2
		var ctx = document.getElementById("myPieChart2");
		var myPieChart2 = new Chart(ctx, {
		  type: 'pie',
		  data: {
		    labels: ["남자", "여자"],
		    datasets: [{
		    	data: [<%=maleNum%>, 
		      		 	<%=femaleNum%>],
		      backgroundColor: ['#007bff', '#dc3545'],
		    }],
		  },
		});
	</script>
	<!-- Footer-->
    <footer class="py-5 bg-dark">
        <div class="container px-5"><p class="m-0 text-center text-white">Copyright &copy; TEAM 3</p></div>
    </footer>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" crossorigin="anonymous"></script>
    <script src="resource/js/scripts.js"></script>

</body>
</html>