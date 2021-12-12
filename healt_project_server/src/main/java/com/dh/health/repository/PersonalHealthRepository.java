package com.dh.health.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.dh.health.dto.BMIGetDTO;
import com.dh.health.entity.PersonalHealthEntity;

@Repository
public interface PersonalHealthRepository  extends JpaRepository<PersonalHealthEntity,Long> {

	@Query(value = "SELECT * FROM personal_health WHERE account_id = :id", nativeQuery = true)
	PersonalHealthEntity getPersonalHealthByAccId(@Param(value = "id")int id);
	
	@Query(value = "SELECT id, height, weight, gender from dbo.personal_health WHERE account_id = :accountId", nativeQuery = true)
	BMIGetDTO getBmiInformation(@Param(value = "accountId")int accountId);
	
	@Transactional
	@Modifying
	@Query(value="UPDATE dbo.personal_health "
			+ "SET height = :height, weight = :weight, gender = :gender "
			+ "WHERE id = :id", nativeQuery = true)
	int updateBMI(@Param(value="height")double height,@Param(value="weight")double weight,@Param(value="gender")String gender,@Param(value="id")int id);
}
