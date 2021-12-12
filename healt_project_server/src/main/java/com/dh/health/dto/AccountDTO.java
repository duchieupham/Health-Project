package com.dh.health.dto;

import java.io.Serializable;

import com.fasterxml.jackson.annotation.JsonProperty;

public class AccountDTO implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String username;
	private String password;
	private String phone;
	@JsonProperty
	private boolean isLoginPhone;
	public AccountDTO() {
		super();
	}
	public AccountDTO(String username, String password, String phone, boolean isLoginPhone) {
		super();
		this.username = username;
		this.password = password;
		this.phone = phone;
		this.isLoginPhone = isLoginPhone;
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
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public boolean isLoginPhone() {
		return isLoginPhone;
	}
	public void setPhoneLogin(boolean isLoginPhone) {
		this.isLoginPhone = isLoginPhone;
	}
	
	
}
