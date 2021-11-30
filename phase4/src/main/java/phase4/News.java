package phase4;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;


import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class News {
	private static News news;
	private String url; 
	private String company;
	
	private News() {}
	
	public static synchronized News getNewsInstance() {
		if(news == null) {
			news = new News();
		}
		return news;
	}

	public void getNews() {
		ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
		ArrayList<String> title = new ArrayList<>();
		ArrayList<String> dates = new ArrayList<>();
		ArrayList<String> href = new ArrayList<>();
		
		Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        // get today 
        LocalDate now = LocalDate.now(ZoneId.of("Asia/Seoul"));
		try {			
			String str = "";			
			
			Connection conn = Jsoup.connect(url);						
			Document doc = conn.get();
									
			Elements elem = doc.select("ul.list_news > li");
		    
			// title + url			
			//while(page num) �߰��� ���� ������ �ѹ� �޾Ƽ� �ݺ���
			for(Element e: elem.select("a.news_tit")) {		          				
				str = e.text();
				str = str.replace("'", "\"");
				
				title.add(str);
				str = e.attr("href");
				href.add(str);
			}
			
			elem = doc.select("span.info");
			
			
			// date
			for(Element date : elem) {
				String text = date.text();
				if(text.contains("��"))
					continue;
				
				// : ~�ð� ��, ~�� ��
				if(text.substring(1, text.length()).equals("�ð� ��") || text.substring(2, text.length()).equals("�ð� ��")) {
	            	dates.add(now.toString());	   
	            } 
				// : ~ �� �� , ~7�� ��
				else if(text.substring(1, text.length()).equals("�� ��")){
	            	int day = Integer.parseInt(text.substring(0, 1));    

	            	cal.add(Calendar.DATE, (-1 * day));	   
	            	
	            	dates.add(df.format(cal.getTime()));            	            	
	            	// ��¥ �ʱ�ȭ
	            	cal.add(Calendar.DATE, day);
	            	
	            }
				// yyyy-mm-dd 
				else {
	            	text = text.replace(".", "-");
	            	if(text.charAt(10) == '-') {
	            		text = text.substring(0, 10);
	            	}
	            	dates.add(text);
	            }
	        }
						
		}catch(Exception e) {			
			e.printStackTrace();
		}
		result.add(dates);
		result.add(title);
		result.add(href);
		
		Oracle orcl = Oracle.getInstance();	
		orcl.insertNews(result, this.company);
		orcl.commit();
	}	
	
	public void setCompany(String company) {
		this.company = company;
	}
	
	public String getCompany() {
		return this.company;
	}
	
	public void setUrl(String sname) {
		this.url = "https://search.naver.com/search.naver?where=news&query="+ sname + "&start=";
	}
	
	public String getUrl(){
		return this.url;
	}
}
