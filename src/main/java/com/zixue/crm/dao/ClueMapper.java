package com.zixue.crm.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.zixue.crm.domain.Clue;
import com.zixue.crm.domain.ClueExample;

public interface ClueMapper {
    long countByExample(ClueExample example);

    int deleteByExample(ClueExample example);

    int deleteByPrimaryKey(String id);

    int insert(Clue record);

    int insertSelective(Clue record);

    List<Clue> selectByExample(ClueExample example);

    Clue selectByPrimaryKey(String id);

    int updateByExampleSelective(@Param("record") Clue record, @Param("example") ClueExample example);

    int updateByExample(@Param("record") Clue record, @Param("example") ClueExample example);

    int updateByPrimaryKeySelective(Clue record);

    int updateByPrimaryKey(Clue record);
    
    //根据条件查询线索
    List<Clue> selectClueByConditionForPage(Clue clue);
}