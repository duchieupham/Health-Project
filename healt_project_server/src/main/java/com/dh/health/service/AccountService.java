package com.dh.health.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.dh.health.dto.AccountInformationDTO;
import com.dh.health.entity.AccountEntity;

@Service
public interface AccountService {

		public AccountEntity login(String username, String password);
		
		public AccountEntity loginByPhone(String phone);
		
		public List<AccountEntity> getAllAccount();
		
		public AccountEntity getAccountById(int accountId);
		
		public int updateAvatar(String avatar, int id);
		
		public int updateNewPassword(String newPassword, int id);
		
		public String getPassword(int id);
		
		public AccountInformationDTO getAccountInformation(int id);
		
		public int updateNameAccount(String lastname, String firstname, int id);
		
		public int updatePersonalAccount(String gender, String birthday, int id);
		
		public int updateContactAccount(String address, String phone, int id);
}
