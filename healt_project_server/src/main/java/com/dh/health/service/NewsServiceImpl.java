package com.dh.health.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dh.health.dto.LikeNewsDTO;
import com.dh.health.entity.NewsEntity;
import com.dh.health.repository.NewsRepository;

@Service
public class NewsServiceImpl implements NewsService{
	
	@Autowired
	NewsRepository newsRepo;

	@Override
	public boolean createNews(NewsEntity dto) {
		return newsRepo.save(dto) == null ? false : true;
	}

	@Override
	public List<NewsEntity> getAllNews() {
		List<NewsEntity> list = newsRepo.getAllNews();
		return list;
	}

	@Override
	public List<NewsEntity> getNewsByCat(int catId, int start, int row) {
		List<NewsEntity> list = newsRepo.getNewsByCat(catId, start, row);
		return list;
	}
	
	@Override
	public List<NewsEntity> getRelatedNews(int catId, int id) {
		List<NewsEntity> list = newsRepo.getRelatedNews(catId, id);
		return list;
	}

	@Override
	public NewsEntity getNewsById(int newsId) {
		return newsRepo.getNewsById(newsId);
	}

	@Override
	public void insertNewsLike(int newsId, int accountId) {
		newsRepo.insertNewsLike(newsId, accountId);
		
	}

	@Override
	public void deleteNewsLike(int newsId, int accountId) {
		newsRepo.deleteNewsLike(newsId, accountId);
	}

	@Override
	public List<NewsEntity> getThumbnailNews(int start, int row) {
		List<NewsEntity> list = newsRepo.getThumbnailNews(start, row);
		return list;
	}

	@Override
	public List<LikeNewsDTO> getLikeNews(int newsId) {
		List<LikeNewsDTO> list = newsRepo.getLikeNews(newsId);
		return list;
	}
	
}
