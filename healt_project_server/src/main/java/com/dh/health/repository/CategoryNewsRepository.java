package com.dh.health.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.dh.health.entity.CategoryNewsEntity;

@Repository
public interface CategoryNewsRepository extends JpaRepository<CategoryNewsEntity,Long>{

	
}
