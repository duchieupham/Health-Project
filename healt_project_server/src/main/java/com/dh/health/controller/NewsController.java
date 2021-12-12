package com.dh.health.controller;

import java.sql.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.dh.health.dto.LikeActionDTO;
import com.dh.health.dto.LikeNewsDTO;
import com.dh.health.dto.NewsCreateDTO;
import com.dh.health.dto.NewsDetailDTO;
import com.dh.health.dto.ThumbnailNewsDTO;
import com.dh.health.entity.CategoryNewsEntity;
import com.dh.health.entity.NewsEntity;
import com.dh.health.service.NewsService;
import com.dh.health.util.FileUploadUtil;

@RestController
@RequestMapping("api/v1")
public class NewsController {

	@Autowired
	NewsService newsService;
	
	@PostMapping("news")
	public ResponseEntity<String> createNews(@ModelAttribute NewsCreateDTO newsDTO,@Valid @RequestParam List<MultipartFile> images){
		String result  = "";
		HttpStatus httpStatus = null;
		try {
			List<String> imageNames = new ArrayList<>();
			for (MultipartFile image: images) {
				FileUploadUtil.saveFile("src/main/webapp/WEB-INF/images", StringUtils.cleanPath(image.getOriginalFilename()), image);
				imageNames.add(StringUtils.cleanPath(image.getOriginalFilename()));
			}
			String imgList = "";
			for (String imgName : imageNames) {
				imgList += imgName + ";";
			}
	
			Date currentDate = new Date(Calendar.getInstance().getTimeInMillis());
			DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
			NewsEntity newsEntity = new NewsEntity();
			newsEntity.setActor(newsDTO.getActor());
			newsEntity.setCategory(new CategoryNewsEntity(newsDTO.getCatId()));
			newsEntity.setTitle(newsDTO.getTitle());
			newsEntity.setParagraphs(newsDTO.getParagraphs());
			newsEntity.setImage(imgList.trim().substring(0, imgList.length()-1));
			newsEntity.setTimeCreate(dateFormat.format(currentDate).toString());
			newsEntity.setStatus(newsDTO.getStatus());
			boolean check  = newsService.createNews(newsEntity);
			if(check) {
				result = "create news successful";
				httpStatus = HttpStatus.OK;
			}
			}catch(Exception e) {
			result = e.toString();
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<String>(result, httpStatus);
	}

	@GetMapping("news/thumbnail/{catId}/{start}/{row}")
	public ResponseEntity<List<ThumbnailNewsDTO>> getThumbnailNewsByCatId(@PathVariable(value="catId") int catId,@PathVariable(value="start")int start, @PathVariable(value="row")int row){
		List<ThumbnailNewsDTO> result =  new ArrayList<ThumbnailNewsDTO>();
		HttpStatus httpStatus = null;
		try {
			if(catId !=0) {
				Date now = new Date(Calendar.getInstance().getTimeInMillis());
				DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS");
				String nowString = dateFormat.format(now).toString();
				LocalDateTime currentDate= LocalDateTime.parse(nowString, formatter);
				List<NewsEntity> listNews = newsService.getNewsByCat(catId, start, row);
				for (NewsEntity newsEntity : listNews) {
					ThumbnailNewsDTO thumbnail = new ThumbnailNewsDTO();
					thumbnail.setNewsId(newsEntity.getId());
					thumbnail.setCatId(newsEntity.getCategory().getId());
					thumbnail.setImage(newsEntity.getImage().split(";")[0]);
					thumbnail.setTitle(newsEntity.getTitle());
					thumbnail.setActor(newsEntity.getActor());
					thumbnail.setTimeCreated(newsEntity.getTimeCreate());
					LocalDateTime dateCreated = LocalDateTime.parse(newsEntity.getTimeCreate(), formatter);
					thumbnail.setLastMinute(java.time.Duration.between(dateCreated, currentDate).toMinutes());
					result.add(thumbnail);
				}
				httpStatus = HttpStatus.OK;
			}
		}catch(Exception e) {
			System.out.println("ERROR: " + e.toString());
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<List<ThumbnailNewsDTO>>(result, httpStatus);
	}
	
	@GetMapping("news/thumbnail/{start}/{row}")
	public ResponseEntity<List<ThumbnailNewsDTO>> getThumbnailNews(@PathVariable(value="start")int start, @PathVariable(value="row")int row){
		List<ThumbnailNewsDTO> result =  new ArrayList<ThumbnailNewsDTO>();
		HttpStatus httpStatus = null;
		try {
				Date now = new Date(Calendar.getInstance().getTimeInMillis());
				DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS");
				String nowString = dateFormat.format(now).toString();
				LocalDateTime currentDate= LocalDateTime.parse(nowString, formatter);
				List<NewsEntity> listNews = newsService.getThumbnailNews(start, row);
				for (NewsEntity newsEntity : listNews) {
					ThumbnailNewsDTO thumbnail = new ThumbnailNewsDTO();
					thumbnail.setNewsId(newsEntity.getId());
					thumbnail.setCatId(newsEntity.getCategory().getId());
					thumbnail.setImage(newsEntity.getImage().split(";")[0]);
					thumbnail.setTitle(newsEntity.getTitle());
					thumbnail.setActor(newsEntity.getActor());
					thumbnail.setTimeCreated(newsEntity.getTimeCreate());
					LocalDateTime dateCreated = LocalDateTime.parse(newsEntity.getTimeCreate(), formatter);
					thumbnail.setLastMinute(java.time.Duration.between(dateCreated, currentDate).toMinutes());
					result.add(thumbnail);
				}
				httpStatus = HttpStatus.OK;
			
		}catch(Exception e) {
			System.out.println("ERROR: " + e.toString());
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<List<ThumbnailNewsDTO>>(result, httpStatus);
	}
	
	@GetMapping("news/related/{catId}/{id}")
	public ResponseEntity<List<ThumbnailNewsDTO>> getRelatedNews(@PathVariable(value="catId")int catId, @PathVariable(value="id")int id){
		List<ThumbnailNewsDTO> result =  new ArrayList<ThumbnailNewsDTO>();
		HttpStatus httpStatus = null;
		try {
				Date now = new Date(Calendar.getInstance().getTimeInMillis());
				DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
				DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS");
				String nowString = dateFormat.format(now).toString();
				LocalDateTime currentDate= LocalDateTime.parse(nowString, formatter);
				List<NewsEntity> listNews = newsService.getRelatedNews(catId, id);
				for (NewsEntity newsEntity : listNews) {
					ThumbnailNewsDTO thumbnail = new ThumbnailNewsDTO();
					thumbnail.setNewsId(newsEntity.getId());
					thumbnail.setCatId(newsEntity.getCategory().getId());
					thumbnail.setImage(newsEntity.getImage().split(";")[0]);
					thumbnail.setTitle(newsEntity.getTitle());
					thumbnail.setActor(newsEntity.getActor());
					thumbnail.setTimeCreated(newsEntity.getTimeCreate());
					LocalDateTime dateCreated = LocalDateTime.parse(newsEntity.getTimeCreate(), formatter);
					thumbnail.setLastMinute(java.time.Duration.between(dateCreated, currentDate).toMinutes());
					result.add(thumbnail);
				}
				httpStatus = HttpStatus.OK;
			
		}catch(Exception e) {
			System.out.println("ERROR: " + e.toString());
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<List<ThumbnailNewsDTO>>(result, httpStatus);
	}
	
	@GetMapping("news/{newsId}")
	public ResponseEntity<NewsDetailDTO> getNewsById(@PathVariable(value="newsId") int newsId){
		NewsDetailDTO result = null;
		HttpStatus httpStatus = null;
		try {
			NewsEntity news = newsService.getNewsById(newsId);
			result = new NewsDetailDTO();
			result.setNewsId(news.getId());
			result.setCategoryId(news.getCategory().getId());
			result.setCategoryType(news.getCategory().getTypeName());
			result.setTitle(news.getTitle());
			result.setParagraphs(news.getParagraphs());
			result.setImages(news.getImage());
			result.setActor(news.getActor());
			result.setTimeCreate(news.getTimeCreate());
			httpStatus = HttpStatus.OK;
		}catch(Exception e) {
			System.out.println("ERROR: " + e.toString());
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<NewsDetailDTO>(result, httpStatus);
	}
	
	@PostMapping("news/like")
	public ResponseEntity<String> likeNews( @Valid @RequestBody LikeActionDTO dto)
	{
		String result = "";
		HttpStatus httpStatus = null;
		try {
		 newsService.insertNewsLike(dto.getNewsId(), dto.getAccountId());
		 result = "Insert news like successful";
		 httpStatus = HttpStatus.OK;
		} catch(Exception e) {
			result = e.toString();
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<String>(result, httpStatus);
	}
	
	@PostMapping("news/unlike")
	public ResponseEntity<String> unLikeNews( @Valid @RequestBody LikeActionDTO dto)
	{
		String result = "";
		HttpStatus httpStatus = null;
		try {
		 newsService.deleteNewsLike(dto.getNewsId(), dto.getAccountId());
		 result = "unlike news successful";
		 httpStatus = HttpStatus.OK;
		} catch(Exception e) {
			result = e.toString();
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<String>(result, httpStatus);
	}

	@GetMapping("news/{newsId}/liked")
	public ResponseEntity<List<LikeNewsDTO>> getLikedPeople(@PathVariable(value="newsId") int newsId){
		List<LikeNewsDTO> result = new ArrayList<LikeNewsDTO>();
		HttpStatus httpStatus = null;
		try
		{
			result = newsService.getLikeNews(newsId);
			httpStatus = HttpStatus.OK;
		}catch(Exception e) {
			System.out.println("ERROR AT GET LIKE NEWS: " + e.toString());
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<List<LikeNewsDTO>>(result, httpStatus);
	}
}
