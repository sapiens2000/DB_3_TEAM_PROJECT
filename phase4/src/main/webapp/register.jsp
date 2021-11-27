<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Register</title>
<<<<<<< HEAD
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
=======
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
>>>>>>> main

	<style>
		.register_container {
		  display: flex;
		  flex-direction: column;
		  justify-content: center;
		  min-height: 80vh;
		}	
	</style>
</head>
<body>
	<jsp:include page="NavBar/navbar.jsp"/>
	<!-- Register  -->
<<<<<<< HEAD
	<div class="register_container">
		<div class="row justify-content-center">
	        <div class="col-lg-5">
	            <div class="card shadow-lg border-0 rounded-lg mt-5">
	                <div class="card-header"><h3 class="text-center font-weight-light my-4">Sing Up</h3></div>
	                <div class="card-body">
	                    <form method="post" action="registerCheck.jsp">
	                        <div class="form-floating mb-3">
	                            <input class="form-control" name="regId" type="text" placeholder="Id">
	                            <label for="inputId">Id</label>
	                        </div>
	                        <div class="form-floating mb-3">
	                            <input class="form-control" name="regPw" type="password" placeholder="Password">
	                            <label for="inputPassword">Password</label>
	                        </div>
	                        <div class="form-floating mb-3">
	                            <input class="form-control" name="regEmail" type="email" placeholder="Email">
	                            <label for="inputEmail">Email</label>
	                        </div>
	                        <div class="form-floating mb-3">
	                            <input class="form-control" name="regPhone" type="tel" placeholder="Phone">
	                            <label for="inputPassword">Phone</label>
	                        </div>
	                        <div class="form-floating mb-3">
	                            <input class="form-control" name="regAge" type="number" placeholder="Age">
	                            <label for="inputPassword">Age</label>
	                        </div>
	                        <div class="form-group" style="text-align: center;">
								<div class="btn-group" data-toggle="buttons">
									<label class="btn btn-primary">
										<input type="radio" name="regGender" autocomplete="off" value="M" >남자
									</label>
									<label class="btn btn-primary active">
										<input type="radio" name="regGender" autocomplete="off" value="F" >여자
									</label>
								</div>
							</div>
	                        <div class="d-flex align-items-center mt-4 mb-0">
	                            <input type="submit" class="btn btn-primary justify-content-between form-control" value="Submit">
	                        </div>
	                    </form>
	                </div>
	                <div class="card-footer text-center py-3">
	                    <div class="small"><a href="login.jsp">Already have an account</a></div>
	                </div>
	            </div>
	        </div>
	    </div>
    </div>
=======
	
	<div class="register_container">		
		<div class="col-lg-4" style="margin:0 auto">	
			<div class="jumbotron" style="padding-top: 20px;">
				<form method="post" action="registerCheck.jsp">
					<h3 style="text-align: center;">회원가입</h3>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="아이디" name="regId" maxlength="20">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="비밀번호" name="regPw" maxlength="20">
					</div>
					<div class="form-group">
						<input type="email" class="form-control" placeholder="이메일" name="regEmail" maxlength="30">
					</div>
					<div class="form-group">
						<input type="tel" class="form-control" placeholder="전화번호" name="regPhone" maxlength="13">
					</div>
					<div class="form-group">
						<input type="number" class="form-control" placeholder="나이" name="regAge" maxlength="3">
					</div>
					<div class="form-group" style="text-align: center;">
						<div class="btn-group" data-toggle="buttons">
							<label class="btn btn-primary active">
								<input type="radio" name="regGender" autocomplete="off" value="M" >남자
							</label>
							<label class="btn btn-primary active">
								<input type="radio" name="regGender" autocomplete="off" value="F" >여자
							</label>
						</div>
					</div>
					<input type="submit" class="btn btn-primary form-control" value="가입">
				</form>
			</div>
		</div>	
	</div>
	<!-- Footer-->
    <footer class="py-5 bg-dark">
        <div class="container px-5"><p class="m-0 text-center text-white">Copyright &copy; TEAM 3</p></div>
    </footer>
>>>>>>> main
		
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
</body>
</html>