package com.dh.health.controller;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.dh.health.dto.BMIDTO;
import com.dh.health.dto.BMIGetDTO;
import com.dh.health.service.PersonalHealthService;

@RestController
@RequestMapping("api/v1")
public class PersonalHealthController {
	
	@Autowired
	PersonalHealthService personalService;
	
	
	@GetMapping("personal/bmi")
	public ResponseEntity<BMIGetDTO> getBMIInformation(@Valid @RequestParam Integer id)  {
		BMIGetDTO result = null;
	HttpStatus httpStatus = null;
	try
	{
		if(id != 0) {
			result = personalService.getBMIInformation(id);
			if(result.getId()!=0) {
				httpStatus = HttpStatus.OK;
			}
		}
	}catch(Exception e) {
		httpStatus = HttpStatus.BAD_REQUEST;
	}
	return new ResponseEntity<BMIGetDTO>(result, httpStatus);
	}
	
	@PostMapping("personal/bmi")
	public ResponseEntity<String> updateBMI(@Valid @RequestBody BMIDTO dto)  {
		String result = "";
		HttpStatus httpStatus = null;
		try
		{	
			if(dto.getId()!=0) {
				int statement = personalService.updateBMI(dto.getHeight(), dto.getWeight(), dto.getGender(), dto.getId());
				if(statement==1) {
				result = "Update BMI successful";
				httpStatus = HttpStatus.OK;
				}
			}else {
				result = "Update Error";
				httpStatus = HttpStatus.NOT_MODIFIED;
			}
			
		}catch(Exception e) {
			result = "Exception: " + e.toString();
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<String>(result, httpStatus);
		}
}
