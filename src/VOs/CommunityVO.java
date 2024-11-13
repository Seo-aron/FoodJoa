package VOs;

public class CommunityVO {
	
	private int no;
	private String id;
	private String title;
	private String contents;
	private int views;
	
	public CommunityVO() {
		
	}

	public CommunityVO(int no, String id, String title, String contents, int views) {
		super();
		this.no = no;
		this.id = id;
		this.title = title;
		this.contents = contents;
		this.views = views;
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

	public int getViews() {
		return views;
	}

	public void setViews(int views) {
		this.views = views;
	}
}

