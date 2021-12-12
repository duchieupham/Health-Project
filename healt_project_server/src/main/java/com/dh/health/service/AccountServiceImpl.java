package com.dh.health.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dh.health.dto.AccountInformationDTO;
import com.dh.health.entity.AccountEntity;
import com.dh.health.repository.AccountRepository;

@Service
public class AccountServiceImpl implements AccountService{

	@Autowired
	AccountRepository accountRepo;
	
	
	@Override
	public AccountEntity login(String username, String password) {
		AccountEntity account = new AccountEntity();
		try {
		 account = accountRepo.login(username, password);
		}catch(Exception e) {
			System.out.println("Error at login service: " + e);
		}
		return account;
	}
	
	@Override
	public List<AccountEntity> getAllAccount(){
		List<AccountEntity> list = accountRepo.findAll();
		return list;
	}
	
	public AccountEntity getAccountById(int accountId) {
		AccountEntity account = accountRepo.getAccountById(accountId);
		return account;
	}
	
	public AccountEntity loginByPhone(String phone) {
		AccountEntity account = accountRepo.loginByPhone(phone);
		return account;
	}
	
	public int updateAvatar(String avatar, int id) {
		return accountRepo.updateAvatar(avatar, id);
	}

	@Override
	public int updateNewPassword(String newPassword, int id) {
		return accountRepo.updateNewPassword(newPassword, id);
	}

	@Override
	public String getPassword(int id) {
		return accountRepo.getPassword(id);
	}

	@Override
	public AccountInformationDTO getAccountInformation(int id) {
		return accountRepo.getAccountInformation(id);
	}

	@Override
	public int updateNameAccount(String lastname, String firstname, int id) {
		return accountRepo.updateNameAccount(lastname, firstname, id);
	}

	@Override
	public int updatePersonalAccount(String gender, String birthday, int id) {
		return accountRepo.updatePersonalAccount(gender, birthday, id);
	}

	@Override
	public int updateContactAccount(String address, String phone, int id) {
		return accountRepo.updateContactAccount(address, phone, id);
	}
	
}
