package VOs;

import java.sql.Timestamp;

public class CommunityShareVO {
	private int no;
	private String id;
	private String title;
	private String contents;
	private String address;
	private int type;
	private int views;
	private Timestamp postDate;
	
	public CommunityShareVO() {

	}

	public CommunityShareVO(int no, String id, String title, String contents, String address, int type, int views) {
		this.no = no;
		this.id = id;
		this.title = title;
		this.contents = contents;
		this.address = address;
		this.type = type;
		this.views = views;
	}

	public CommunityShareVO(int no, String id, String title, String contents, String address, int type, int views,
			Timestamp postDate) {
		this(no, id, title, contents, address, type, views);
		this.postDate = postDate;
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

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public int getViews() {
		return views;
	}

	public void setViews(int views) {
		this.views = views;
	}

	public Timestamp getPostDate() {
		return postDate;
	}

	public void setPostDate(Timestamp postDate) {
		this.postDate = postDate;
	}
	
}

