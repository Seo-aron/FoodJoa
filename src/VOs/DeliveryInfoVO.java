package VOs;

public class DeliveryInfoVO {

	private String id;
	private String nickname;
	private String pictures;
	private String address;
	private int amount;
	private int delivered;
	private int refund;
	
	public DeliveryInfoVO() {
	}

	public DeliveryInfoVO(String id, String nickname, String pictures, String address, int amount, int delivered,
			int refund) {

		this.id = id;
		this.nickname = nickname;
		this.pictures = pictures;
		this.address = address;
		this.amount = amount;
		this.delivered = delivered;
		this.refund = refund;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getPictures() {
		return pictures;
	}

	public void setPictures(String pictures) {
		this.pictures = pictures;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public int getAmount() {
		return amount;
	}

	public void setAmount(int amount) {
		this.amount = amount;
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
}
