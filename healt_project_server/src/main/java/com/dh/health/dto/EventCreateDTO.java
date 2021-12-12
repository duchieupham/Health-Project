package com.dh.health.dto;

import java.io.Serializable;

public class EventCreateDTO implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	private String title;
	private String content;
	private String timeEvent;
	private int doctorId;
	private int patientId;
	private String status;
	
	
	public EventCreateDTO(String title, String content, String timeEvent, int doctorId, int patientId, String status) {
		super();
		this.title = title;
		this.content = content;
		this.timeEvent = timeEvent;
		this.doctorId = doctorId;
		this.patientId = patientId;
		this.status = status;
	}
	
	public EventCreateDTO() {
		super();
		// TODO Auto-generated constructor stub
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

	public String getTimeEvent() {
		return timeEvent;
	}

	public void setTimeEvent(String timeEvent) {
		this.timeEvent = timeEvent;
	}

	public int getDoctorId() {
		return doctorId;
	}

	public void setDoctorId(int doctorId) {
		this.doctorId = doctorId;
	}

	public int getPatientId() {
		return patientId;
	}

	public void setPatientId(int patientId) {
		this.patientId = patientId;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
	
	
	
	
}
