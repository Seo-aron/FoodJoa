package VOs;

import java.sql.Timestamp;

public class MemberVO {
   private String id;
   private String name;
   private String nickname;
   private String phone;
   private String address;
   private String profile;
   private Timestamp joinDate;

   // joinDate 없는 생성자
   public MemberVO(String id, String name, String nickname, 
         String phone, String address, String profile) {
      this.id = id;
      this.name = name;
      this.nickname = nickname;
      this.phone = phone;
      this.address = address;
      this.profile = profile;
   }

   // joinDate 포함된 생성자
   public MemberVO(String id, String name, String nickname, 
         String phone, String address, String profile, Timestamp joinDate) {
      this.id = id;
      this.name = name;
      this.nickname = nickname;
      this.phone = phone;
      this.address = address;
      this.profile = profile;
      this.joinDate = joinDate;
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

   public Timestamp getJoinDate() {
      return joinDate;
   }

   public void setJoinDate(Timestamp joinDate) {
      this.joinDate = joinDate;
   }
}
