<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Register</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">

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
	<div class="register_container">
		<div class="row justify-content-center">
	        <div class="col-lg-5">
	            <div class="card shadow-lg border-0 rounded-lg mt-5">
	                <div class="card-header"><h3 class="text-center font-weight-light my-4">Register</h3></div>
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
									<label class="btn btn-primary active">
										<input type="radio" name="regGender" autocomplete="off" value="M" >남자
									</label>
									<label class="btn btn-primary active">
										<input type="radio" name="regGender" autocomplete="off" value="F" >여자
									</label>
								</div>
							</div>
	                        <div class="d-flex align-items-center mt-4 mb-0">
	                            <input type="submit" class="btn btn-primary justify-content-between form-control" value="가입">
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
		
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.9.2/dist/umd/popper.min.js" integrity="sha384-IQsoLXl5PILFhosVNubq5LC7Qb9DXgDA9i+tQ8Zj3iwWAwPtgFTxbJ8NT4GN1R8p" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.min.js" integrity="sha384-cVKIPhGWiC2Al4u+LWgxfKTRIcfu0JTxR+EQDz/bgldoEyl4H0zUF0QKbrJ0EcQF" crossorigin="anonymous"></script>
</body>
</html>