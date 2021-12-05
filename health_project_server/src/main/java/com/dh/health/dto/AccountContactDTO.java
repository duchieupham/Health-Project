package com.dh.health.dto;

import java.io.Serializable;

public class AccountContactDTO implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int id;
	private String address;
	private String phone;
	public AccountContactDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	public AccountContactDTO(int id, String address, String phone) {
		super();
		this.id = id;
		this.address = address;
		this.phone = phone;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
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
	
	

}
