package com.dh.health.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.dh.health.dto.LikeNewsDTO;
import com.dh.health.entity.NewsEntity;

@Service
public interface NewsService {
	
	public boolean createNews(NewsEntity dto);
	
	public List<NewsEntity> getAllNews();
	
	public List<NewsEntity> getNewsByCat(int catId, int start, int row);
	
	public NewsEntity getNewsById(int newsId);
	
	public void insertNewsLike(int newsId, int accountId);
	
	public void deleteNewsLike(int newsId, int accountId);
	
	public List<NewsEntity> getThumbnailNews(int start, int row);
	
	public List<LikeNewsDTO> getLikeNews(int newsId);
	
	public List<NewsEntity> getRelatedNews(int catId, int id);
}
