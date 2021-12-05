package com.dh.health.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dh.health.dto.NotificationGetDTO;
import com.dh.health.entity.NotificationEntity;
import com.dh.health.repository.NotificationRepository;

@Service
public class NotificationServiceImpl implements NotificationService{
	
	@Autowired
	NotificationRepository notiRepo;

	@Override
	public boolean createNotification(NotificationEntity dto) {
		System.out.println("go to noti service and create noti function");
		return notiRepo.save(dto) == null ? false : true;
	}

	@Override
	public List<NotificationGetDTO> getNotificationsByAccountId(int accountId) {
		List<NotificationGetDTO> list = notiRepo.getNotificationsByAccountId(accountId);
		return list;
	}

	@Override
	public int getCountUnreadNotificationByAccountId(int accountId) {
		return notiRepo.getCountUnreadNotificationByAccountId(accountId);
	}

	@Override
	public void updateNotificationStatus(int id) {
		notiRepo.updateNotificationStatus(id);
	}

}
