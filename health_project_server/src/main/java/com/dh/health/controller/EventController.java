package com.dh.health.controller;

import java.sql.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.dh.health.dto.EventCreateDTO;
import com.dh.health.dto.EventDTO;
import com.dh.health.entity.AccountEntity;
import com.dh.health.entity.EventEntity;
import com.dh.health.entity.NotificationEntity;
import com.dh.health.entity.NotificationTypeEntity;
import com.dh.health.service.EventService;
import com.dh.health.service.NotificationService;
import com.dh.health.util.NotificationTypeUtil;

@RestController
@RequestMapping("api/v1")
public class EventController {

	@Autowired
	EventService eventService;
	
	@Autowired
	NotificationService notiService;
	
	@PostMapping("event")
	public ResponseEntity<String> createEvemt( @RequestBody EventCreateDTO eventDTO){
		String result = "";
		HttpStatus httpStatus = null;
		try {
			Date currentDate = new Date(Calendar.getInstance().getTimeInMillis());
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
			String timeCreated = dateFormat.format(currentDate).toString();
			EventEntity eventEntity = new EventEntity();
			eventEntity.setTimeCreated(timeCreated);
			eventEntity.setTimeEvent(eventDTO.getTimeEvent());
			eventEntity.setTitle(eventDTO.getTitle());
			eventEntity.setContent(eventDTO.getContent());
			eventEntity.setStatus(eventDTO.getStatus());
			eventEntity.setDoctor(new AccountEntity(eventDTO.getDoctorId()));
			eventEntity.setPatient(new AccountEntity(eventDTO.getPatientId()));
			boolean checkEvent = eventService.createEvent(eventEntity);
			//
			if(checkEvent) {
				
				NotificationTypeUtil notiUtil = new NotificationTypeUtil();
				EventEntity eventCreatedEntity = eventService.getEventByTimeAndTitle(timeCreated, eventDTO.getTimeEvent(), eventDTO.getDoctorId(), eventDTO.getPatientId());
				NotificationEntity notiEntity = new NotificationEntity();
				notiEntity.setDescription(notiUtil.getMsgCreateEvent() + " "+eventCreatedEntity.getTitle());
				notiEntity.setKey_id(eventCreatedEntity.getId());
				notiEntity.setStatus(notiUtil.getStatusUnread());
				notiEntity.setTimeCreated(timeCreated);
				notiEntity.setAccount(new AccountEntity(eventDTO.getPatientId()));
				notiEntity.setType(new NotificationTypeEntity(notiUtil.getKeyCalendar()));
				
				boolean checkNoti = notiService.createNotification(notiEntity);
				if(checkNoti) {
					result = "Create new event and insert notification successful";
					httpStatus = HttpStatus.OK;
				} else {
					result = "Create event success but insert notification failed";
					httpStatus = HttpStatus.BAD_REQUEST;
				}
			}else {
				result = "Create event failed";
				httpStatus = HttpStatus.BAD_REQUEST;
			}
		}catch(Exception e) {
			result = e.toString();
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return  new ResponseEntity<String>(result, httpStatus);
	}
	
	@GetMapping("events/{patientId}")
	public ResponseEntity<List<EventDTO>> getListEvent(@PathVariable(value="patientId")int patientId){
		List<EventDTO> result = new ArrayList<>();
		HttpStatus httpStatus = null;
		try {
			result = eventService.getEventsByPatientId(patientId);
			httpStatus = HttpStatus.OK;
		}catch(Exception e) {
			System.out.println("ERROR AT GET LIST EVENT: " + e.toString());
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<List<EventDTO>>(result, httpStatus);
	}
 }
