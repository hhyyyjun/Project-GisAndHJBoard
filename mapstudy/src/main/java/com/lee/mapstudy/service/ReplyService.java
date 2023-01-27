package com.lee.mapstudy.service;

import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Service;
import com.lee.mapstudy.boardDao.ReplyDao;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReplyService {
	
	private final ReplyDao replyDao;
	//댓글 입력
	public int insertReply(Map<String, Object> params) {
		String rseq = replyDao.checkRseq();
		params.put("rnum", rseq);
		try{
			replyDao.insertReply(params);
			return 1;
		}catch(Exception e) {
			return 0;
		}
	}
	//댓글 수정
	public int updateReply(Map<String, Object> params) {
		try{
			replyDao.updateReply(params);
			return 1;
		}catch(Exception e) {
			return 0;
		}
	}
	//댓글 완전 삭제
	public int deleteReplyA(Map<String, Object> params) {
		try{
			replyDao.deleteRreplyA(params);
			replyDao.deleteReplyA(params);
			return 1;
		}catch(Exception e) {
			return 0;
		}
	}
	//댓글 삭제 문구 남기기
	public int deleteReply(Map<String, Object> params) {
		try{
			replyDao.deleteReply(params);
			return 1;
		}catch(Exception e) {
			return 0;
		}
	}
	//댓글 목록 출력
	public List<Map<String, Object>> selectReply(Map<String, Object> params){
		return replyDao.selectReply(params);
	}
}