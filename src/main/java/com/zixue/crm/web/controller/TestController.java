package com.zixue.crm.web.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zixue.crm.commons.domain.ResultMsg;

@Controller
public class TestController {

	@ResponseBody
	@RequestMapping("/test0111")
	public ResultMsg test01(HttpSession session,HttpServletRequest request) {
		ResultMsg resultMsg = new ResultMsg();
		session.setAttribute("test1session", "test1session");
		request.setAttribute("test1request", "test1request");
		resultMsg.setCode("1");
		return resultMsg;
	}
	
	@RequestMapping("/test0222")
	public void test02(HttpSession session,HttpServletRequest request) {
		Object attribute = session.getAttribute("test1session");
		Object attribute2 = request.getAttribute("test1request");
		System.out.println("test1session="+attribute);
		System.out.println("test1request="+attribute2);

	}
}
