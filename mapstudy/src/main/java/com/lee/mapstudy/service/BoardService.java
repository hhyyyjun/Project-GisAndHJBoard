package com.lee.mapstudy.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import com.lee.mapstudy.boardDao.BoardDao;
import com.lee.mapstudy.boardDto.BoardDto;
import com.lee.mapstudy.boardDto.PagingContentDto;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardService {
	
	private final BoardDao boardDao;
	//게시판 목록
	public List<Map<String, Object>> boardList(Map<String, Object> params, PagingContentDto pcd) throws Exception {
		return boardDao.boardList(params, pcd);
	}
	//글의 총 개수 확인
	public int boardListCnt(Map<String, Object> params) throws Exception {
        return boardDao.boardListCnt(params);
	}
	//카테고리 목록
	public List<Map<String, Object>> categoryList(){
		return boardDao.categoryList();
	}
	//카테고리 추가
	public int insertCate(Map<String, Object> params) {
		try{
			boardDao.insertCate(params);
			return 1;
		}catch(Exception e) {
			return 0;
		}
	}
	//카테고리 삭제
	public int deleteCate(Map<String, Object> params) {
		try{
			boardDao.deleteCate(params);
			return 1;
		}catch(Exception e) {
			return 0;
		}
	}
	
	//댓글 검색 시 목록
	public List<Map<String, Object>> replySearchList(Map<String, Object> params, PagingContentDto pcd) throws Exception {
		return boardDao.replySearchList(params, pcd);
	}
	public int ReplyListCnt(Map<String, Object> params) throws Exception {
		return boardDao.ReplyListCnt(params);
	}
	
	//썸네일
	public Map<String, Object> thumnail(List<String> idList){
		return boardDao.thumnail(idList);
	}
	
	//글 작성
	@Transactional
	public Map<String, Object> insertBoard(Map<String, Object> params) {
		Map<String, Object> result = new HashMap<String, Object>();
		
		try {
			String lastSeq = boardDao.checkSeq();
			params.put("bnum", lastSeq);
			
			//게시판 글등록
			boardDao.insertBoard(params);
			
			String fileSeq = String.valueOf(params.get("fileSeq"));
			
			//null이
			if(!StringUtils.isEmpty(fileSeq)) {
				String[] fileSeqArr = fileSeq.split(",");
				
				for(int i=0; i<fileSeqArr.length; i++) {
					params.put("fnum", fileSeqArr[i]);
					//파일 insert
					//보드파일 등록
					params.put("bfnum", boardDao.checkBFseq());
					boardDao.insertFileBoard(params);
				}
			}
			result.put("result", "success");
		}catch (Exception e) {
			result.put("result", "fail");
			e.printStackTrace();
		}
		return result;
	}
	//파일저장
	public String insertFile(Map<String, Object> params){
		String lastSeq = boardDao.checkFseq();
		params.put("fnum", lastSeq);
		boardDao.insertFile(params);
		return lastSeq;
	}
	//파일 체크
	public Map<String, Object> fileCheck(String params) {
		return boardDao.fileCheck(params);
	}
	//파일 다운로드
	public Map<String, Object> downloadFile(String params) {
		return boardDao.downloadFile(params);
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
	public Map<String, Object> updateBoard(Map<String, Object> params) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			boardDao.updateBoard(params);
			map.put("result", "success");
		} catch(Exception e) {
			map.put("result", "fail");
		}
		return map;
	}
	//게시글 상세페이지
	public Map<String, Object> selectBoardInfo(String bnum){
		return boardDao.selectBoardInfo(bnum);
	}
	public List<Map<String, Object>> attachFileList(String bnum){
		return boardDao.attachFileList(bnum);
	}
	//첨부파일 삭제
	public Map<String, Object> deleteAttachFile(Map<String, Object> params) {
		boardDao.deleteAttachFile(params);
		return params;
	}
	
	
	//게시글 수정페이지
	public Map<String, Object> selectBoardInfo(Map<String, Object> param){
		return boardDao.selectBoardInfo(param);
	}
}
