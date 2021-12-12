package com.dh.health.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.dh.health.entity.CategoryNewsEntity;

@Service
public interface CategoryNewsService {
	
	public boolean createCategoryNews(CategoryNewsEntity dto);
	
	public List<CategoryNewsEntity> getAllCategoryNews();
}
