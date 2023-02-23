package com.zixue.crm.service.serviceImpl;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zixue.crm.dao.ActivityMapper;
import com.zixue.crm.domain.Activity;
import com.zixue.crm.domain.ActivityExample;
import com.zixue.crm.domain.ActivityExample.Criteria;
import com.zixue.crm.service.ActivityService;

@Service
public class ActivityServiceImpl implements ActivityService{
	@Autowired
	ActivityMapper activityMapper;

	@Override
	public int saveCreateActivity(Activity activity) {
		int insertResult = activityMapper.insertSelective(activity);
		return insertResult;
	}

	@Override
	public List<Activity> queryActivityByCondition(Map<String, Object> map) {
		List<Activity> queryActivityByCondition = activityMapper.queryActivityByCondition(map);
		return queryActivityByCondition;
	}
	
	public int deleteActivityById(String[] ids) {
		ActivityExample activityExample = new ActivityExample();
		Criteria createCriteria = activityExample.createCriteria();
		createCriteria.andIdIn(Arrays.asList(ids));
		int deleteByExampleCount = activityMapper.deleteByExample(activityExample);
		return deleteByExampleCount;
	}

	@Override
	public Activity queryActivityById(String id) {
		// TODO Auto-generated method stub
		return activityMapper.selectByPrimaryKey(id);
	}

	@Override
	public int updateActivityById(Activity activity) {
		int count = activityMapper.updateByPrimaryKeySelective(activity);
		return count;
		
		
		
	}

	@Override
	public List<Activity> queryActivityByIds(String[] ids) {
		//System.out.println("ids="+ids);
		List<Activity> queryActivityByIds = activityMapper.queryActivityByIds(Arrays.asList(ids));
		return queryActivityByIds;
	}

	@Override
	public int saveimportActivity(ArrayList<Activity> activityList) {
		int count = activityMapper.insertImportActivitys(activityList);
		return count;
	}

	@Override
	public Activity queryActivityForDetailById(String activityId) {
		Activity queryActivityForDetailById = activityMapper.queryActivityForDetailById(activityId);
		return queryActivityForDetailById;
	}

}
