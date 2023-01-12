package com.lee.mapstudy.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.lee.mapstudy.boardDao.BoardDao;
import com.lee.mapstudy.boardDto.BoardDto;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardService {
	
	private final BoardDao boardDao;
	
	//글 작성
	@Transactional
	public Map<String, Object> insertB(Map<String, Object> params) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			boardDao.insertB(params);
			map.put("result", "success");
		}catch (Exception e) {
			map.put("result", "fail");
//			e.printStackTrace();
		}
		return map; 
	}
	//글 삭제
	public int deleteB(BoardDto boardDto) {
		return boardDao.deleteB(boardDao);
	}
	//글 수정
	public int updateB(BoardDto boardDto) {
		return boardDao.updateB(boardDao);
	}
	//게시판 전체 글
	public List<Map<String, Object>> selectAll() {
		List<Map<String, Object>> boardList = boardDao.selectAll();
		return boardList;
	}
}
