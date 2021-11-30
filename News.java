package phase4;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class News {
	
	private String url; 
	private String companyName;
	
	public News(String sname) {
		
		this.companyName = sname;
		url = "https://search.naver.com/search.naver?where=news&query="+ sname + "&start="; 
	}

	public void getNews() {
		
		List<String> dates = new ArrayList<>();
		List<String> title = new ArrayList<>();
		List<String> each_url   = new ArrayList<>();
		
		Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        // ���� ��¥ ���ϱ�
        LocalDate now = LocalDate.now(ZoneId.of("Asia/Seoul"));
		try {			
			String str = "";			
			
			Connection conn = Jsoup.connect(url);						
			Document doc = conn.get();
									
			Elements elem = doc.select("ul.list_news > li");
		    
			// title + url			
			//while(page num) �߰��� ���� ������ �ѹ� �޾Ƽ� �ݺ���
			for(Element e: elem.select("a.news_tit")) {
				String temp = e.text().replace("'", "''").replace("\"", "\"\"");
				title.add(temp);
				each_url.add(e.attr("href"));
			}
						
			elem = doc.select("span.info");		
			// date
			for(Element date : elem) {
				String text = date.text();
				
				// : ~�ð� ��, ~�� ��
				if(text.substring(1, text.length()).equals("시간 전") || text.substring(2, text.length()).equals("시간 전")) {
	            	dates.add(now.toString());	   
	            } 
				// : ~ �� �� , ~7�� ��
				else if(text.substring(1, text.length()).equals("일 전")){
	            	int day = Integer.parseInt(text.substring(0, 1));    

	            	cal.add(Calendar.DATE, (-1 * day));	   
	            	
	            	dates.add(df.format(cal.getTime()));            	            	
	            	// ��¥ �ʱ�ȭ
	            	cal.add(Calendar.DATE, day);
	            	
	            }
				// yyyy-mm-dd 
				else {
	            	text.replace(".", "-");
	            	text = text.substring(0, 10);
	            	System.out.println(text);
	            	dates.add(text);
	            }
	        }
						
		}catch(Exception e) {			
			e.printStackTrace();
		}
		
		Oracle orcl = Oracle.getInstance();
		orcl.insertNews(dates, title, each_url, this.companyName);
					
	}
}
