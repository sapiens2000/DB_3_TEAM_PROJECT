package phase4;

public class SearchOption {
	private static SearchOption option;
	
	private String minPrice;
	private String maxPrice;
	private String marketCap;
	private String marketCapUp;
	private String foreign;
	private String foreignUp;
	private String per;
	private String perUp;
	private String pbr;
	private String pbrUp;
	private String roe;
	private String roeUp;
	
	private SearchOption() {}
	
	public static synchronized SearchOption getOptionInstance() {
		if(option == null) {
			option = new SearchOption();
		}
		return option;
	}

	public String getMinPrice() {
		return minPrice;
	}

	public void setMinPrice(String minPrice) {
		this.minPrice = minPrice;
	}

	public String getMaxPrice() {
		return maxPrice;
	}

	public void setMaxPrice(String maxPrice) {
		this.maxPrice = maxPrice;
	}

	public String getMarketCap() {
		return marketCap;
	}

	public void setMarketCap(String marketCap) {
		this.marketCap = marketCap;
	}

	public String getMarketCapUp() {
		return marketCapUp;
	}

	public void setMarketCapUp(String marketCapUp) {
		this.marketCapUp = marketCapUp;
	}

	public String getForeign() {
		return foreign;
	}

	public void setForeign(String foreign) {
		this.foreign = foreign;
	}

	public String getForeignUp() {
		return foreignUp;
	}

	public void setForeignUp(String foreignUp) {
		this.foreignUp = foreignUp;
	}

	public String getPer() {
		return per;
	}

	public void setPer(String per) {
		this.per = per;
	}

	public String getPerUp() {
		return perUp;
	}

	public void setPerUp(String perUp) {
		this.perUp = perUp;
	}

	public String getPbr() {
		return pbr;
	}

	public void setPbr(String pbr) {
		this.pbr = pbr;
	}

	public String getPbrUp() {
		return pbrUp;
	}

	public void setPbrUp(String pbrUp) {
		this.pbrUp = pbrUp;
	}

	public String getRoe() {
		return roe;
	}

	public void setRoe(String roe) {
		this.roe = roe;
	}

	public String getRoeUp() {
		return roeUp;
	}

	public void setRoeUp(String roeUp) {
		this.roeUp = roeUp;
	}
	
	

}
