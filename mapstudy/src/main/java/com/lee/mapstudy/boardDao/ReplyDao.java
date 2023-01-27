package com.lee.mapstudy.boardDao;

import java.util.List;
import java.util.Map;

public interface ReplyDao {
	//시퀀스 증가
	public String checkRseq();
	//댓글 목록
	public List<Map<String, Object>> selectReply(Map<String, Object> params);
	//댓글 입력
	public int insertReply(Map<String, Object> params);
	//댓글 수정
	public int updateReply(Map<String, Object> params);
	//댓글 완전삭제
	public int deleteReplyA(Map<String, Object> params);
	//댓글 완전삭제 시 대댓글까지 삭제
	public int deleteRreplyA(Map<String, Object> params);
	//댓글 삭제되었습니다 문구 남기고 삭제
	public int deleteReply(Map<String, Object> params);
}
