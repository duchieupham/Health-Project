package com.dh.health.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dh.health.dto.BMIGetDTO;
import com.dh.health.entity.PersonalHealthEntity;
import com.dh.health.repository.PersonalHealthRepository;

@Service
public class PersonalHealthServiceImpl implements PersonalHealthService {

	@Autowired
	PersonalHealthRepository personalRepo;
	
	@Override
	public PersonalHealthEntity getByAccId(int accountId) {
		PersonalHealthEntity personal = personalRepo.getPersonalHealthByAccId(accountId);
		return personal;
	}

	@Override
	public BMIGetDTO getBMIInformation(int accountId) {
		return personalRepo.getBmiInformation(accountId);
	}

	@Override
	public int updateBMI(double height, double weight, String gender, int id) {
		return personalRepo.updateBMI(height, weight, gender, id);
	}
	
	
}
