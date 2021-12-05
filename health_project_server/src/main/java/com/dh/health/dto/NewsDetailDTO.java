package com.dh.health.dto;

import java.io.Serializable;

public class NewsDetailDTO implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private int newsId;
	private int categoryId;
	private String categoryType;
	private String title;
	private String paragraphs;
	private String images;
	private String actor;
	private String timeCreate;
	//
	
	public NewsDetailDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	//
	public int getNewsId() {
		return newsId;
	}
	public void setNewsId(int newsId) {
		this.newsId = newsId;
	}
	public int getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(int categoryId) {
		this.categoryId = categoryId;
	}
	public String getCategoryType() {
		return categoryType;
	}
	public void setCategoryType(String categoryType) {
		this.categoryType = categoryType;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getParagraphs() {
		return paragraphs;
	}
	public void setParagraphs(String paragraphs) {
		this.paragraphs = paragraphs;
	}
	public String getImages() {
		return images;
	}
	public void setImages(String images) {
		this.images = images;
	}
	public String getActor() {
		return actor;
	}
	public void setActor(String actor) {
		this.actor = actor;
	}
	public String getTimeCreate() {
		return timeCreate;
	}
	public void setTimeCreate(String timeCreate) {
		this.timeCreate = timeCreate;
	}
	
	
}
