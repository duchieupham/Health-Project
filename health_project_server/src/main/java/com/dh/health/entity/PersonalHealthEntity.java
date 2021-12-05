package com.dh.health.entity;

import java.io.Serializable;

import javax.persistence.*;

@Entity
@Table(name = "PersonalHealth")
public class PersonalHealthEntity implements Serializable {

	 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;


	  @Id
	  @Column(name = "id")
	  @GeneratedValue(strategy = GenerationType.IDENTITY)
	  private int id;
	  
	  @OneToOne
	  @JoinColumn(name = "account_id")
	  private AccountEntity account;
	  
	  @Column(name = "height")
	  private double height;
	  
	  @Column(name = "weight")
	  private double weight;
	  
	  @Column(name = "healthDescription")
	  private String healthDescription;
	  
	  
	  @Column(name = "familyHealth")
	  private String familyHealth;
	  
	  @Column(name = "gender")
	  private String gender;
	  
	  @Column(name = "birthday")
	  private String birthday;
	  


	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public AccountEntity getAccount() {
		return account;
	}

	public void setAccount(AccountEntity account) {
		this.account = account;
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

	public String getHealthDescription() {
		return healthDescription;
	}

	public void setHealthDescription(String healthDescription) {
		this.healthDescription = healthDescription;
	}

	public String getFamilyHealth() {
		return familyHealth;
	}

	public void setFamilyHealth(String familyHealth) {
		this.familyHealth = familyHealth;
	}

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}
	  
	    
}
