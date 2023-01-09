package com.lee.mapstudy.service;

import com.lee.mapstudy.boardDto.BoardDto;
import com.lee.mapstudy.boardDto.MemberDto;

public interface Service {
	public MemberDto SelectOne(MemberDto mdto, BoardDto bdto);
	public boolean delete(MemberDto mdto, BoardDto bdto);
	public boolean insert(MemberDto mdto, BoardDto bdto);
	public boolean update(MemberDto mdto, BoardDto bdto);
	public int checkId(MemberDto mdto);
}
