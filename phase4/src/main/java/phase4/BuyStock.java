package phase4;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import phase4.Oracle;

@WebServlet("/AjaxPostServlet")
public class BuyStock extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		
		Oracle orcl = Oracle.getInstance();
		
		int buyCnt = Integer.parseInt(request.getParameter("Cnt"));
		int uNum = Integer.parseInt(request.getParameter("uNum"));
		String company = request.getParameter("stockName");
		int tradeCase = Integer.parseInt(request.getParameter("tradeCase"));
		System.out.println(company);
		System.out.println(buyCnt);
		System.out.println(uNum);
		System.out.println(tradeCase);

		int result = 0;
		
		if(tradeCase == 1) {				
			result = orcl.buyStock(company, uNum, buyCnt);
		}
		else {
			result = orcl.sellStock(company, uNum, buyCnt);
		}
		
//		System.out.println("result is " + result);
//		
		String returnValue = "[{\"returnValue\":" + result + "}]";
//		
//		System.out.println(returnValue);
		
		PrintWriter out = response.getWriter();	

		out.write(returnValue);
		out.flush();
		out.close();
	}

}