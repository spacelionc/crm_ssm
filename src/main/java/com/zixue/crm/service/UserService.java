package com.zixue.crm.service;

import java.util.List;

import com.zixue.crm.domain.User;

public interface UserService {
	/**
	 * 根据登陆账号和密码查询用户
	 * @param loginact
	 * @param loginpwd
	 * @return
	 */
	 User getUserByLoginactAndLoginpwd(String loginact,String loginpwd);
	 
	 List<User> getAllUsers();
		 
	 

}
