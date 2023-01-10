package com.lee.mapstudy.boardDao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.lee.mapstudy.boardDto.MemberDto;

public interface MemberDao {
	
	public int insertM(Map<String, Object> params);
	public Map<String, Object> selectOne(Map<String, Object> params);
	
}
