package com.zixue.crm.service.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zixue.crm.dao.ActivityRemarkMapper;
import com.zixue.crm.domain.ActivityRemark;
import com.zixue.crm.service.ActivityRemarkService;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService{
	
	@Autowired
	ActivityRemarkMapper activityRemarkMapper;

	@Override
	public List<ActivityRemark> queryAllRemarkByActivityId(String activityId) {
		List<ActivityRemark> queryAllRemarkByActivityId = activityRemarkMapper.queryAllRemarkByActivityId(activityId);
		return queryAllRemarkByActivityId;
	}

	@Override
	public int saveActivityRemark(ActivityRemark activityRemark) {
		int count = activityRemarkMapper.insertSelective(activityRemark);
		return count;
	}

	@Override
	public int deleteActivityRemarkById(String remarkId) {
		int count = activityRemarkMapper.deleteByPrimaryKey(remarkId);
		return count;
	}

	@Override
	public int updateActivityRemarkById(ActivityRemark remark) {
		int count = activityRemarkMapper.updateByPrimaryKeySelective(remark);
		return count;
		
	}

}
