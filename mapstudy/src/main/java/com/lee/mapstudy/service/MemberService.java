package com.lee.mapstudy.service;

import java.util.HashMap;
import java.util.Map;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.lee.mapstudy.boardDao.MemberDao;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberService {
	
	private final MemberDao memberDao;
	
	//회원가입
	@Transactional
	public Map<String, Object> insertM(Map<String, Object> params) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			memberDao.insertM(params);
			map.put("result", "success");
		}catch (Exception e) {
			map.put("result", "fail");
		}
		return map; 
	}
	//로그인
	public Map<String, Object> selectOne(Map<String, Object> params) {
		Map<String, Object> map = new HashMap<String, Object>();
//		System.out.println(memberDao.selectOne(params));
		try {
			memberDao.selectOne(params);
			map.put("result", "success");
		}catch (Exception e) {
			map.put("result", "fail");
			e.printStackTrace();
		}
		return map; 
	}
	//아이디 중복체크
	public int checkId(String id) {
		return memberDao.checkId(id);
	}
}
