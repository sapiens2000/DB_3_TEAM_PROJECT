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
	private String url; 
	
	public News(String sname, int page) {		
		url = "https://search.naver.com/search.naver?where=news&query="+ sname + "&start=" + page;				
	}

	public ArrayList<ArrayList<String>> getNews() {
		ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
		ArrayList<String> title = new ArrayList<>();
		ArrayList<String> dates = new ArrayList<>();
		ArrayList<String> href = new ArrayList<>();
		
		Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        DateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        // 현재 날짜 구하기
        LocalDate now = LocalDate.now(ZoneId.of("Asia/Seoul"));
		try {			
			String str = "";			
			
			Connection conn = Jsoup.connect(url);						
			Document doc = conn.get();
									
			Elements elem = doc.select("ul.list_news > li");
		    
			// title + url			
			//while(page num) 추가로 볼때 페이지 넘버 받아서 반복문
			for(Element e: elem.select("a.news_tit")) {		          				
				str = e.text();
				str = str.replace("'", "\"");
				title.add(str);
				str = e.attr("href");
				href.add(str);
			}
			
			elem = doc.select("span.info");
			
			System.out.println(elem);
			
			// date
			for(Element date : elem) {
				String text = date.text();
				
				// : ~시간 전, ~분 전
				if(text.substring(1, text.length()).equals("시간 전") || text.substring(2, text.length()).equals("시간 전")) {
	            	dates.add(now.toString());	   
	            } 
				// : ~ 일 전 , ~7일 전
				else if(text.substring(1, text.length()).equals("일 전")){
	            	int day = Integer.parseInt(text.substring(0, 1));    

	            	cal.add(Calendar.DATE, (-1 * day));	   
	            	
	            	dates.add(df.format(cal.getTime()));            	            	
	            	// 날짜 초기화
	            	cal.add(Calendar.DATE, day);
	            	
	            }
				// yyyy-mm-dd 
				else {
	            	text.replace(".", "-");
	            	dates.add(text);
	            }
	        }
						
		}catch(Exception e) {			
			e.printStackTrace();
			return null;
		}
		result.add(dates);
		result.add(title);
		result.add(href);
		
		return result;				
	}
	
	
	public static void main(String[] args) {
		News news = new News("삼성전자", 1);
		ArrayList<ArrayList<String>> result = news.getNews();
		String date, title, url ,sql = "";
		for(int i=0;i<10;i++) {
			date = result.get(0).get(i);
			title = result.get(1).get(i);
			url = result.get(2).get(i);
			
			sql = "MERGE INTO NEWS " +
				  "USING DUAL ON(Ntitle = '" + title + "') " +
				  "WHEN NOT MATCHED THEN " +
				  "INSERT VALUES('" + date + "', '" + title + "', '" + url + "', '삼성전자');";
			
			System.out.println(sql);
		}
	}
}
