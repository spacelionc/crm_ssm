package com.zixue.crm.web.controller.settings;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class IndexController {
	
	//登陆应用主页面的时候发送的路径地址
	@RequestMapping("/")
public String index() {
		//System.out.println(1);
	return "index";
}
}
