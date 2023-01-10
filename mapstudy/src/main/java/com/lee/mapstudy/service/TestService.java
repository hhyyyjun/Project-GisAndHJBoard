package com.lee.mapstudy.service;

import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.lee.mapstudy.boardDao.TestDao;

@Service
public class TestService {
	
	@Autowired TestDao testDao;
	
	public Map<String, Object> selectTest(Map<String, Object> params) {
		return testDao.selectTest(params);
	}
	
}
