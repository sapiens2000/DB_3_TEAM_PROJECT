<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Login</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
	<style>
		.login_container {
		  display: flex;
		  flex-direction: column;
		  justify-content: center;
		  min-height: 80vh;
		}	
	</style>
</head>
<body>
<%	
	// 로그인 되어있는데 다시 url로 로그인 페이지 접속 방지
	if(session.getAttribute("uNum") != null){ 
		out.println("<script>location.href='main.jsp';</script>");
	}
%>	
	<jsp:include page="NavBar/navbar.jsp"/>
	
	<div class="login_container">
		<div class="row justify-content-center">
	        <div class="col-lg-5">
	            <div class="card shadow-lg border-0 rounded-lg mt-5">
	                <div class="card-header"><h3 class="text-center font-weight-light my-4">Login</h3></div>
	                <div class="card-body">
	                    <form method="post" action="loginCheck.jsp">
	                        <div class="form-floating mb-3">
	                            <input class="form-control" name="userId" type="text" placeholder="Id">
	                            <label for="inputId">Id</label>
	                        </div>
	                        <div class="form-floating mb-3">
	                            <input class="form-control" name="userPw" type="password" placeholder="Password">
	                            <label for="inputPassword">Password</label>
	                        </div>
	                        <div class="d-flex align-items-center mt-4 mb-0">
	                            <input type="submit" class="btn btn-primary justify-content-between form-control" value="로그인">
	                        </div>
	                    </form>
	                </div>
	                <div class="card-footer text-center py-3">
	                    <div class="small"><a href="register.jsp">Sign up</a></div>
	                </div>
	            </div>
	        </div>
	    </div>
    </div>
    
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js"></script>
	
</body>
</html>