package com.zixue.crm.service.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zixue.crm.dao.UserMapper;
import com.zixue.crm.domain.User;
import com.zixue.crm.domain.UserExample;
import com.zixue.crm.domain.UserExample.Criteria;
import com.zixue.crm.service.UserService;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	private UserMapper userMapper;

	/**
	 * 根据登陆账号和密码查询用户
	 * 
	 * @param loginact
	 * @param loginpwd
	 * @return
	 */
	public User getUserByLoginactAndLoginpwd(String loginact, String loginpwd) {
		// 获取条件参数模板
		UserExample userExample = new UserExample();
		Criteria criteria = userExample.createCriteria();
		// 拼装模板
		criteria.andLoginActEqualTo(loginact);
		criteria.andLoginPwdEqualTo(loginpwd);
		// 根据拼装的条件模板查询
		List<User> userList = userMapper.selectByExample(userExample);
		if (userList.size() == 0) {
			return null;
		} else {
			return userList.get(0);
		}
	}
/**
 * 查询所有用户
 */
	@Override
	public List<User> getAllUsers() {

		List<User> userList = userMapper.selectByExample(null);
		return userList;

	}

}
