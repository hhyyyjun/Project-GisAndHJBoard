package com.lee.mapstudy.boardDao;

import java.util.Map;

import com.lee.mapstudy.boardDto.BoardDto;

public interface BoardDao {
	//글작성
	public int insertB(Map<String, Object> params);
	//글삭제
	public int deleteB(BoardDao boardDao);
	//글수정
	public int updateB(BoardDao boardDao);
	//게시판 목록
	public BoardDto selectAll(BoardDto bdto);
}
