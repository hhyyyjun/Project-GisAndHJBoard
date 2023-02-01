package com.lee.mapstudy.boardDao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.lee.mapstudy.boardDto.PagingContentDto;

public interface BoardDao {
	//게시판 목록
	public List<Map<String, Object>> boardList(@Param(value="params") Map<String, Object> params,@Param(value="page") PagingContentDto pcd) throws Exception;
	public int boardListCnt(@Param(value="params") Map<String, Object> params) throws Exception;
	//댓글 검색 시 목록
	public List<Map<String, Object>> replySearchList(@Param(value="params") Map<String, Object> params,@Param(value="page") PagingContentDto pcd) throws Exception;
	public int ReplyListCnt(@Param(value="params") Map<String, Object> params) throws Exception;
	
	//카테고리 목록
	public List<Map<String, Object>> categoryList();
	//카테고리 추가
	public int insertCate(Map<String, Object> params);
	//카테고리 삭제
	public int deleteCate(Map<String, Object> params);
	
	//글작성
	//시퀀스 마지막 값 확인
	public String checkSeq();
	public int insertBoard(Map<String, Object> params);
	
	//파일 테이블에 저장
	public String checkFseq();
	public void insertFile(Map<String, Object> params);
	
	//파일 다운로드
	public Map<String, Object> downloadFile(String params);
	
	//보드 파일 저장
	public int fnumSeq();
	public String checkBFseq();
	public void insertFileBoard(Map<String, Object> params);
	//썸네일
	public Map<String, Object> thumnail(List<String> idList);
	
	//파일체크
	public Map<String, Object> fileCheck(String params);
	
	//글삭제
	public int deleteBoard(Map<String, Object> param);
	//글수정
	public int updateBoard(Map<String, Object> params);
	//게시글 상세페이지
	public Map<String, Object> selectBoardInfo(String bnum);
	
	public List<Map<String, Object>> attachFileList(String bnum);
	//첨부파일 삭제
	public int deleteAttachFile(Map<String, Object> params);
	
	//게시글 수정페이지
	public Map<String, Object> selectBoardInfo(Map<String, Object> param);
}
