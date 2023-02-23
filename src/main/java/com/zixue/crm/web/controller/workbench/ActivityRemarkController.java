package com.zixue.crm.web.controller.workbench;

import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.zixue.crm.commons.constant.Constant;
import com.zixue.crm.commons.domain.ResultMsg;
import com.zixue.crm.commons.utils.DateUtils;
import com.zixue.crm.commons.utils.UUIDUtil;
import com.zixue.crm.domain.Activity;
import com.zixue.crm.domain.ActivityRemark;
import com.zixue.crm.service.ActivityRemarkService;
import com.zixue.crm.service.ActivityService;

@Controller
public class ActivityRemarkController {
	@Autowired
	ActivityService activityService;
	
	@Autowired
	ActivityRemarkService activityRemarkService;
	
	@RequestMapping("/workbench/activity/toActivityDetail")
	public String toActivityDetail(String activityId,HttpServletRequest request) {
		//根据市场活动的id查询市场活动的详细信息
	Activity activity=activityService.queryActivityForDetailById(activityId);
	//根据市场活动的id查询该市场活动下的所有备注
	List<ActivityRemark> queryAllRemarkByActivityId = activityRemarkService.queryAllRemarkByActivityId(activityId);
	request.setAttribute("activity",activity);
	request.setAttribute("remark",queryAllRemarkByActivityId);
	//转发到市场活动详情页面
		return "workbench/activity/detail";
	}
	
	//保存备注
	@ResponseBody
	@RequestMapping("/workbench/activity/saveActivityRemark")
	public ResultMsg saveActivityRemark(ActivityRemark activityRemark) {
		 System.out.println(activityRemark); 
		//进一步封装备注的参数
		activityRemark.setCreateTime(DateUtils.formatDateTime(new Date()));
		activityRemark.setId(UUIDUtil.getUUID());
		activityRemark.setEditFlag(Constant.ACTIVITY_CREATE);
		ResultMsg resultMsg = new ResultMsg();
		try {
			int count=activityRemarkService.saveActivityRemark(activityRemark);
			if(count==0) {
				resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
				resultMsg.setMsg("备注保存失败");
			}
			resultMsg.add("remark", activityRemark);
			resultMsg.setCode(Constant.RETURN_MSG_CODE_SUCCESS);
		} catch (Exception e) {
			e.printStackTrace();
			resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
			resultMsg.setMsg("备注保存失败");
		}
		return resultMsg;
	}
	
	//根据备注Id删除备注
		@ResponseBody
		@RequestMapping("/workbench/activity/deleteActivityRemarkById")
		public ResultMsg deleteActivityRemarkById(String remarkId) {
			ResultMsg resultMsg = new ResultMsg();
			try {
				int count=activityRemarkService.deleteActivityRemarkById(remarkId);
				if(count==0) {
					resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
					resultMsg.setMsg("备注删除失败");
				}
				resultMsg.setCode(Constant.RETURN_MSG_CODE_SUCCESS);
			} catch (Exception e) {
				e.printStackTrace();
				resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
				resultMsg.setMsg("备注删除失败");
			}
			return resultMsg;
		}
		
		//根据备注Id修改备注
				@ResponseBody
				@RequestMapping("/workbench/activity/updateActivityRemarkByRemarkId")
				public ResultMsg updateActivityRemarkByRemarkId(ActivityRemark remark) {
					//获得修改时间 进一步封装
					remark.setEditTime(DateUtils.formatDateTime(new Date()));
					remark.setEditFlag(Constant.ACTIVITY_EDIT);
					System.out.println(remark);
					
					ResultMsg resultMsg = new ResultMsg();
					try {
						int count=activityRemarkService.updateActivityRemarkById(remark);
						if(count==0) {
							resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
							resultMsg.setMsg("备注修改失败");
						}
						resultMsg.setCode(Constant.RETURN_MSG_CODE_SUCCESS);
						resultMsg.add("remark", remark);
					} catch (Exception e) {
						e.printStackTrace();
						resultMsg.setCode(Constant.RETURN_MSG_CODE_FAIL);
						resultMsg.setMsg("备注修改失败");
					}
					return resultMsg;
				}
		
		
}
