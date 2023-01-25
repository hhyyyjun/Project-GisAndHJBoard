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
	public List<Map<String, Object>> selectReply(Map<String, Object> params){
		return replyDao.selectReply(params);
	}
}
