package com.dh.health.repository;

import java.util.List;

import javax.transaction.Transactional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.dh.health.dto.NotificationGetDTO;
import com.dh.health.entity.NotificationEntity;

@Repository
public interface NotificationRepository extends JpaRepository<NotificationEntity, Long>{

	@Query(value = "SELECT a.id, a.description, a.key_id as keyId, a.status, a.time_created as timeCreated, a.account_id as accountId, b.key_type as keyType, b.type_name as typeName "
			+ "FROM dbo.notification a "
			+ "JOIN dbo.notification_type b "
			+ "ON a.type_id = b.id "
			+ "WHERE a.account_id = :accountId "
			+ "ORDER BY a.time_created DESC", nativeQuery = true)
	List<NotificationGetDTO> getNotificationsByAccountId(@Param("accountId")int accountId);
	
	
	@Query(value = "SELECT count(id) "
			+ "FROM dbo.notification "
			+ "WHERE account_id = :accountId AND status = 'UNREAD'", nativeQuery = true)
	Integer getCountUnreadNotificationByAccountId(@Param("accountId") int accountId);
	
	@Transactional
	@Modifying
	@Query(value = "UPDATE Notification SET status = 'READ' WHERE id = :id", nativeQuery = true)
	int updateNotificationStatus(@Param(value ="id") int id);
}
