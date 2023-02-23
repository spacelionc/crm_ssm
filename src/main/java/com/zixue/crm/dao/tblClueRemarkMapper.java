package com.zixue.crm.dao;

import com.zixue.crm.domain.tblClueRemark;
import com.zixue.crm.domain.tblClueRemarkExample;
import java.util.List;
import org.apache.ibatis.annotations.Param;

public interface tblClueRemarkMapper {
    long countByExample(tblClueRemarkExample example);

    int deleteByExample(tblClueRemarkExample example);

    int deleteByPrimaryKey(String id);

    int insert(tblClueRemark record);

    int insertSelective(tblClueRemark record);

    List<tblClueRemark> selectByExample(tblClueRemarkExample example);

    tblClueRemark selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") tblClueRemark record, @Param("example") tblClueRemarkExample example);

    int updateByExample(@Param("record") tblClueRemark record, @Param("example") tblClueRemarkExample example);

    int updateByPrimaryKeySelective(tblClueRemark record);

    int updateByPrimaryKey(tblClueRemark record);
}