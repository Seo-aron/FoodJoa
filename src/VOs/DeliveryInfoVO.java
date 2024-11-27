package VOs;

import java.sql.Timestamp;

public class DeliveryInfoVO {

	private String id;
	private String nickname;
	private String pictures;
	private String address;
	private int amount;
	private int delivered;
	private int refund;
	private int quantity;
	private String contents;
	private int category;
	private String price;
	private int stock;
	private Timestamp post_date;
	
	public DeliveryInfoVO() {
	}

	public DeliveryInfoVO(String id, String nickname, String pictures, String address, int amount, int delivered,
			int refund, int quantity, String contents, int category, String price, int stock, Timestamp post_date) {

		this(id, nickname, pictures, address, amount, delivered, refund, quantity, contents, category, price, stock);
		this.post_date = post_date;
	}

	public DeliveryInfoVO(String id, String nickname, String pictures, String address, int amount, int delivered,
			int refund, int quantity, String contents, int category, String price, int stock) {

		this.id = id;
		this.nickname = nickname;
		this.pictures = pictures;
		this.address = address;
		this.amount = amount;
		this.delivered = delivered;
		this.refund = refund;
		this.quantity = quantity;
		this.contents = contents;
		this.category = category;
		this.price = price;
		this.stock = stock;
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

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public String getContents() {
		return contents;
	}

	public void setContents(String contents) {
		this.contents = contents;
	}

	public int getCategory() {
		return category;
	}

	public void setCategory(int category) {
		this.category = category;
	}

	public String getPrice() {
		return price;
	}

	public void setPrice(String price) {
		this.price = price;
	}

	public int getStock() {
		return stock;
	}

	public void setStock(int stock) {
		this.stock = stock;
	}

	public Timestamp getPost_date() {
		return post_date;
	}

	public void setPost_date(Timestamp post_date) {
		this.post_date = post_date;
	}
}
