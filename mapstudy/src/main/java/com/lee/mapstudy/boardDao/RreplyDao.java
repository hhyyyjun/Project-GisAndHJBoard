package com.lee.mapstudy.boardDao;

import java.util.List;
import java.util.Map;

public interface RreplyDao {
	//대댓글 시퀀스
	public String checkRrseq();
	//대댓글 목록
	public List<Map<String, Object>> selectRreply(Map<String, Object> params);
	//대댓글 유저
	public Map<String, Object> selectMember(Map<String, Object> params);
	//대댓글 입력
	public int insertRreply(Map<String, Object> params);
	//대댓글 수정&삭제
	public int updateOrDeleteRR(Map<String, Object> params);
}
