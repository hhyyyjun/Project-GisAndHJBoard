package com.lee.mapstudy.boardDao;

import java.util.List;
import java.util.Map;

import com.lee.mapstudy.boardDto.PagingContentDto;

public interface BoardDao {
	//게시판 목록
	public List<Map<String, Object>> selectAllBoard();
	
	public List<Map<String, Object>> boardList(PagingContentDto pcd) throws Exception;
	public int boardListCnt() throws Exception;

	
	//글작성
	public int insertBoard(Map<String, Object> params);
	//글삭제
	public int deleteBoard(Map<String, Object> param);
	//글수정
	public int updateBoard(BoardDao boardDao);
	//게시글 상세페이지
	public Map<String, Object> selectBoardInfo(String bnum);
	//시퀀스 마지막 값 확인
	public String checkSeq();
	//게시글 수정페이지
	public Map<String, Object> selectBoardInfo(Map<String, Object> param);
}
