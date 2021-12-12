package com.dh.health.entity;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

@Entity
@Table(name = "News")
public class NewsEntity implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	  @Id
	  @Column(name = "id")
	  @GeneratedValue(strategy = GenerationType.IDENTITY)
	  private int id;
	  
	  @ManyToOne
	  @JoinColumn(name = "cat_id")
	  private CategoryNewsEntity category;
	  
	  @Column(name = "title")
	  private String title;
	  
	  @Column(name = "paragraphs",columnDefinition = "TEXT")
	  private String paragraphs;
	  
	  @Column(name = "images")
	  private String image;
	  
	  @Column(name = "actor")
	  private String actor;
	  
	  @Column(name = "timeCreate")
	  private String timeCreate;
	  
	  @Column(name = "status")
	  private String status;
	  
	  @ManyToMany
	  Set<AccountEntity> accountLike = new HashSet<AccountEntity>();

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public CategoryNewsEntity getCategory() {
		return category;
	}

	public void setCategory(CategoryNewsEntity category) {
		this.category = category;
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

	public String getImage() {
		return image;
	}

	public void setImage(String image) {
		this.image = image;
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

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Set<AccountEntity> getAccountLike() {
		return accountLike;
	}

	public void setAccountLike(Set<AccountEntity> accountLike) {
		this.accountLike = accountLike;
	}
	  
}