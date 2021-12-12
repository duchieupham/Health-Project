package com.dh.health.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.dh.health.dto.AccountInformationDTO;
import com.dh.health.entity.AccountEntity;

@Repository
public interface AccountRepository extends JpaRepository<AccountEntity,Long> {

	
	@Query(value = "SELECT * FROM Account WHERE username = :username AND password = :password",nativeQuery = true)
	AccountEntity login(@Param(value = "username") String username, @Param(value = "password") String password);
	
//	@Query(value = "SELECT * FROM Account",nativeQuery = true)
//	AccountEntity getAllAccount();
	
	@Query(value = "SELECT * FROM Account WHERE id = :id", nativeQuery = true)
	AccountEntity getAccountById(@Param(value = "id")int id);
	
	@Query(value= "SELECT * FROM Account WHERE phone = :phone", nativeQuery = true)
	AccountEntity loginByPhone(@Param(value = "phone")String phone);
	
	@Transactional
	@Modifying
	@Query(value="UPDATE Account SET avatar = :avatar WHERE id = :id", nativeQuery = true)
	int updateAvatar(@Param(value ="avatar")String avatar, @Param(value= "id")int id);


	@Transactional
	@Modifying
	@Query(value = "UPDATE Account SET password = :newPassword WHERE id = :id", nativeQuery = true)
	int updateNewPassword(@Param(value = "newPassword")String newPassword, @Param(value = "id") int id);
	
	
	@Query(value = "SELECT password FROM dbo.account "
			+ "WHERE id = :id", nativeQuery = true)
	String getPassword(@Param(value = "id") int id);
	
	
	@Query(value ="SELECT a.username, a.firstname, a.lastname, a.phone, a.address, b.gender, b.birthday \n"
			+ "FROM dbo.account a, dbo.personal_health b\n"
			+ "WHERE a.id = b.account_id AND a.id = :id", nativeQuery = true)
	AccountInformationDTO getAccountInformation(@Param(value= "id")int id);
	
	@Transactional
	@Modifying
	@Query(value = "UPDATE dbo.account "
			+ "SET firstname = :firstname, lastname = :lastname "
			+ "WHERE id = :id", nativeQuery=true)
	int updateNameAccount(@Param(value="lastname")String lastname, @Param(value="firstname")String firstname, @Param(value="id")int id);

	@Transactional
	@Modifying
	@Query(value = "UPDATE dbo.personal_health "
			+ "SET gender = :gender, birthday = :birthday "
			+ "WHERE account_id = :id ", nativeQuery=true)
	int updatePersonalAccount(@Param(value="gender")String gender, @Param(value="birthday")String birthday, @Param(value="id")int id);

	@Transactional
	@Modifying
	@Query(value = "UPDATE dbo.account "
			+ "SET address = :address, phone = :phone "
			+ "WHERE id = :id ", nativeQuery=true)
	int updateContactAccount(@Param(value="address")String address, @Param(value="phone")String phone, @Param(value="id")int id);
}
