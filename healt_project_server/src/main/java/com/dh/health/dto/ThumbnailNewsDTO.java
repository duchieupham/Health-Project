package com.dh.health.dto;

import java.io.Serializable;

public class ThumbnailNewsDTO implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int newsId;
	private int catId;
	private String image;
	private String title;
	private String actor;
	private String timeCreated;
	private Long lastMinute;
	
	public ThumbnailNewsDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public int getNewsId() {
		return newsId;
	}
	

	public void setNewsId(int newsId) {
		this.newsId = newsId;
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

	public String getTimeCreated() {
		return timeCreated;
	}

	public void setTimeCreated(String timeCreated) {
		this.timeCreated = timeCreated;
	}

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public Long getLastMinute() {
		return lastMinute;
	}

	public void setLastMinute(Long lastMinute) {
		this.lastMinute = lastMinute;
	}
	
}
