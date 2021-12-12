package com.dh.health.dto;

import java.io.Serializable;


public class PersonalDTO implements Serializable{
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int accountId;
	private String firstname;
	private String lastname;
	private double height;
	private double weight;
	private String familyHealth;
	private String healthDescription;
	private String gender;
	private String address;
	private String phone;
	private String avatar;
	
	public PersonalDTO() {
		super();
	}
	
	public PersonalDTO(int accountId, String firstname, String lastname, double height, double weight,
			String familyHealth, String healthDescription, String gender, String address, String phone) {
		super();
		this.accountId = accountId;
		this.firstname = firstname;
		this.lastname = lastname;
		this.height = height;
		this.weight = weight;
		this.familyHealth = familyHealth;
		this.healthDescription = healthDescription;
		this.gender = gender;
		this.address = address;
		this.phone = phone;
	}
	
	public int getAccountId() {
		return accountId;
	}
	public void setAccountId(int accountId) {
		this.accountId = accountId;
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
	public double getHeight() {
		return height;
	}
	public void setHeight(double height) {
		this.height = height;
	}
	public double getWeight() {
		return weight;
	}
	public void setWeight(double weight) {
		this.weight = weight;
	}
	public String getFamilyHealth() {
		return familyHealth;
	}
	public void setFamilyHealth(String familyHealth) {
		this.familyHealth = familyHealth;
	}
	public String getHealthDescription() {
		return healthDescription;
	}
	public void setHealthDescription(String healthDescription) {
		this.healthDescription = healthDescription;
	}
	public String getGender() {
		return gender;
	}
	public void setGender(String gender) {
		this.gender = gender;
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
	

	
	
}
