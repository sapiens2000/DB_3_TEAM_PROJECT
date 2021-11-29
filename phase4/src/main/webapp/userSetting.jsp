<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="phase4.UserBean" %>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Setting</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
	<!-- Show icon -->
	<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/js/all.min.js"></script>
	<style>
	.card {
		border: 0;
	    border-radius: .5rem;
	    box-shadow: 0 2px 4px rgba(0,0,20,.08),0 1px 2px rgba(0,0,20,.08);
	}
	.card{
	    word-wrap: break-word;
	    background-clip: border-box;
	    background-color: #fff;
	    border: 1px solid rgba(0,0,0,.125);
	    border-radius: .375rem;
	    display: flex;
	    flex-direction: column;
	    min-width: 0;
	    position: relative;
	}
	</style>
</head>
<body>
<%	
	// need login
	if(session.getAttribute("uNum") == null){ 
		out.println("<script>alert('로그인이 필요합니다.');</script>");
		out.println("<script>location.href='main.jsp';</script>");
	}
%>	

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
<% 
	Oracle orcl = Oracle.getInstance();
	UserBean user = new UserBean();			
	String userId = session.getAttribute("userId").toString();
	
	user = orcl.getUserData(userId);	
%>
    
    <div class="container">
		<div class="row justify-content-center">
	        <div class="col-lg-5">
	            <div class="card shadow-lg border-0 rounded-lg mt-5">
	                <div class="card-header"><h3 class="text-center font-weight-light my-4">Setting</h3></div>
	                <div class="card-body">
	                    <form method="post" action="userUpdateCheck.jsp">
	                        <div class="form-floating mb-3">
	                            <input class="form-control" name="updateId" type="text" placeholder="Id" value="<%=user.getUserId()%>" readonly>
	                            <label for="updateId">Id</label>
	                        </div>
	                        <div class="form-floating mb-3">
	                            <input class="form-control" name="updatePw" type="password" placeholder="Password" value="<%=user.getUserPw()%>" required>
	                            <label for="updatePw">Password</label>
	                        </div>
	                        <div class="form-floating mb-3">
	                            <input class="form-control" name="updateEmail" type="email" placeholder="Email" value="<%=user.getEmail()%>" required>
	                            <label for="updateEmail">Email</label>
	                        </div>
	                        <div class="form-floating mb-3">
	                            <input class="form-control" name="updatePhone" type="tel" placeholder="Phone" value="<%=user.getPhone_num()%>" required>
	                            <label for="updatePhone">Phone</label>
	                        </div>
	                        <div class="form-floating mb-3">
	                            <input class="form-control" name="updateAge" type="number" placeholder="Age" value="<%=user.getAge()%>" required>
	                            <label for="updateAge">Age</label>
	                        </div>
	                        <div class="form-floating mb-3">
	                        	<input type="number" class="form-control" placeholder="현재자산" name="updateTotalAsset" maxlength="50" value="<%=user.getCurrent_total_asset()%>" readonly>	
	                        	<label for="updateTotalAsset">Total Asset</label>	
	                        </div>
	                        <div class="form-floating mb-3">
								<input type="number" class="form-control" placeholder="보유금액" name="updateCash" maxlength="50" value="<%=user.getCash()%>" readonly>
								<label for="updateCash">Cash</label>
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
	                        <div class="d-flex align-items-center mt-4 mb-0">
	                            <input type="submit" class="btn btn-primary justify-content-between form-control" value="Save">
	                        </div>
	                    </form>
	                </div>
	            </div>
	        </div>
	    </div>
	</div>
   
	<script src="resource/js/theme.min.js"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>