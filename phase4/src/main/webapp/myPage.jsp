<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.UserBean" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My page</title>
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
					<h3 style="text-align: center;">내정보</h3>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="아이디" name="userId" maxlength="20">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="비밀번호" name="userPw" maxlength="20">
					</div>
					<input type="submit" class="btn btn-primary form-control" value="로그인">
				</form>
			</div>
		</div>	
	</div>
	
	
	
	
	
	
	
	
	
	
	
</body>
</html>