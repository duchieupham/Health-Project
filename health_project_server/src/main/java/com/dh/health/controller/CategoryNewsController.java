package com.dh.health.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.dh.health.entity.CategoryNewsEntity;
import com.dh.health.service.CategoryNewsService;
import com.dh.health.util.FileUploadUtil;

@RestController
@RequestMapping("api/v1")
public class CategoryNewsController {
	@Autowired
	CategoryNewsService catService;
	
	@PostMapping("category")
	public ResponseEntity<String> createCategoryNews(@Valid @RequestParam String typeName, @Valid @RequestParam String description, @Valid @RequestParam MultipartFile image){
		String result = "";
    	HttpStatus httpStatus = null;
    	try {
    		String fileName = StringUtils.cleanPath(image.getOriginalFilename());
    		FileUploadUtil.saveFile("src/main/webapp/WEB-INF/images", fileName, image);
    		//
    		CategoryNewsEntity entity = new CategoryNewsEntity();
    		entity.setTypeName(typeName);
    		entity.setImage(fileName);
    		entity.setDescription(description);
    		boolean check = catService.createCategoryNews(entity);
    		if(check) {
    			result = "create category successful";
        		httpStatus = HttpStatus.OK;
    		}    		
    	}catch(Exception e) {
    		result = e.toString();
			httpStatus = HttpStatus.BAD_REQUEST;
    	}
    	return new ResponseEntity<String>(result, httpStatus);
	}
	
	@GetMapping("category")
	public ResponseEntity<List<CategoryNewsEntity>> getAllCatergoryNews(HttpServletRequest request)  {
		List<CategoryNewsEntity> result = null;
		HttpStatus httpStatus = null;
		try
		{
		 result = catService.getAllCategoryNews();
		 httpStatus = HttpStatus.OK;
		}catch(Exception e) {
			httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
		}
		return new ResponseEntity<List<CategoryNewsEntity>>(result, httpStatus);
	}
}
