package phase4;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import phase4.GraphDto;
import phase4.Oracle;

@WebServlet("/AjaxPostServlet")
public class getChart extends HttpServlet {
	private static final long serialVersionUID = 1L;
    

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		
		response.setCharacterEncoding("utf-8");
		response.setContentType("application/json");
		
		ArrayList<GraphDto> list;
		
		Oracle orcl = Oracle.getInstance();
		
		String company = request.getParameter("company");
		System.out.println(company);

		PrintWriter out = response.getWriter();	
		
		list = orcl.stockChart(company);
		System.out.println(list);
		
		out.write(list.toString());
		out.flush();
		out.close();
	}

}

