<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@ page import="phase4.Oracle" %>
<%@ page import="phase4.News" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>Insert title here</title>
</head>
<body>
<%
	Oracle orcl = Oracle.getInstance();
	News news = new News("삼성전자", 1);
	
	news.getNews();
%>
</body>
</html>