package com.zixue.crm.service;

import java.util.List;

import com.zixue.crm.domain.DicValue;

public interface DicValueService {
	
	//根据数据字典类型查询数据类型的值

	List<DicValue> queryDicvalue(String typeCode);
	
	
}
