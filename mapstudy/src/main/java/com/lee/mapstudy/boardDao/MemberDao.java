package com.lee.mapstudy.boardDao;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.lee.mapstudy.boardDto.MemberDto;

@Repository("memberDao")
public class MemberDao {
	
	@Autowired
	private SqlSessionTemplate mybatis;
	
	public void insertMember(MemberDto mdto) {
		mybatis.insert("MemberDto.insertMember" , mdto);
	}
}
