package com.lee.mapstudy.boardDao;

import java.util.Map;

public interface MemberDao {
	//회원가입
	public int insertM(Map<String, Object> params);
	//로그인
	public Map<String, Object> selectOne(Map<String, Object> params);
	//아이디 중복검사
	//추가될 데이터가 없는 단일 파라미터인 경우 String
	public int checkId(String id);
}
