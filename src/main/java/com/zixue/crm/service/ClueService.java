package com.zixue.crm.service;

import java.util.List;

import com.zixue.crm.domain.Clue;

public interface ClueService {
	
	int addClue(Clue clue);
	
    List<Clue> queryClueByConditionForPage(Clue clue);

	Clue getClueById(String id);

	int editClueById(Clue clue);

	Clue getClueDetailById(Clue clue);

}
