package com.dh.health.service;

import org.springframework.stereotype.Service;

import com.dh.health.dto.BMIGetDTO;
import com.dh.health.entity.PersonalHealthEntity;

@Service
public interface PersonalHealthService {

	public PersonalHealthEntity getByAccId(int accountId);
	
	public BMIGetDTO getBMIInformation(int accountId);
	
	public int updateBMI(double height, double weight, String gender, int id);
}
