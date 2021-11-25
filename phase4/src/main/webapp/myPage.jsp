<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.UserBean" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My page</title>
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script> $( function() { $( "#datepicker" ).datepicker();
$("#datepicker").datepicker({ numberOfMonths: 1 , showWeek: false ,
	firstDay: 1 , dateFormat:"yymmdd" , prevText: '이전 달' ,
	nextText: '다음 달' , monthNames: ['1월', '2월', '3월', '4월',
		'5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'] ,
		monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월',
			'7월', '8월', '9월', '10월', '11월', '12월'] ,
			dayNames: ['일', '월', '화', '수', '목', '금', '토'] ,
			dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'] ,
			dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'] ,
			showMonthAfterYear: true , yearSuffix: '년' }); });
} );</script>
</head>
<body>
<%
	// No Login Session
	if(session.getAttribute("uNum") == null){ 
		out.println("<script>alert('로그인이 필요합니다.');</script>");
		out.println("<script>location.href='main.jsp';</script>");	
	}
%>

	<jsp:include page="NavBar/navbar-login.jsp"/>
	
	<div class="myPage_container">		
		<div class="col-lg-4" style="margin:0 auto">	
			<div class="jumbotron" style="padding-top: 20px;">
				<form method="post" action="loginCheck.jsp">
					<h3 style="text-align: center;">내 정보</h3>
					
					
					<input type="submit" class="btn btn-primary form-control" value="저장">
				</form>
			</div>
		</div>	
	</div>
	<!-- 사이드 바 메뉴-->
	<div class="col-md-3">
	  <!-- 패널 타이틀1 -->
	<div class="panel panel-info">
	    <div class="panel-heading">
	      <h3 class="panel-title">Panel Title</h3>
	    </div>
	    <!-- 사이드바 메뉴목록1 -->
	    <ul class="list-group">
	      <li class="list-group-item"><a href="User_info.jsp">User info</a></li>
	      <li class="list-group-item"><a href="Trans_history.jsp">Trans history</a></li>
	      <li class="list-group-item"><a href="Asset.jsp">Asset</a></li>
	      <li class="list-group-item"><a href="Asset_of_stock.jsp">Asset of stock</a></li>
	    </ul>
	</div>
	</div>
	<footer class="py-5 bg-dark">
        <div class="container px-5"><p class="m-0 text-center text-white">Copyright &copy; TEAM 3</p></div>
    </footer>
</body>
</html>