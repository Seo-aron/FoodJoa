package VOs;

import java.sql.Timestamp;

public class MealkitWishListVO {
	
    private int no;
	private String id;
	private int mealkitNo;
	private int type;
    private Timestamp choiceDate;
	
	public MealkitWishListVO(int no, String id, int mealkitNo, int type) {
		this.no = no;
		this.id = id;
		this.mealkitNo = mealkitNo;
		this.type = type;
	}

	public MealkitWishListVO(int no, String id, int mealkitNo, int type, Timestamp choiceDate) {
		super();
		this.no = no;
		this.id = id;
		this.mealkitNo = mealkitNo;
		this.type = type;
		this.choiceDate = choiceDate;
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

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public Timestamp getChoiceDate() {
		return choiceDate;
	}

	public void setChoiceDate(Timestamp choiceDate) {
		this.choiceDate = choiceDate;
	}

}
