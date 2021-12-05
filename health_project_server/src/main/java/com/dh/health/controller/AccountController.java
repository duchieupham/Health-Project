package com.dh.health.controller;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;
import javax.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.dh.health.dto.AccountContactDTO;
import com.dh.health.dto.AccountDTO;
import com.dh.health.dto.AccountInformationDTO;
import com.dh.health.dto.AccountPersonalDTO;
import com.dh.health.dto.PasswordUpdateDTO;
import com.dh.health.dto.PersonalDTO;
import com.dh.health.entity.AccountEntity;
import com.dh.health.entity.PersonalHealthEntity;
import com.dh.health.service.AccountService;
import com.dh.health.service.PersonalHealthService;
import com.dh.health.util.FileUploadUtil;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;


@RestController
@RequestMapping("api/v1")
public class AccountController {
	
	@Autowired
	AccountService accountService;
	
	@Autowired
	PersonalHealthService personalService;
	

    @PostMapping("accounts/avatar")
    public ResponseEntity<String> updateAvatar(@Valid @RequestParam int id, @Valid @RequestParam MultipartFile avatar){
    	String result = "";
    	HttpStatus httpStatus = null;
    	try {
    		String fileName = StringUtils.cleanPath(avatar.getOriginalFilename());
    		accountService.updateAvatar(fileName, id);
    		FileUploadUtil.saveFile("src/main/webapp/WEB-INF/images", fileName, avatar);
    		result = "update avatar sucessful";
    		httpStatus = HttpStatus.OK;
    	} catch(Exception e) {
    		result = e.toString();
			httpStatus = HttpStatus.BAD_REQUEST;
    	}
    	return new ResponseEntity<String>(result, httpStatus);
    }

	@PostMapping("accounts")
	public ResponseEntity<String> login(@Valid @RequestBody AccountDTO account)  {
		String result = "";
		HttpStatus httpStatus = null;
		try
		{
			if(account.isLoginPhone()) {
				if(account.getPhone()!=null && account.getPhone() != "") {
					AccountEntity accountCheck = accountService.loginByPhone(account.getPhone());
					int accountId = accountCheck.getId();
					String firstName = accountCheck.getFirstname();
				    String lastName = accountCheck.getLastname();
				    String avatar = accountCheck.getAvatar();
				    if(avatar==null) {
				    	avatar = "";
				    }
					result = getJWTToken(accountId, firstName, lastName,avatar);
					httpStatus = HttpStatus.OK;
				}else {
					result = "Invalid phone number";
					httpStatus = HttpStatus.BAD_REQUEST;
				}
			}else {
				if(account.getUsername()!= null && account.getPassword() != null) {
					AccountEntity accountCheck = accountService.login(account.getUsername(), account.getPassword());
					int accountId = accountCheck.getId();
					String firstName = accountCheck.getFirstname();
				    String lastName = accountCheck.getLastname();
				    String avatar= accountCheck.getAvatar();
				    if(avatar==null) {
				    	avatar = "";
				    }
					result = getJWTToken(accountId, firstName, lastName, avatar);
					httpStatus = HttpStatus.OK;
				}else {
					result = "Invalid username or password";
					httpStatus = HttpStatus.BAD_REQUEST;
				}
				
			}
			
		}catch(Exception e) {
			result = "Invalid username or password";
			httpStatus = HttpStatus.BAD_REQUEST;
		}
		return new ResponseEntity<String>(result, httpStatus);
	}
	
	@PostMapping("accounts/password")
	public ResponseEntity<String> updatePassword(@Valid @RequestBody PasswordUpdateDTO dto)  {
	String result = "";
	HttpStatus httpStatus = null;
	try
	{	
		if(dto.getOldPassword().equals(accountService.getPassword(dto.getId()))) {
			int statement = accountService.updateNewPassword(dto.getNewPassword(), dto.getId());
			if(statement==1) {
			result = "Update password successful";
			httpStatus = HttpStatus.OK;
			}
		}else {
			result = "Wrong password";
			httpStatus = HttpStatus.NOT_MODIFIED;
		}
		
	}catch(Exception e) {
		result = "Exception: " + e.toString();
		httpStatus = HttpStatus.BAD_REQUEST;
	}
	return new ResponseEntity<String>(result, httpStatus);
	}
	
	
	@GetMapping("accounts/information")
	public ResponseEntity<AccountInformationDTO> getAccountInformation(@Valid @RequestParam Integer id)  {
		AccountInformationDTO result = null;
	HttpStatus httpStatus = null;
	try
	{
		if(id != 0) {
			result = accountService.getAccountInformation(id);
			if(result.getUsername()!=null) {
				httpStatus = HttpStatus.OK;
			}
		}
		
	}catch(Exception e) {
		httpStatus = HttpStatus.BAD_REQUEST;
	}
	return new ResponseEntity<AccountInformationDTO>(result, httpStatus);
	}
	
	@PostMapping("accounts/personal")
	public ResponseEntity<String> updatePersonalAccount(@Valid @RequestBody AccountPersonalDTO dto)  {
	String result = "";
	HttpStatus httpStatus = null;
	try
	{	
		if(dto.getId()!=0) {
			int check = accountService.updateNameAccount(dto.getLastname(), dto.getFirstname(), dto.getId());
			int check2 = accountService.updatePersonalAccount(dto.getGender(), dto.getBirthday(), dto.getId());
			if(check == 1 && check2 == 1) {
				result = "Update personal information successful";
				httpStatus = HttpStatus.OK;
			}
		}
	}catch(Exception e) {
		result = "Exception: " + e.toString();
		httpStatus = HttpStatus.BAD_REQUEST;
	}
	return new ResponseEntity<String>(result, httpStatus);
	}
	
	@PostMapping("accounts/contact")
	public ResponseEntity<String> updateContactAccount(@Valid @RequestBody AccountContactDTO dto)  {
	String result = "";
	HttpStatus httpStatus = null;
	try
	{	
		if(dto.getId()!=0) {
		int check = accountService.updateContactAccount(dto.getAddress(), dto.getPhone(), dto.getId());
		if(check==1) {
			result = "update contact account successful";
			httpStatus = HttpStatus.OK;
		}
		}
	}catch(Exception e) {
		result = "Exception: " + e.toString();
		httpStatus = HttpStatus.BAD_REQUEST;
	}
	return new ResponseEntity<String>(result, httpStatus);
	}
	
	
//	@GetMapping("account")
//	public ResponseEntity<List<AccountEntity>> getAllAccount(HttpServletRequest request)  {
//		List<AccountEntity> result = null;
//		System.out.println("GO TO LOGIN API");
//		HttpStatus httpStatus = null;
//		try
//		{
//		 result = accountService.getAllAccount();
//		}catch(Exception e) {
//			httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
//		}
//		return new ResponseEntity<List<AccountEntity>>(result, httpStatus.OK);
//	}
	
	
	@GetMapping("accounts/{accountId}")
	public ResponseEntity<PersonalDTO> getPersonalInfo(@PathVariable(value="accountId")int accountId) {
		PersonalDTO dto = null;
		HttpStatus httpStatus = null;
		try
		{
			if(accountId!= 0) {
				AccountEntity accEntity = accountService.getAccountById(accountId);
				PersonalHealthEntity personalEntity = personalService.getByAccId(accountId);
				dto = new PersonalDTO();
				dto.setAccountId(accEntity.getId());
				dto.setFirstname(accEntity.getFirstname());
				dto.setLastname(accEntity.getLastname());
				dto.setHeight(personalEntity.getHeight());
				dto.setWeight(personalEntity.getWeight());
				dto.setFamilyHealth(personalEntity.getFamilyHealth());
				dto.setHealthDescription(personalEntity.getHealthDescription());
				dto.setGender(personalEntity.getGender());
				dto.setAddress(accEntity.getAddress());
				dto.setPhone(accEntity.getPhone());
				dto.setAvatar(accEntity.getAvatar());
				httpStatus = HttpStatus.OK;
			}
		}
		catch(Exception e) {
			httpStatus = HttpStatus.INTERNAL_SERVER_ERROR;
		}
		return new ResponseEntity<PersonalDTO>(dto, httpStatus);
	}
	
	
	private String getJWTToken(int accountId, String firstName, String lastName, String avatar) {
		String secretKey = "mySecretKey";
		List<GrantedAuthority> grantedAuthorities = AuthorityUtils
				.commaSeparatedStringToAuthorityList("ROLE_USER");
		
		String token = Jwts
				.builder()
//				.setId("softtekJWT")
//				.setSubject(accountId)
				.claim("accountId",accountId)
				.claim("firstName", firstName)
				.claim("lastName", lastName)
				.claim("avatar", avatar)
				.claim("authorities",
						grantedAuthorities.stream()
								.map(GrantedAuthority::getAuthority)
								.collect(Collectors.toList()))
				.setIssuedAt(new Date(System.currentTimeMillis()))
				.setExpiration(new Date(System.currentTimeMillis() + 900000000))
				.signWith(SignatureAlgorithm.HS512,
						secretKey.getBytes()).compact();

		return "Bearer " + token;
	}
}
