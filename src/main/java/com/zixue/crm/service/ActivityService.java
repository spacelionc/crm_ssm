package com.zixue.crm.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.zixue.crm.domain.Activity;

public interface ActivityService {

	int saveCreateActivity(Activity activity);
	
	List<Activity> queryActivityByCondition(Map<String,Object> map);
    int deleteActivityById(String[] ids);

	Activity queryActivityById(String id);

	int updateActivityById(Activity activity);

	List<Activity> queryActivityByIds(String[] ids);

	int saveimportActivity(ArrayList<Activity> activityList);

	Activity queryActivityForDetailById(String activityId);
}
