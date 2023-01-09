package com.lee.mapstudy.service;

import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

import com.lee.mapstudy.boardDto.BoardDto;
import com.lee.mapstudy.boardDto.MemberDto;

@Repository
@Mapper
public interface memberService {
	public MemberDto SelectOne(MemberDto mdto, BoardDto bdto);
	public boolean delete(MemberDto mdto, BoardDto bdto);
	public void insert(MemberDto mdto, BoardDto bdto);
	public boolean update(MemberDto mdto, BoardDto bdto);
	public int checkId(MemberDto mdto);
}

