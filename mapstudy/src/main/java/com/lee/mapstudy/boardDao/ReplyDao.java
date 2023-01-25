package com.lee.mapstudy.boardDao;

import java.util.List;
import java.util.Map;

public interface ReplyDao {
	
	public int insertReply(Map<String, Object> params);
	public String checkRseq();
	public List<Map<String, Object>> selectReply(Map<String, Object> params);
}
