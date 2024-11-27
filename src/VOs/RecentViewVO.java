package VOs;

import java.sql.Timestamp;

public class RecentViewVO {
	
	private int no;
	private String id;
	private int item_no;
	private int type;
	private Timestamp viewed_at;
	
	public RecentViewVO() {}
	
	public RecentViewVO(int no, String id, int item_no, int type) {
		
		this.no = no;
		this.id = id;
		this.item_no = item_no;
		this.type = type;
	}
	
	public RecentViewVO(int no, String id, int item_no, int type, Timestamp viewed_at) {
			
			this(no, id, item_no, type);
			this.viewed_at = viewed_at;
		}

	public int getNo() {
		return no;
	}

	public void setNo(int no) {
		this.no = no;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public int getItem_no() {
		return item_no;
	}

	public void setItem_no(int item_no) {
		this.item_no = item_no;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public Timestamp getViewed_at() {
		return viewed_at;
	}

	public void setViewed_at(Timestamp viewed_at) {
		this.viewed_at = viewed_at;
	}
	
	
	

}
