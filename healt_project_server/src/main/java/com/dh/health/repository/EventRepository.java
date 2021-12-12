package com.dh.health.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.dh.health.dto.EventDTO;
import com.dh.health.entity.EventEntity;

@Repository
public interface EventRepository extends JpaRepository<EventEntity, Long>{
	

	@Query(value = "SELECT a.id, a.content , a.status, a.time_created as timeCreated, a.time_event as timeEvent, a.title, a.doctor_id as doctorId, a.patient_id as patientId, b.firstname as dFirstname, b.lastname as dLastname, b.phone, b.avatar, d.email, d.work_location as workLocation, d.longtitude, d.latitude "
			+ "FROM dbo.event a "
			+ "JOIN dbo.account b "
			+ "ON a.doctor_id = b.id "
			+ "JOIN dbo.doctor d "
			+ "ON a.doctor_id = d.account_id "
			+ "WHERE a.patient_id = :patientId "
			+ "ORDER BY a.time_event ASC", nativeQuery = true)
	List<EventDTO> getEventsByPatientId(@Param(value = "patientId") int patientId);
	
	
	@Query(value="SELECT * FROM dbo.event WHERE time_created = :timeCreated AND time_event = :timeEvent AND doctor_id = :doctorId AND patient_id = :patientId", nativeQuery = true)
	EventEntity getEventById(@Param(value = "timeCreated") String timeCreated, @Param(value = "timeEvent") String timeEvent, @Param(value = "doctorId") int doctorId, @Param(value = "patientId") int patientId);
//	

	@Query(value="SELECT * FROM dbo.event WHERE patient_id = :patientId AND time_event LIKE :date ", nativeQuery = true)
	List<EventDTO> getEventsByDate(@Param(value = "patientId") int patientId, @Param(value = "date")String date);
	
	@Query(value="SELECT * FROM dbo.event WHERE patient_id = :patientId AND time_event between CAST(:fromDate as date) and CAST(:toDate as date)", nativeQuery = true)
	List<EventDTO> getEventsFromDateToDate(@Param(value = "patientId") int patientId, @Param(value = "fromDate")String fromDate, @Param(value = "toDate")String toDate);
	
}
