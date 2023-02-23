package com.zixue.crm.web.controller.workbench;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WorkBenchMainIndexController {
	
	@RequestMapping("/workbench/main/mainIndex")
	public String mainIndex() {
		return "workbench/main/index";
	}

}
