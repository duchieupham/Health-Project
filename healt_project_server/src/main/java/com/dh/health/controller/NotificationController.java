package com.dh.health.controller;

import java.sql.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.dh.health.dto.NotificationGetDTO;
import com.dh.health.dto.NotificationResponseDTO;
import com.dh.health.service.NotificationService;

@RestController
@RequestMapping("api/v1")
public class NotificationController {

	@Autowired
	NotificationService notiService;
	
	@GetMapping("notification/{accountId}")
	public ResponseEntity<List<NotificationResponseDTO>> getNotificationsByAccountId(@PathVariable(value="accountId") int accountId){
		List<NotificationResponseDTO> result = new ArrayList<>();
		HttpStatus httpStatus = null;
		try {
			if(accountId != 0) {
				Date now = new Date(Calendar.getInstance().getTimeInMillis());
				DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS");
				String nowString = dateFormat.format(now).toString();
				LocalDateTime currentDate= LocalDateTime.parse(nowString, formatter);
				List<NotificationGetDTO> listNotificationsGet = notiService.getNotificationsByAccountId(accountId);
				for (NotificationGetDTO notificationGetDTO : listNotificationsGet) {
					NotificationResponseDTO responseDTO = new NotificationResponseDTO();
					responseDTO.setId(notificationGetDTO.getId());
					responseDTO.setDescription(notificationGetDTO.getDescription());
					responseDTO.setKeyId(notificationGetDTO.getKeyId());
					responseDTO.setStatus(notificationGetDTO.getStatus());
					responseDTO.setTimeCreated(notificationGetDTO.getTimeCreated());
					responseDTO.setAccountId(notificationGetDTO.getAccountId());
					responseDTO.setKeyType(notificationGetDTO.getKeyType());
					responseDTO.setTypeName(notificationGetDTO.getTypeName());
					LocalDateTime dateCreated = LocalDateTime.parse(notificationGetDTO.getTimeCreated(), formatter);
					responseDTO.setLastMinute(java.time.Duration.between(dateCreated, currentDate).toMinutes());
					result.add(responseDTO);
				}
				httpStatus = HttpStatus.OK;
			}
		}catch(Exception e) {
			System.out.println("Error at get list noti: " + e.toString());
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<List<NotificationResponseDTO>>(result, httpStatus);
	}
	
	@GetMapping("notification/unread/{accountId}")
	public ResponseEntity<Integer> getUnreadCountNotificationByAccountId(@PathVariable(value="accountId") int accountId){
		Integer result = 0;
		HttpStatus httpStatus = null;
		try {
			if(accountId!=0) {
				result = notiService.getCountUnreadNotificationByAccountId(accountId);
				httpStatus = HttpStatus.OK;
			}
		}catch(Exception e) {
			System.out.println("Error at get count unread notificaiton: " + e.toString());
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<Integer>(result, httpStatus);
		
	}
	
	
	@PostMapping("notification/read")
	public ResponseEntity<Boolean> updateNotificationStatus(@Valid @RequestParam int id){
		boolean result= false;
		HttpStatus httpStatus = null;
		try {
			notiService.updateNotificationStatus(id);
    		result = true;
    		httpStatus = HttpStatus.OK;
    	} catch(Exception e) {
			httpStatus = HttpStatus.BAD_REQUEST;
    	}
		return new ResponseEntity<Boolean>(result, httpStatus);
	}
}
