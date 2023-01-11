package com.lee.mapstudy.boardDao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.lee.mapstudy.boardDto.MemberDto;

public interface MemberDao {
	//회원가입
	public int insertM(Map<String, Object> params);
	//로그인
	public Map<String, Object> selectOne(Map<String, Object> params);
	//아이디 중복검사
	public int checkId(String id);
	
}
