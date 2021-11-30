	public void insertNews(List<String> dates, List<String> title, List<String> each_url, String companyName) {
		
		for(int i = 0; i < title.size(); i++) {
			System.out.println(dates.get(i));
			System.out.println(title.get(i));
			System.out.println(each_url.get(i));
		}
		
		String sql = "";
		
		try {
			
			for(int i = 0; i < title.size(); i++) {
				sql = "INSERT INTO NEWS ( Nwhen, Ntitle, Nurl, Ncompany ) " + 
					 	 "SELECT '" + dates.get(i) + "', '" + title.get(i) + "', '" + each_url.get(i) + "', '" + companyName + "' FROM DUAL A " +
					 	 "WHERE NOT EXISTS " +
					 	 "(SELECT Nwhen, Ntitle, Nurl, Ncompany FROM NEWS " +
					 	 "WHERE Nurl = '" + each_url.get(i) + "') ";
				System.out.println(sql);
				pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
				rs = pstmt.executeQuery(); 
			}
			
			commit();
			
		} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		}
	
	}
