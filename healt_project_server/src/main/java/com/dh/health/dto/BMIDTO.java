package com.dh.health.dto;


public class BMIDTO{
	
	
	private int id;
	
	private double height;
	
	private double weight;
	
	private String gender;
	
	public BMIDTO(int id, double height, double weight, String gender) {
		super();
		this.id = id;
		this.height = height;
		this.weight = weight;
		this.gender = gender;
	};
	
	
	public Integer getId() {
		return id;
	};
	public Double getHeight() {
		return height;
	};
	public Double getWeight() {
		return weight;
	};
	public String getGender() {
		return gender;
	}
}
