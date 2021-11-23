<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="phase4.UserBean" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Update User</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
	<style>
	.container {
		  display: flex;
		  flex-direction: column;
		  justify-content: center;
		  min-height: 80vh;
		}		
	</style>
	
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
	UserBean user = new UserBean();	
	
	String userId = request.getParameter("userId");
	user = orcl.getUserData(userId);
	
%>
	<div class="container">
		<div class="col-lg-4" style="margin:0 auto;">
			<div class="jumbotron" style="padding-top: 20px;">
			<form method="post" action="userUpdateCheck.jsp">
				<h3 style="text-align: center;">회원정보 수정</h3>
				<div class="form-group">
				<input type="text" class="form-control" placeholder="아이디" name="updateId" maxlength="20" value="<%=user.getUserId()%>" readonly>
				</div>
				<div class="form-group">
					<input type="password" class="form-control" placeholder="비밀번호" name="updatePw" maxlength="20" value="<%=user.getUserPw()%>">
				</div>
				<div class="form-group">
					<input type="email" class="form-control" placeholder="이메일" name="updateEmail" maxlength="50" value="<%=user.getEmail()%>">
				</div>	
				<div class="form-group">
					<input type="number" class="form-control" placeholder="보유금액" name="updateAge" maxlength="50" value="<%=user.getAge()%>">
				</div>
				<div class="form-group">
					<input type="tel" class="form-control" placeholder="전화번호" name="updatePhone" maxlength="50" value="<%=user.getPhone_num()%>">
				</div>		
				<input type="number" class="form-control" placeholder="현재자산" name="updateCurAsset" maxlength="50" value="<%=user.getCurrent_total_asset()%>" readonly>			
				<div class="form-group">
					<input type="number" class="form-control" placeholder="보유금액" name="updateCash" maxlength="50" value="<%=user.getCash()%>">
				</div>
				<div class="form-group" style="text-align: center;">
					<div class="btn-group" data-toggle="buttons">					
							<%
							if(user.getGender().equals("M")){ %>
								<label class="btn btn-primary active">			
								<input type="radio" name="updateGender" autoComplete="off" value="M" checked>남자</label>
								<label class="btn btn-primary ">
								<input type="radio" name="updateGender" autoComplete="off" value="W" >여자</label>					
							<%
							} else{ %>
								<label class="btn btn-primary active">
								<input type="radio" name="userGender" autoComplete="off" value="W" checked>여자</label>
								<label class="btn btn-primary">			
								<input type="radio" name="userGender" autoComplete="off" value="M" >남자</label>
							<%}%>
					</div>
				</div>
				<input type="submit" class="btn btn-primary form-control" value="수정완료">
			</form>
			</div>
		</div>
	</div>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>

</body>
</html>