<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="phase4.UserDto" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>User Update Check</title>
</head>
<body>
<% 
	Oracle orcl = Oracle.getInstance();

	UserDto user = orcl.getUserData(request.getParameter("updateId"));
	
	user.setUserPw(request.getParameter("updatePw"));
	user.setCash(Integer.parseInt(request.getParameter("updateCash")));
	user.setEmail(request.getParameter("updateEmail"));
	user.setGender(request.getParameter("updateGender"));
	user.setPhone_num(request.getParameter("updatePhone"));
	user.setAge(Integer.parseInt(request.getParameter("updateAge")));
	
	boolean result = orcl.updateUser(user);
	if(result){
		out.println("<script>alert('수정완료.');</script>");
	}else{
		out.println("<script>alert('수정실패.');</script>");
	}
	out.println("<script>history.back();</script>");
%>
</body>
</html>