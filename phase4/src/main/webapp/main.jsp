<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Main</title>
<head>
	<!-- Required meta tags -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">										
    <title>Main</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
	<!-- Favicon-->
    <link rel="icon" type="image/x-icon" href="resource/assets/img/favicon.ico" />
    <!-- Bootstrap icons-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet" />
    <link href="resource/css/main-styles.css" rel="stylesheet" />
    
</head>
<body>
<%	
	// No login
	if(session.getAttribute("uNum") == null){%>
		<jsp:include page="NavBar/navbar.jsp"/>
<%
	} 
	// Admin
	else if((int)session.getAttribute("uNum") == -1){ %>
		<jsp:include page="NavBar/navbar-admin.jsp"/>		
<%
	} else{ 
%>
		<jsp:include page="NavBar/navbar-login.jsp"/>
<% 
	}
%>		
	<header class="bg-dark py-5">
	    <div class="container px-5">
	        <div class="row gx-5 justify-content-center">
	            <div class="col-lg-6">
	                <div class="text-center my-5">
	                    <h1 class="display-5 fw-bolder text-white mb-2">Welcome to Our Website.</h1>
	                    <p class="lead text-white-50 mb-4">This is Database-COMP322 Project.</p>
	                    <div class="d-grid gap-3 d-sm-flex justify-content-sm-center">
	                        <a class="btn btn-outline-light btn-lg px-4" href="https://github.com/sapiens2000/DB_3_TEAM_PROJECT">Github</a>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
	</header>
	
	<!-- Features section-->
    <section class="py-5 border-bottom" id="features">
        <div class="container px-5 my-5">
            <div class="row gx-5">
                <div class="col-lg-4 mb-5 mb-lg-0">
                    <div class="feature bg-primary bg-gradient text-white rounded-3 mb-3"><i class="bi bi-collection"></i></div>
                    <h2 class="h4 fw-bolder">Search</h2>
                    <p>Search stock, news according on your interests.</p>
                    <a class="text-decoration-none" href="#">
                        Go
                        <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
                <div class="col-lg-4 mb-5 mb-lg-0">
                    <div class="feature bg-primary bg-gradient text-white rounded-3 mb-3"><i class="bi bi-building"></i></div>
                    <h2 class="h4 fw-bolder">TRAINING</h2>
                    <p>You can buy/sell stocks. Compete with other users. But you need to login first.</p>
                    <a class="text-decoration-none" href="login.jsp">
                        Go
                        <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
                <div class="col-lg-4">
                    <div class="feature bg-primary bg-gradient text-white rounded-3 mb-3"><i class="bi bi-toggles2"></i></div>
                    <h2 class="h4 fw-bolder">??</h2>
                    <p>?</p>
                    <a class="text-decoration-none" href="#!">
                        Go
                        <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </section>
	
	
	
	<!-- Footer-->
    <footer class="py-5 bg-dark">
        <div class="container px-5"><p class="m-0 text-center text-white">Copyright &copy; TEAM 3</p></div>
    </footer>
</body>
</html>