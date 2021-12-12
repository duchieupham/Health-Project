package com.dh.health.dto;

import java.io.Serializable;

public class LikeActionDTO implements Serializable{
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private int newsId;
	private int accountId;
	public LikeActionDTO() {
		super();
		// TODO Auto-generated constructor stub
	}
	public int getNewsId() {
		return newsId;
	}
	public void setNewsId(int newsId) {
		this.newsId = newsId;
	}
	public int getAccountId() {
		return accountId;
	}
	public void setAccountId(int accountId) {
		this.accountId = accountId;
	}
	
	
}
