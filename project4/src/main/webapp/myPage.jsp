<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
	
	
</body>
</html>