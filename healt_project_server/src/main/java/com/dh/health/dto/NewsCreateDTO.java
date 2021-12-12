package com.dh.health.dto;

import java.io.Serializable;
import java.sql.Time;

public class NewsCreateDTO implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int catId;
	private String actor;
	private String paragraphs;
	private String status;
	private Time timeCreate;
	private String title;
	
	
	public NewsCreateDTO(int catId, String actor, String paragraphs, String status, Time timeCreate, String title) {
		super();
		this.catId = catId;
		this.actor = actor;
		this.paragraphs = paragraphs;
		this.status = status;
		this.timeCreate = timeCreate;
		this.title = title;
	}
	public NewsCreateDTO() {
		super();
	}
	
	
	public int getCatId() {
		return catId;
	}
	public void setCatId(int catId) {
		this.catId = catId;
	}
	public String getActor() {
		return actor;
	}
	public void setActor(String actor) {
		this.actor = actor;
	}
	public String getParagraphs() {
		return paragraphs;
	}
	public void setParagraphs(String paragraphs) {
		this.paragraphs = paragraphs;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public Time getTimeCreate() {
		return timeCreate;
	}
	public void setTimeCreate(Time timeCreate) {
		this.timeCreate = timeCreate;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public static long getSerialversionuid() {
		return serialVersionUID;
	}
	
	

}
