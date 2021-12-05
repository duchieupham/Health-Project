package com.dh.health.entity;


import java.io.Serializable;

import javax.persistence.*;

@Entity
@Table(name = "Account")
public class AccountEntity implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	  @Id
	  @Column(name = "id")
	  @GeneratedValue(strategy = GenerationType.IDENTITY)
	  private int id;
	  
	  @Column(name = "username")
	  private String username;
	  
	  @Column(name = "password")
	  private String password;
	  
	  @Column(name = "role")
	  private String role;
	  
	  @Column(name = "pin")
	  private String pin;
	  
	  @Column(name = "firstname")
	  private String firstname;
	  
	  @Column(name = "lastname")
	  private String lastname;
	  
	  @Column(name = "address")
	  private  String address;
	  
	  @Column(name = "phone")
	  private String phone;
	  
	  @Column(name = "avatar")
	  private String avatar;
	  
	  @Column(name = "deviceToken")
	  private String deviceToken;
	  
//	  @ManyToMany
//	  @JoinTable(name = "LikeNews", joinColumns = @JoinColumn(name ="account_id"), inverseJoinColumns = @JoinColumn(name = "news_id"))
//	  private Collection<NewsEntity> news;
//	  
	  public AccountEntity(int id) {
			super();
			this.id = id;
	}

	  
	  

	public AccountEntity() {
		super();
		// TODO Auto-generated constructor stub
	}




	public int getId() {
		return id;
	}

	
	public void setId(int id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getPin() {
		return pin;
	}

	public void setPin(String pin) {
		this.pin = pin;
	}

	public String getFirstname() {
		return firstname;
	}

	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}

	public String getLastname() {
		return lastname;
	}

	public void setLastname(String lastname) {
		this.lastname = lastname;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getAvatar() {
		return avatar;
	}

	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}

	public String getDeviceToken() {
		return deviceToken;
	}

	public void setDeviceToken(String deviceToken) {
		this.deviceToken = deviceToken;
	}

	
}
