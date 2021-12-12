package com.dh.health.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dh.health.dto.EventDTO;
import com.dh.health.entity.EventEntity;
import com.dh.health.repository.EventRepository;

@Service
public class EventServiceImpl implements EventService{
	
	@Autowired
	EventRepository eventRepo;
	
	@Override
	public boolean createEvent(EventEntity event) {
		return eventRepo.save(event) == null ? false : true;
	}

	@Override
	public List<EventDTO> getEventsByPatientId(int patientId) {
		List<EventDTO> list =eventRepo.getEventsByPatientId(patientId);
		return list;
	}

	@Override
	public EventEntity getEventByTimeAndTitle(String timeCreated, String timeEvent, int doctorId, int patientId) {
		return eventRepo.getEventById(timeCreated, timeEvent, doctorId, patientId);
	}

	@Override
	public List<EventDTO> getEventsByDate(int patientId, String date) {
		return eventRepo.getEventsByDate(patientId, date);
	}

	@Override
	public List<EventDTO> getEventsFromDateToDate(int patientId, String fromDate, String toDate) {
		return eventRepo.getEventsFromDateToDate(patientId, fromDate, toDate);
	}

}
