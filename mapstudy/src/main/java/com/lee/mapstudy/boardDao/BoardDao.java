package com.lee.mapstudy.boardDao;

import java.util.Map;

import com.lee.mapstudy.boardDto.BoardDto;

public interface BoardDao {
	
	public int insertB(Map<String, Object> params);
	public int deleteB(BoardDao boardDao);
	public int updateB(BoardDao boardDao);
	public BoardDto selectAll(BoardDto bdto);
}
