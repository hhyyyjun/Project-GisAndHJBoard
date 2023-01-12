package com.lee.mapstudy.boardDao;

import java.util.List;
import java.util.Map;

public interface BoardDao {
	//글작성
	public int insertB(Map<String, Object> params);
	//글삭제
	public int deleteB(BoardDao boardDao);
	//글수정
	public int updateB(BoardDao boardDao);
	//게시판 목록
	public List<Map<String, Object>> selectAll();
}
