package com.dh.health.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.Type;

@Entity
@Table(name = "NotificationType")
public class NotificationTypeEntity implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	  @Id
	  @Column(name = "id")
	  @GeneratedValue(strategy = GenerationType.IDENTITY)
	  private int id;
	
	  @Column(name = "type_name")
	  @Type(type="org.hibernate.type.StringNVarcharType")
	  private String title;
	  
	  @Column(name = "key_type")
	  private String keyType;
	  
	  

	public NotificationTypeEntity(int id) {
		super();
		this.id = id;
	}

	public NotificationTypeEntity() {
		super();
		// TODO Auto-generated constructor stub
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getKeyType() {
		return keyType;
	}

	public void setKeyType(String keyType) {
		this.keyType = keyType;
	}

	
	  
	  
	  
}
