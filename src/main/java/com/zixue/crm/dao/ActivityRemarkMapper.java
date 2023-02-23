package com.zixue.crm.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zixue.crm.domain.ActivityRemark;
import com.zixue.crm.domain.ActivityRemarkExample;

public interface ActivityRemarkMapper {
    long countByExample(ActivityRemarkExample example);

    int deleteByExample(ActivityRemarkExample example);

    int deleteByPrimaryKey(String id);

    int insert(ActivityRemark record);

    int insertSelective(ActivityRemark record);

    List<ActivityRemark> selectByExample(ActivityRemarkExample example);

    ActivityRemark selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") ActivityRemark record, @Param("example") ActivityRemarkExample example);

    int updateByExample(@Param("record") ActivityRemark record, @Param("example") ActivityRemarkExample example);

    int updateByPrimaryKeySelective(ActivityRemark record);

    int updateByPrimaryKey(ActivityRemark record);
    
    //根据市场活动ID查询该市场活动下的所有备注
    List<ActivityRemark> queryAllRemarkByActivityId(String activityId);    
}