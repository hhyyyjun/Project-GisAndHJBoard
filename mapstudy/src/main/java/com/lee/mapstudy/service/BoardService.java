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
	
	//게시판 목록
	public List<Map<String, Object>> selectAllBoard() {
		List<Map<String, Object>> boardList = boardDao.selectAllBoard();
		return boardList;
	}
	//글 작성
	@Transactional
	public Map<String, Object> insertBoard(Map<String, Object> params) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			String lastSeq = boardDao.checkSeq();
			params.put("bnum", lastSeq);
			
			boardDao.insertBoard(params);
			map.put("result", "success");
		}catch (Exception e) {
			map.put("result", "fail");
			e.printStackTrace();
		}
		return map;
	}
	//글 삭제
	public Map<String, Object> deleteBoard(Map<String, Object> param) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			boardDao.deleteBoard(param);
			map.put("result", "success");
		}catch (Exception e) {
			map.put("result", "fail");
		}
		return map;
	}
	//글 수정
	public int updateBoard(BoardDto boardDto) {
		return boardDao.updateBoard(boardDao);
	}
	//게시글 상세페이지
	public Map<String, Object> selectBoardInfo(String bnum){
		return boardDao.selectBoardInfo(bnum);
	}
	//게시글 수정페이지
	public Map<String, Object> selectBoardInfo(Map<String, Object> param){
		return boardDao.selectBoardInfo(param);
	}
}
