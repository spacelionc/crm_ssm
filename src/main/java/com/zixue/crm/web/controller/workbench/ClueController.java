package com.zixue.crm.web.controller.workbench;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.zixue.crm.commons.constant.Constant;
import com.zixue.crm.commons.domain.ResultMsg;
import com.zixue.crm.commons.utils.DateUtils;
import com.zixue.crm.commons.utils.UUIDUtil;
import com.zixue.crm.domain.Clue;
import com.zixue.crm.domain.DicValue;
import com.zixue.crm.domain.User;
import com.zixue.crm.service.ClueService;
import com.zixue.crm.service.DicValueService;
import com.zixue.crm.service.UserService;

@Controller
public class ClueController {
	@Autowired
	private UserService userService;
	@Autowired
	private DicValueService dicValueService;
	@Autowired
	private ClueService clueService;
	
	//到达线索列表首页
	@RequestMapping("/workbench/clue/clueIndex")
	public String toClueIndex(HttpServletRequest request) {
		// 获取所有用户
		List<User> allUsers = userService.getAllUsers();
		// 获取其他数据字典值
		List<DicValue> appellation = dicValueService.queryDicvalue("appellation");
		List<DicValue> clueState = dicValueService.queryDicvalue("clueState");
		List<DicValue> source = dicValueService.queryDicvalue("source");
		// 将所有数据字典传到前台
		request.setAttribute("userList", allUsers);
		request.setAttribute("appellation", appellation);
		request.setAttribute("clueState", clueState);
		request.setAttribute("source", source);
		return "workbench/clue/index";
	}
	
	@ResponseBody
	@RequestMapping("/workbench/clue/addClue")
	public ResultMsg addClue(Clue clue,HttpSession session){
		ResultMsg resultMsg = new ResultMsg();
		//继续封装参数
		User createBy= (User) session.getAttribute("user");
		String createTime = DateUtils.formatDateTime(new Date());
		String id = UUIDUtil.getUUID();
		clue.setId(id);
		clue.setCreateBy(createBy.getId());
		clue.setCreateTime(createTime);
		try {
			//调用service方法创建线索
			int addResult = clueService.addClue(clue);
			if(addResult==1) {
				resultMsg.setCode("1");
			}else {
				resultMsg.setCode("0");
				resultMsg.setMsg("请稍后再试");
			}
		} catch (Exception e) {
			resultMsg.setCode("0");
			resultMsg.setMsg("请稍后再试");
		}
		
		
		return resultMsg;
		
	}
	
	@RequestMapping("/workbench/clue/queryClueByCondition")
	@ResponseBody
	public ResultMsg queryClueByCondition(Clue clue, int pageNum,int pageSize) {
		System.out.println("注意"+clue);
		ResultMsg resultMsg = new ResultMsg();
		// 设置查询页数和每页条数
		PageHelper.startPage(pageNum, pageSize);
		// 向map中添加查询条件
		/*
		 * HashMap<String, Object> map = new HashMap<>(); map.put("name", name);
		 * map.put("owner", owner); map.put("startDate", startDate); map.put("endDate",
		 * endDate); // System.out.println(map); // 根据条件查询市场活动 List<Activity>
		 * activityList = activityService.queryActivityByCondition(map);
		 */
		List<Clue> clueList = clueService.queryClueByConditionForPage(clue);
		System.out.println(clueList);
		PageInfo<Clue> pageInfo = new PageInfo<>(clueList, Constant.DEFAULT_NAVIGATE_PAGES);
		// 将查询的市场活动和分页信息封装到resultMsg中
		resultMsg.add("pageInfo", pageInfo);
		// System.out.println(activityList);
		return resultMsg;
	}
	
	 @RequestMapping("/workbench/clue/queryClueById")
	 @ResponseBody
	 public ResultMsg queryClueById(String id) {
		 
		 System.out.println("11111111111111111111111"+id);
		 ResultMsg resultMsg = new ResultMsg();
		Clue clue=clueService.getClueById(id);
		resultMsg.add("clue", clue);
		 return resultMsg;
	}
	 
	 @RequestMapping("/workbench/clue/updateClueById")
	 @ResponseBody
	 public ResultMsg updateClueById(Clue clue,HttpSession session) {
		 
		 System.out.println("11111111111111111111111"+clue);
		 //继续封装参数
		 User user =(User)session.getAttribute("user");
		 clue.setEditBy(user.getId());
		 clue.setEditTime(DateUtils.formatDateTime(new Date()));
		 System.out.println("22222222222222222222"+clue);
		 ResultMsg resultMsg = new ResultMsg();
		try {
			int count=clueService.editClueById(clue);
			if(count==1) {
				resultMsg.setCode(Constant.RETURN_MSG_CODE_SUCCESS);
			}else {
				resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
				resultMsg.setMsg("请稍后再试");
			}
		} catch (Exception e) {
			resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
			resultMsg.setMsg("请稍后再试");
		}
		 return resultMsg;
}
	 
	 @RequestMapping("/workbench/clue/toClueDetail")
	 public String toClueDetail(Clue clue,HttpServletRequest request) {
		 System.out.println("++++++++++++++++++++++++++"+clue);
		Clue clueDetail=clueService.getClueDetailById(clue);
		 
		request.setAttribute("clueDetail", clueDetail);
		 return "workbench/clue/detail";
	 }
	 
	 }
