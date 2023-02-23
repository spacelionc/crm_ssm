package com.zixue.crm.web.controller.workbench;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class WorkBenchIndexController {
	
	
	@RequestMapping("workbench/toWorkBenchIndex")
	public String toWorkBenchIndex() {
		return "workbench/index";
	}

}
