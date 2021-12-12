package com.dh.health.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import org.hibernate.annotations.Type;

@Entity
@Table(name = "Notification")
public class NotificationEntity implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	  @Id
	  @Column(name = "id")
	  @GeneratedValue(strategy = GenerationType.IDENTITY)
	  private int id;
	  
	  @ManyToOne
	  @JoinColumn(name = "type_id")
	  private NotificationTypeEntity type;
	  
	  @ManyToOne
	  @JoinColumn(name = "account_id")
	  private AccountEntity account;
	  
	  @Column(name = "description")
	  @Type(type="org.hibernate.type.StringNVarcharType")
	  private String description;
	  
	  @Column(name = "key_id")
	  private int key_id;
	  
	  @Column(name = "timeCreated")
	  private String timeCreated;
	  
	  @Column(name = "status")
	  private String status;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public NotificationTypeEntity getType() {
		return type;
	}

	public void setType(NotificationTypeEntity type) {
		this.type = type;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getKey_id() {
		return key_id;
	}

	public void setKey_id(int key_id) {
		this.key_id = key_id;
	}

	public String getTimeCreated() {
		return timeCreated;
	}

	public void setTimeCreated(String timeCreated) {
		this.timeCreated = timeCreated;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public AccountEntity getAccount() {
		return account;
	}

	public void setAccount(AccountEntity account) {
		this.account = account;
	}
	
	  
}
