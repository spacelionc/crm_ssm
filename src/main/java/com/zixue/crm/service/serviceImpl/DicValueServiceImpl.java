package com.zixue.crm.service.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zixue.crm.dao.DicValueMapper;
import com.zixue.crm.domain.DicValue;
import com.zixue.crm.domain.DicValueExample;
import com.zixue.crm.domain.DicValueExample.Criteria;
import com.zixue.crm.service.DicValueService;

@Service
public class DicValueServiceImpl implements DicValueService {
	@Autowired
	private DicValueMapper dicValueMapper;

	@Override
	public List<DicValue> queryDicvalue(String typeCode) {
		// TODO Auto-generated method stub
		DicValueExample dicValueExample = new DicValueExample();
		Criteria createCriteria = dicValueExample.createCriteria();
		createCriteria.andTypeCodeEqualTo(typeCode);
		List<DicValue> selectByExample = dicValueMapper.selectByExample(dicValueExample);
		return selectByExample;
	}

}
