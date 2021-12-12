package com.dh.health.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dh.health.entity.CategoryNewsEntity;
import com.dh.health.repository.CategoryNewsRepository;

@Service
public class CategoryNewsServiceImpl implements CategoryNewsService {

	@Autowired
	CategoryNewsRepository catRepo;
	
	@Override
	public boolean createCategoryNews(CategoryNewsEntity dto) {
		// TODO Auto-generated method stub
		return catRepo.save(dto) == null ? false: true;
	}
	
	
	@Override
	public List<CategoryNewsEntity> getAllCategoryNews() {
		List<CategoryNewsEntity> list = catRepo.findAll();
		return list;
	}
}
