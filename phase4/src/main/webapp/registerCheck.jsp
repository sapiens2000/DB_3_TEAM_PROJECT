<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="UTF-8"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="phase4.UserDto" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register Check</title>
</head>
<body>
<%

		if(request.getParameter("regId") == null || request.getParameter("regPw") == null || 
			request.getParameter("regGender") == null || request.getParameter("regEmail") == null || 
			request.getParameter("regPhone") == null || request.getParameter("regAge") == null){
			out.println("<script>alert('입력이 안 된 사항이 있습니다.');</script>");
			out.println("<script>window.history.back();</script>");
		}else{
			Oracle orcl = Oracle.getInstance();
			UserDto user = UserDto.getUserInstance();
			
			user.setUserId(request.getParameter("regId"));
			user.setUserPw(request.getParameter("regPw"));
			user.setCurrent_total_asset(10000000);
			user.setCash(10000000);
			user.setEmail(request.getParameter("regEmail"));
			user.setGender(request.getParameter("regGender"));
			user.setPhone_num(request.getParameter("regPhone"));
			user.setAge(Integer.parseInt(request.getParameter("regAge")));
			
			int result = orcl.register(user);
			
			switch(result){
			case -2: // error
				out.println("<script>alert('예기치 못한 에러.');</script>");
				out.println("<script>window.history.back();</script>");
				break;
			case -1: // duplicate
				out.println("<script>alert('이미 존재하는 아이디입니다.');</script>");
				out.println("<script>window.history.back();</script>");
				break;
			case 0: // Success
				out.println("<script>alert('회원가입 성공.');</script>");			
				out.println("<script>location.href='main.jsp';</script>");
				break;
			}
		}

%>


</body>
</html>