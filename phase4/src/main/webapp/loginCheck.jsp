<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="phase4.Oracle" %>
<% request.setCharacterEncoding("utf-8"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Login Check</title>
</head>
<body>
<%
	
	// No id
	if(request.getParameter("userId") == ""){  
		out.println("<script>alert('���̵� �Է��ϼ���.');</script>");
		out.println("<script>document.location.href='login.jsp';</script>");
	}
	// No pw
	else if(request.getParameter("userPw") == ""){ 
		out.println("<script>alert('��й�ȣ�� �Է��ϼ���.');</script>");
		out.println("<script>document.location.href='login.jsp';</script>");
	}
	// Try login
	else{
		Oracle orcl = new Oracle();
		
		String userId = request.getParameter("userId"); 
		String userPw = request.getParameter("userPw"); 
		
		int result = orcl.login(userId, userPw);
		
		switch(result){		
		case 0:	// Success
			out.println("<script>alert('�α��� �Ǿ����ϴ�.');</script>");
			out.println("<script>document.location.href='main.html';</script>");
			break;
		case 1: // Wrong Pw
			out.println("<script>alert('��й�ȣ�� �ٸ��ϴ�.');</script>");
			out.println("<script>document.location.href='login.jsp';</script>");
			break;
		case -1: // No matching id
			out.println("<script>alert('���̵� �������� �ʽ��ϴ�.');</script>");
			out.println("<script>document.location.href='login.jsp';</script>");
			break;
		case -2:
			out.println("<script>alert('����ġ ���� ����.');</script>");
			out.println("<script>document.location.href='login.jsp';</script>");
			break;
		}
	}	
%>

</body>
</html>