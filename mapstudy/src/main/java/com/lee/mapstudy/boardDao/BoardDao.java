package com.lee.mapstudy.boardDao;

import java.util.List;
import java.util.Map;

public interface BoardDao {
	//게시판 목록
	public List<Map<String, Object>> selectAllBoard();
	//글작성
	public int insertBoard(Map<String, Object> params);
	//글삭제
	public int deleteBoard(BoardDao boardDao);
	//글수정
	public int updateBoard(BoardDao boardDao);
	//게시글 상세페이지
	public Map<String, Object> selectBoardInfo(String bnum);
}
