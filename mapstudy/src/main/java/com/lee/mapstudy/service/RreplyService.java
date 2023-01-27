package com.lee.mapstudy.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.lee.mapstudy.boardDao.RreplyDao;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RreplyService {
	
	private final RreplyDao rreplyDao;
	
	//대댓글 유저
	public Map<String, Object> selectMember(Map<String, Object> params){
		return rreplyDao.selectMember(params);
	}
	//대댓글 목록
	public List<Map<String, Object>> selectRreply(Map<String, Object> params){
		return rreplyDao.selectRreply(params);
	}
	//대댓글 입력
	public int insertRreply(Map<String, Object> params) {
		String rrseq = rreplyDao.checkRrseq();
		params.put("rrnum", rrseq);
		try{
			rreplyDao.insertRreply(params);
			return 1;
		}catch(Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
	//대댓글 수정&삭제
	public int updateOrDeleteRR(Map<String, Object> params) {
		try{
			rreplyDao.updateOrDeleteRR(params);
			return 1;
		}catch(Exception e) {
			e.printStackTrace();
			return 0;
		}
	}
}
