package com.zixue.crm.web.controller.settings;

import java.util.Date;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zixue.crm.commons.constant.Constant;
import com.zixue.crm.commons.domain.ResultMsg;
import com.zixue.crm.commons.utils.DateUtils;
import com.zixue.crm.domain.User;
import com.zixue.crm.service.UserService;

@Controller
public class LoginController {

	@Autowired
	private UserService userService;
	//来到系统主页面的路径
	@RequestMapping("/settings/qx/user/login")
	public String login() {
		return "settings/qx/user/login";
	}

	
	//请求登录业务主页面的路径地址
	@ResponseBody
	@RequestMapping("/settings/qx/user/toLogin")
	public ResultMsg toLogin(String loginact, String loginpwd, String isRemPwd, HttpServletRequest request,HttpServletResponse response) {
		// 获取返回对象
		ResultMsg resultMsg = new ResultMsg();
		// 获取当前时间，转为字符串
		String nowDate = DateUtils.formatDateTime(new Date());
		// 根据前端输入的数据查询用户
		User user = userService.getUserByLoginactAndLoginpwd(loginact, loginpwd);
		// 对查询结果进行校验
		if (user == null) {
			resultMsg.setMsg("账户或密码错误");
		} else {
			if (user.getExpireTime().compareTo(nowDate) < 0) {
				resultMsg.setMsg("账号已过期");
			} else if ("0".equals(user.getLockState())) {
				resultMsg.setMsg("状态被锁定");
			} else if (!user.getAllowIps().contains(request.getRemoteAddr())) {

				resultMsg.setMsg("ip受限");
			} else {
				resultMsg.setCode(Constant.RETURN_MSG_CODE_SUCCESS);
				//将当前登录用户放到session域中
				request.getSession().setAttribute("user", user);
				
				//实现记住账号密码，通过cookie
				if("true".equals(isRemPwd)) {
					Cookie cookie = new Cookie("loginact", loginact);
					Cookie cookie2 = new Cookie("loginpwd", loginpwd);
					cookie.setMaxAge(60);
					cookie2.setMaxAge(60);
					response.addCookie(cookie);
					response.addCookie(cookie2);
				}else {
					//当没选中记住密码，将浏览器cookie中值的生命置为0
					Cookie cookie = new Cookie("loginact", null);
					Cookie cookie2 = new Cookie("loginpwd", null);
					cookie.setMaxAge(0);
					cookie2.setMaxAge(0);
					response.addCookie(cookie);
					response.addCookie(cookie2);
				}
			}

		}
		//System.out.println(resultMsg);
		return resultMsg;
	}
	
	
	//安全退出到应用主页面
	@RequestMapping("/settings/qx/user/logout")
	public String logout(HttpServletResponse  response,HttpSession session) {
		//清空cookie
		Cookie cookie = new Cookie("loginact", null);
		Cookie cookie2 = new Cookie("loginpwd", null);
		cookie.setMaxAge(0);
		cookie2.setMaxAge(0);
		response.addCookie(cookie);
		response.addCookie(cookie2);
		//销毁session
		session.invalidate();
		//System.out.println(3);
		return "redirect:/settings/qx/user/login";
		
		
	}
}
