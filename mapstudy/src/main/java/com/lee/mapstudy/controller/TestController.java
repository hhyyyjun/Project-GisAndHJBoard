package com.lee.mapstudy.controller;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import com.lee.mapstudy.boardDao.TestDao;
import com.lee.mapstudy.service.TestService;

import lombok.RequiredArgsConstructor;

@Controller
public class TestController {
	
	private final TestDao testDao;
	
	  public TestController(TestDao testDao) {
		  this.testDao = testDao;
	  }
	
	//select 
	@GetMapping("/test")
	public Map<String, Object> test(Map<String, Object> params) throws Exception{
		return testDao.selectTest(params);
	}

}
