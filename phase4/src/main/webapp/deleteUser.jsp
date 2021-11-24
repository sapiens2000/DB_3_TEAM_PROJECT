<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete User</title>
</head>
<body>
<%
	Oracle orcl = Oracle.getInstance();
	
	boolean result = orcl.deleteUser(request.getParameter("userId"));
	
	if(result){		
		out.println("<script>alert('삭제 완료.');</script>");
	}else{
		out.println("<script>alert('삭제 실패.');</script>");
	}
	out.println("<script>location.href='userManagement.jsp';</script>");
%>
</body>
</html>