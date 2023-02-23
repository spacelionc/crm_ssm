package com.zixue.crm.service;

import java.util.List;

import com.zixue.crm.domain.ActivityRemark;

public interface  ActivityRemarkService {
	 //根据市场活动ID查询该市场活动下的所有备注
    List<ActivityRemark> queryAllRemarkByActivityId(String activityId);
    //保存市场活动备注
	int saveActivityRemark(ActivityRemark activityRemark);
	//删除市场活动备注
	int deleteActivityRemarkById(String remarkId);
	//修改市场活动备注
	int updateActivityRemarkById(ActivityRemark remark);  
}
