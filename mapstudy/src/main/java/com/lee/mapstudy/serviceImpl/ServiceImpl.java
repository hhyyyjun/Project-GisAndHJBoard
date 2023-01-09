package com.lee.mapstudy.serviceImpl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.lee.mapstudy.boardDao.MemberDao;
import com.lee.mapstudy.boardDto.BoardDto;
import com.lee.mapstudy.boardDto.MemberDto;
import com.lee.mapstudy.service.memberService;

@Service("serviceImpl")
public class ServiceImpl implements memberService{
	@Autowired
	private MemberDao Memberdao;
	
	public void insert(MemberDto mdto) {
		Memberdao.insertMember(mdto);
	}

	@Override
	public MemberDto SelectOne(MemberDto mdto, BoardDto bdto) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public boolean delete(MemberDto mdto, BoardDto bdto) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void insert(MemberDto mdto, BoardDto bdto) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public boolean update(MemberDto mdto, BoardDto bdto) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public int checkId(MemberDto mdto) {
		// TODO Auto-generated method stub
		return 0;
	}
}
