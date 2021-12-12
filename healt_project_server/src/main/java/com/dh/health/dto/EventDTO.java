package com.dh.health.dto;

public interface EventDTO {
	Integer getId();
	String getContent();
	String getStatus();
	String getTimeCreated();
	String getTimeEvent();
	String getTitle();
	Integer getDoctorId();
	Integer getPatientId();
	String getDFirstname();
	String getDLastname();
	String getPhone();
	String getAvatar();
	String getEmail();
	String getWorkLocation();
	String getLongtitude();
	String getLatitude();
}
