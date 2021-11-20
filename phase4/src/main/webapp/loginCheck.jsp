<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login Check</title>
</head>
<body>
<%
	
	// No id
	if(request.getParameter("userId") == ""){  
		out.println("<script>alert('아이디를 입력하세요.');</script>");
		out.println("<script>document.location.href='login.jsp';</script>");
	}
	// No pw
	else if(request.getParameter("userPw") == ""){ 
		out.println("<script>alert('비밀번호를 입력하세요.');</script>");
		out.println("<script>document.location.href='login.jsp';</script>");
	}
	// Try login
	else{
		Oracle orcl = Oracle.getInstance();
		
		String userId = request.getParameter("userId"); 
		String userPw = request.getParameter("userPw"); 
		
		int result = orcl.login(userId, userPw);
		
		switch(result){		
		case -1: // Wrong Pw
			out.println("<script>alert('비밀번호가 다릅니다.');</script>");
			out.println("<script>location.href='login.jsp';</script>");
			break;
		case -2: // No matching id
			out.println("<script>alert('아이디가 존재하지 않습니다.');</script>");
			out.println("<script>location.href='login.jsp';</script>");
			break;
		case -3:
			out.println("<script>alert('예기치 못한 에러.');</script>");
			out.println("<script>location.href='login.jsp';</script>");
			break;
		default: // Success
			out.println("<script>alert('로그인 되었습니다.');</script>");
			session.setAttribute("uNum", result);
			out.println("<script>location.href='main2.jsp';</script>");
			break;		
		}
	}	
%>

</body>
</html>