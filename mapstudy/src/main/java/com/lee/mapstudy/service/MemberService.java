package com.lee.mapstudy.service;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpSession;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
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
	public Map<String, Object> insertMember(Map<String, Object> params) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
			params.put("pw", passwordEncoder.encode(String.valueOf(params.get("pw"))));
			
			memberDao.insertMember(params);
			map.put("result", "success");
		}catch (Exception e) {
			map.put("result", "fail");
		}
		return map; 
	}
	//아이디 중복검사
	public int checkId(String id) {
		return memberDao.checkId(id);
	}
	//회원정보 페이지
	public Map<String, Object> userInfo(Map<String, Object> params){
		Map<String, Object> userInfo = memberDao.userInfo(params);
		return userInfo;
	}
	//회원정보 변경
	public Map<String, Object> updateMemberInfo(Map<String, Object> params){
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			memberDao.updateMemberInfo(params);
			map.put("result", "success");
		}catch (Exception e) {
			map.put("result", "fail");
		}
		return map; 
	}
	
}
