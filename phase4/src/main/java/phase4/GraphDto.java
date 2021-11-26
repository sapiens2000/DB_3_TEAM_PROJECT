package phase4;

public class GraphDto {
	
	long date;
	double high;
	double low;
	double open;
	double close;
	
	
	public GraphDto(long date, double high, double low, double open, double close) {
		this.date = date;
		this.high = high;
		this.low = low;
		this.open = open;
		this.close = close;
	}
	
	public long getDate() {
		return date;
	}
	public void setDate(long date) {
		this.date = date;
	}
	public double getHigh() {
		return high;
	}
	public void setHigh(double high) {
		this.high = high;
	}
	public double getLow() {
		return low;
	}
	public void setLow(double low) {
		this.low = low;
	}
	public double getOpen() {
		return open;
	}
	public void setOpen(double open) {
		this.open = open;
	}
	public double getClose() {
		return close;
	}
	public void setClose(double close) {
		this.close = close;
	}

	@Override
	public String toString() {
		return "{ \"date\":" + date + ", \"high\":" + high + ", \"low\":" + low + ", \"open\":" + open +
			 	  ", \"close\":" + close + " } ";
	}
	
	
	
}