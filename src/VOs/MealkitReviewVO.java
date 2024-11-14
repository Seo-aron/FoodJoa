package VOs;

import java.sql.Timestamp;

public class MealkitReviewVO {
    
    private int no;
	private String id;
	private int mealkitNo;
	private String pictures;
	private String contents;
	private int rating;
	private int empathy;
	private Timestamp postDate;
	
	public MealkitReviewVO() {}
	
	public MealkitReviewVO(int no, String id, int mealkitNo, String pictures, 
			String contents, int rating, int empathy) {
		
		this.no = no;
		this.id = id;
		this.mealkitNo = mealkitNo;
		this.pictures = pictures;
		this.contents = contents;
		this.rating = rating;
		this.empathy = empathy;
	}

	public MealkitReviewVO(int no, String id, int mealkitNo, String pictures, 
			String contents, int rating, int empathy, Timestamp postDate) {
		
		this(no, id, mealkitNo, pictures, contents, rating, empathy);
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

	public int getMealkitNo() {
		return mealkitNo;
	}

	public void setMealkitNo(int mealkitNo) {
		this.mealkitNo = mealkitNo;
	}

	public String getPictures() {
		return pictures;
	}

	public void setPictures(String pictures) {
		this.pictures = pictures;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	public float getRating() {
		return rating;
	}

	public void setRating(int rating) {
		this.rating = rating;
	}

	public int getEmpathy() {
		return empathy;
	}

	public void setEmpathy(int empathy) {
		this.empathy = empathy;
	}

	public Timestamp getPostDate() {
		return postDate;
	}

	public void setPostDate(Timestamp postDate) {
		this.postDate = postDate;
	}
	
}
