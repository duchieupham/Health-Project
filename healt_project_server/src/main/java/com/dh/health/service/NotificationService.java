package com.dh.health.service;


import java.util.List;

import org.springframework.stereotype.Service;

import com.dh.health.dto.NotificationGetDTO;
import com.dh.health.entity.NotificationEntity;

@Service
public interface NotificationService {
	
	public boolean createNotification(NotificationEntity dto);
	
	public List<NotificationGetDTO> getNotificationsByAccountId(int accountId);
	
	public int getCountUnreadNotificationByAccountId(int accountId);
	
	public void updateNotificationStatus(int id);
}
