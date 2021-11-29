<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="java.sql.ResultSet" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
	
	<link href="resource/css/styles.css" rel="stylesheet" />
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	
	<!--  datepicker  -->
	<link rel="stylesheet" href="//code.jquery.com/ui/1.8.18/themes/base/jquery-ui.css" />
	<script src="//ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
	<script src="//code.jquery.com/ui/1.8.18/jquery-ui.min.js"></script>
		
</head>
<body>
<script>
var id = <%=(String)session.getAttribute("uNUm")%>
if(id == null){
	alert('로그인이 필요합니다.');
	location.href = "main.jsp";
}
</script>

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
    <div class="content">
		<main>
			<div class="container-fluid px-4">
				<h2 class="mt-4">HISTORY</h2>
				<div class="card mb-4">
			       <div class="card-body">
			       	Transaction history
			       </div>
				</div>
			    <h1 class="mt-4"></h1>  
			    <div class="card mb-4">
			        <div class="card-header">
			            <i class="fas fa-table me-1"></i>
			            TRANSACTION
			        </div>		        			       		      
			        <div class="card-body">				       
			        		<div class="form-group" style="margin-bottom: 16px; text-align: left">
								<input class="form-control" name="startDate" type="text" id="startDate" placeholder="START DATE" 
								style="width: 150px; float: left; margin-left: 20px;" readonly>
									<script>
									$.datepicker.setDefaults({
								        dateFormat: 'yymmdd',
								        prevText: '이전 달',
								        nextText: '다음 달',
								        monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
								        monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
								        dayNames: ['일', '월', '화', '수', '목', '금', '토'],
								        dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
								        dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
								        showMonthAfterYear: true,
								        yearSuffix: '년'
								    });
							
								    $(function() {
								        $("#startDate").datepicker();
								    });
									</script>
		                        <input class="form-control" name="endDate" type="text" id="endDate" placeholder="END DATE" 
		                        style="width: 150px; float: left; margin-left: 20px;" readonly>
									<script>
									$.datepicker.setDefaults({
								        dateFormat: 'yymmdd',
								        prevText: '이전 달',
								        nextText: '다음 달',
								        monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
								        monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
								        dayNames: ['일', '월', '화', '수', '목', '금', '토'],
								        dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
								        dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
								        showMonthAfterYear: true,
								        yearSuffix: '년'
								    });
							
								    $(function() {
								        $("#endDate").datepicker();
								    });
									</script>
		                        <div class="d-flex align-items-center mt-4 mb-0">
									<script>
		                        	function reload(){
		                        		var start = document.getElementById("startDate").value;
		                        		var end =  document.getElementById("endDate").value;
		                        		
		                        		location.href="history.jsp?start=" + start + "&end=" +end;                   		
		                        	}
		                        	
		                        	</script>
									<button type="submit" class="btn btn-primary justify-content-between form-control " style="width: 100px; margin-left: 20px" onclick="reload(); return false;" value="Submit">Show</button>                      	
		                        </div>
	                        </div>				            			            
			            <table id="datatablesSimple">			         
			                <thead>
			                    <tr>
			                        <th>DATE</th>
			                        <th>COMPANY</th>
			                        <th>TYPEL</th>
			                        <th>VALUE</th>
			                        <th>VOLUME</th>
			                        <th>TOTAL</th>
			                    </tr>
			                </thead>		           
			                <tbody>
<% 
	Oracle orcl = Oracle.getInstance();
	String userId = session.getAttribute("userId").toString();
	
	String start;
	String end;
	
	try{
		start = request.getParameter("start").toString();
	} catch(Exception e){ // Null Event
		start = null;
	} 
	
	try{
		end = request.getParameter("end").toString();
	} catch(Exception e){ // Null Event
		end = null;
	} 
	
	
	ResultSet rs = orcl.getTransaction(userId, start, end);

	while(rs.next()){	
		String date = rs.getString(1);
		String company = rs.getString(2);
		String type = rs.getString(3);
		int value = rs.getInt(4);
		int volume = rs.getInt(5);
		int total = rs.getInt(6);
		
		out.println("<tr>");
		out.println("<td>" + date + "</td>");	
		out.println("<td>" + company + "</td>");
		out.println("<td>" + type + "</td>");
		out.println("<td>" + value + "</td>");
		out.println("<td>" + volume + "</td>");
		out.println("<td>" + total + "</td>");
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
     
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" ></script>
    <script src="https://cdn.jsdelivr.net/npm/simple-datatables@latest"></script>
    <script src="resource/js/datatables-simple-demo.js"></script>

</body>
</html>