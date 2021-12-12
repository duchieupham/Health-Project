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
@Table(name = "Event")
public class EventEntity implements Serializable {

	 /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	  @Id
	  @Column(name = "id")
	  @GeneratedValue(strategy = GenerationType.IDENTITY)
	  private int id;
	  
	  @ManyToOne
	  @JoinColumn(name ="doctor_id")
	  private AccountEntity doctor;
	  
	  @ManyToOne
	  @JoinColumn(name ="patient_id")
	  private AccountEntity patient;
	  
	  @Column(name = "timeCreated")
	  private String timeCreated;
	  
	  @Column(name = "timeEvent")
	  private String timeEvent;
	  
	  @Column(name = "title")
	  @Type(type="org.hibernate.type.StringNVarcharType")
	  private String title;
	  
	  @Column(name = "content")
	  @Type(type="org.hibernate.type.StringNVarcharType")
	  private String content;
	  
	  @Column(name = "status")
	  private String status;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public AccountEntity getDoctor() {
		return doctor;
	}

	public void setDoctor(AccountEntity doctor) {
		this.doctor = doctor;
	}

	public AccountEntity getPatient() {
		return patient;
	}

	public void setPatient(AccountEntity patient) {
		this.patient = patient;
	}

	public String getTimeCreated() {
		return timeCreated;
	}

	public void setTimeCreated(String timeCreated) {
		this.timeCreated = timeCreated;
	}

	public String getTimeEvent() {
		return timeEvent;
	}

	public void setTimeEvent(String timeEvent) {
		this.timeEvent = timeEvent;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	  
	  
	  
}
