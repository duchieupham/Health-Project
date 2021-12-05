package com.dh.health.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.dh.health.dto.LikeNewsDTO;
import com.dh.health.entity.NewsEntity;

@Repository
public interface NewsRepository extends JpaRepository<NewsEntity, Long>{
	
	@Query(value = "SELECT * FROM News WHERE status = 'ACTIVE' ORDER BY time_create DESC", nativeQuery = true)
	List<NewsEntity> getAllNews();
	
	@Query(value = "SELECT * FROM News "
			+ "WHERE status = 'ACTIVE' "
			+ "AND cat_id = :catId "
			+ "ORDER BY time_create DESC "
			+ "OFFSET :start ROWS FETCH NEXT :row ROWS ONLY", nativeQuery = true)
	List<NewsEntity> getNewsByCat(@Param(value ="catId")int catId,@Param(value = "start")int start, @Param(value = "row")int row);
	
	@Query(value = "SELECT * FROM News WHERE id = :newsId", nativeQuery= true)
	NewsEntity getNewsById(@Param(value="newsId") int newsId);

	
	@Query(value = "SELECT * FROM News "
			+ "WHERE status = 'ACTIVE' "
			+ "ORDER BY time_create DESC "
			+ "OFFSET :start ROWS FETCH NEXT :row ROWS ONLY", nativeQuery = true)
	List<NewsEntity> getThumbnailNews(@Param(value = "start")int start, @Param(value = "row")int row);
	
	@Query(value="SELECT TOP 3 * FROM dbo.news "
			+ "WHERE cat_id = :catId AND id <> :id "
			+ "ORDER BY NEWID()", nativeQuery = true)
	List<NewsEntity> getRelatedNews(@Param(value = "catId") int catId, @Param(value = "id") int id);
	
	@Transactional
	@Modifying
	@Query(value = "INSERT INTO dbo.news_account_like (news_entity_id, account_like_id) VALUES (:newsId, :accountId)", nativeQuery= true)
	int insertNewsLike(@Param(value = "newsId") int newsId, @Param(value = "accountId") int accountId); 
	
	@Transactional
	@Modifying
	@Query(value = "DELETE FROM dbo.news_account_like WHERE news_entity_id = :newsId AND account_like_id = :accountId", nativeQuery= true)
	int deleteNewsLike(@Param(value = "newsId") int newsId, @Param(value = "accountId") int accountId); 

	@Modifying
	@Query(value = "SELECT a.news_entity_id as newsId, a.account_like_id as accountId, b.firstname as name, b.avatar as avatar FROM dbo.news_account_like a, dbo.account b  WHERE a.news_entity_id = :newsId AND a.account_like_id = b.id", nativeQuery = true)
	List<LikeNewsDTO> getLikeNews(@Param(value = "newsId") int newsId);
}
