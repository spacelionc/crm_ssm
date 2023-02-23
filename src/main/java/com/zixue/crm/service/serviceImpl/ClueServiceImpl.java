package com.zixue.crm.service.serviceImpl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.zixue.crm.dao.ClueMapper;
import com.zixue.crm.domain.Clue;
import com.zixue.crm.service.ClueService;

@Service
public class ClueServiceImpl implements ClueService {
	@Autowired
	private ClueMapper clueMapper;

	@Override
	public int addClue(Clue clue) {
		int insert = clueMapper.insert(clue);
		return insert;
	}

	@Override
	public List<Clue> queryClueByConditionForPage(Clue clue) {
		List<Clue> selectClueByConditionForPage = clueMapper.selectClueByConditionForPage(clue);
		return selectClueByConditionForPage;
	}

	@Override
	public Clue getClueById(String id) {
		Clue selectByPrimaryKey = clueMapper.selectByPrimaryKey(id);
		return selectByPrimaryKey;
	}

	@Override
	public int editClueById(Clue clue) {
		int updateByPrimaryKey = clueMapper.updateByPrimaryKeySelective(clue);
		return updateByPrimaryKey;
	}

	@Override
	public Clue getClueDetailById(Clue clue) {
		List<Clue> selectClueByConditionForPage = clueMapper.selectClueByConditionForPage(clue);
		return selectClueByConditionForPage.get(0);
	}

}
