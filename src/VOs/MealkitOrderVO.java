package VOs;

import java.sql.Timestamp;

public class MealkitOrderVO {
	private int no;
    private String id;
    private int mealkitNo;
    private String address;
    private int delivered;
    private int refund;
    private Timestamp postDate;
    
    // postDate없는 생성자  
	public MealkitOrderVO(int no, String id, int mealkitNo, String address, int delivered, int refund) {

		this.no = no;
		this.id = id;
		this.mealkitNo = mealkitNo;
		this.address = address;
		this.delivered = delivered;
		this.refund = refund;
	}

	public MealkitOrderVO(int no, String id, int mealkitNo, int amount, String address, int delivered, int refund,
			Timestamp postDate) {

		this(no, id, mealkitNo, address, delivered, refund);
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

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getDelivered() {
		return delivered;
	}

	public void setDelivered(int delivered) {
		this.delivered = delivered;
	}

	public int getRefund() {
		return refund;
	}

	public void setRefund(int refund) {
		this.refund = refund;
	}

	public Timestamp getPostDate() {
		return postDate;
	}

	public void setPostDate(Timestamp postDate) {
		this.postDate = postDate;
	}

}
