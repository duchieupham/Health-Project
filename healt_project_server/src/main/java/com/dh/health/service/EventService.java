package com.dh.health.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.dh.health.dto.EventDTO;
import com.dh.health.entity.EventEntity;

@Service
public interface EventService {

	public boolean createEvent(EventEntity event);
	
	public List<EventDTO> getEventsByPatientId(int patientId);
	
	public EventEntity getEventByTimeAndTitle(String timeCreated, String timeEvent, int doctorId, int patientId);
	
	public List<EventDTO> getEventsByDate(int patientId, String date);
	
	public List<EventDTO> getEventsFromDateToDate(int patientId, String fromDate, String toDate);
	
	
	
}
