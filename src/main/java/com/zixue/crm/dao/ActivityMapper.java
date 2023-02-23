package com.zixue.crm.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.zixue.crm.domain.Activity;
import com.zixue.crm.domain.ActivityExample;

public interface ActivityMapper {
    long countByExample(ActivityExample example);

    int deleteByExample(ActivityExample example);

    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    int insertSelective(Activity record);

    List<Activity> selectByExample(ActivityExample example);

    Activity selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") Activity record, @Param("example") ActivityExample example);

    int updateByExample(@Param("record") Activity record, @Param("example") ActivityExample example);

    int updateByPrimaryKeySelective(Activity record);

    int updateByPrimaryKey(Activity record);
    
    //根据条件查询市场活动
    List<Activity> queryActivityByCondition(Map<String,Object> map);
    
    //根据Ids查询市场活动
    List<Activity> queryActivityByIds(List<String> ids);
    
    //批量插入导入的市场活动
    int insertImportActivitys(List<Activity> activity);
    //根据ID查询市场活动的详细信息
    Activity queryActivityForDetailById(String activityId);
    
}