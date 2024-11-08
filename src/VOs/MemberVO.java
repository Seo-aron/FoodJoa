package VOs;

import java.sql.Timestamp;

public class MemberVO {
	private String id;
	private String name;
	private String nickname;
	private String phone;
	private String address;
	private String profile;
	private Timestamp join_date;

	// join_date 없는 생성자
	public MemberVO(String id, String name, String nickname, String phone, String address, String profile) {
		this.id = id;
		this.name = name;
		this.nickname = nickname;
		this.phone = phone;
		this.address = address;
		this.profile = profile;
	}

	// join_date 포함된 생성자
	public MemberVO(String id, String name, String nickname, String phone, String address, String profile,
			Timestamp join_date) {
		this.id = id;
		this.name = name;
		this.nickname = nickname;
		this.phone = phone;
		this.address = address;
		this.profile = profile;
		this.join_date = join_date;
	}

	// Getters and Setters
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getProfile() {
		return profile;
	}

	public void setProfile(String profile) {
		this.profile = profile;
	}

	public Timestamp getJoin_date() {
		return join_date;
	}

	public void setJoin_date(Timestamp join_date) {
		this.join_date = join_date;
	}


}
