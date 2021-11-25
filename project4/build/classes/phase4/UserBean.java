package phase4;

public class UserBean {
		
	private String userId;
	private String userPw;
	private int uNum;
	private int current_total_asset;
	private int Cash;
	private int age;
	private String gender;
	private String email;
	private String cell_phone_num;
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getUserPw() {
		return userPw;
	}
	public void setUserPw(String userPw) {
		this.userPw = userPw;
	}
	public int getuNum() {
		return uNum;
	}
	public void setuNum(int uNum) {
		this.uNum = uNum;
	}
	public int getCurrent_total_asset() {
		return current_total_asset;
	}
	public void setCurrent_total_asset(int current_total_asset) {
		this.current_total_asset = current_total_asset;
	}
	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone_num() {
		return cell_phone_num;
	}
	public void setPhone_num(String cell_phone_num) {
		this.cell_phone_num = cell_phone_num;
	}
	public int getCash() {
		return Cash;
	}
	public void setCash(int uCash) {
		this.Cash = uCash;
	}
	
}
