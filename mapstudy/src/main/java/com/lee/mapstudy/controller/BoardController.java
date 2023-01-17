package com.lee.mapstudy.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.JsonObject;
import com.lee.mapstudy.boardDao.MemberDao;
import com.lee.mapstudy.boardDto.PagingContentDto;
import com.lee.mapstudy.boardDto.PagingDto;
import com.lee.mapstudy.service.BoardService;
import com.lee.mapstudy.service.MemberService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class BoardController {
	
	private final MemberService memberService;
	private final BoardService boardService;
	private final MemberDao memeDao;
	
	//로그인 화면
	@GetMapping("/login")
	public String login() {
		System.out.println("login");
		return "/tiles/view/auth/login";
	}
	//로그아웃
	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate();
		System.out.println("logout");
		return "/tiles/view/auth/login";
	}
	//로그인 클릭 시
	@PostMapping("/loginMember")
	@ResponseBody
	public Map<String, Object> selectLoginMember(@RequestBody Map<String, Object> params, HttpSession session) {
		System.out.println("loginMember");
		return memberService.selectLoginMember(params, session);
	}
	//회원가입 화면
	@GetMapping("/join")
	public String join() {
		System.out.println("join");
		return "/tiles/view/auth/join";
	}
	//아이디 중복검사
	@PostMapping("/checkId")
	@ResponseBody
	public int checkId(@RequestBody Map<String, Object> param) {
		System.out.println("checkId");
		return memberService.checkId((String)param.get("id"));
	}
	//회원가입 클릭 시
	@PostMapping("/joinMember")
	@ResponseBody
	public Map<String, Object> joinMember(@RequestBody Map<String, Object> params) throws Exception {
		System.out.println("joinMember");
		System.out.println(params);
		
		return memberService.insertMember(params);
	}
	//회원 정보화면
	@GetMapping("/myInfo")
	public String myInfo(HttpSession session, Model model) {
		System.out.println("myInfo");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", session.getAttribute("userId"));
		model.addAttribute("myInfo", memeDao.userInfo(params));
		return "/tiles/view/auth/myInfo";
	}
	//회원 정보 변경
	@PostMapping("/updateM")
	@ResponseBody
	public Map<String, Object> updateMemberInfo(@RequestBody Map<String, Object> param, HttpSession session){
		System.out.println("updateM");
		Map<String, Object> params = new HashMap<String, Object>();
		params.putAll(param);
		params.put("id", session.getAttribute("userId"));
		return memberService.updateMemberInfo(params);
	}
	
	//////////////////////////////////////////////////////////
	
	//게시판 & 페이징
	@GetMapping("/board")
	public String board() throws Exception {
		System.out.println("board");
		
		return "/tiles/view/board/board";
	}
	//게시판
	@GetMapping("/boardAjax/{bnum}")
	public String boardAjax(@PathVariable int bnum,PagingContentDto pcd, Model model) throws Exception {
		System.out.println("board");
		// 전체 글 개수
        int boardListCnt = boardService.boardListCnt();
        
        pcd.setPage(bnum);
        
        // 페이징 객체
        PagingDto paging = new PagingDto();
        paging.setPcd(pcd);
        paging.setTotalCount(boardListCnt);  
        model.addAttribute("paging", paging);
        model.addAttribute("page", pcd.getPage());
		model.addAttribute("list", boardService.boardList(pcd));
		
		return "/tiles/ajax/ajax/ajax-board";
	}
	//글 작성화면
	@GetMapping("/boardWrite")
	public String boardWrite() {
		System.out.println("board");
		return "/tiles/view/board/boardWrite";
	}
	//글 작성
	@PostMapping("/insertB")
	@ResponseBody
	public Map<String, Object> insertB(@RequestBody Map<String, Object> params) {
		System.out.println("insertB");
		System.out.println(params);
		return boardService.insertBoard(params);
	}
//	@PostMapping(value="/uploadSummernoteImageFile", produces = "application/json")
//	@ResponseBody
//	public JsonObject uploadSummernoteImageFile(@RequestParam("file") MultipartFile multipartFile) {
//		
//		JsonObject jsonObject = new JsonObject();
//		
//		String fileRoot = "C:\\summernote_image\\";	//저장될 외부 파일 경로
//		String originalFileName = multipartFile.getOriginalFilename();	//오리지날 파일명
//		String extension = originalFileName.substring(originalFileName.lastIndexOf("."));	//파일 확장자
//				
//		String savedFileName = UUID.randomUUID() + extension;	//저장될 파일 명
//		
//		File targetFile = new File(fileRoot + savedFileName);	
//		
//		try {
//			InputStream fileStream = multipartFile.getInputStream();
//			FileUtils.copyInputStreamToFile(fileStream, targetFile);	//파일 저장
//			jsonObject.addProperty("url", "/summernoteImage/"+savedFileName);
//			jsonObject.addProperty("responseCode", "success");
//				
//		} catch (IOException e) {
//			FileUtils.deleteQuietly(targetFile);	//저장된 파일 삭제
//			jsonObject.addProperty("responseCode", "error");
//			e.printStackTrace();
//		}
//		
//		return jsonObject;
//	}
	//글 상세보기
	@GetMapping("/boardContent/{bnum}")
	public String boardContent(@PathVariable("bnum") String bnum, Model model, HttpSession session) {
		System.out.println("board");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", session.getAttribute("userId"));
		model.addAttribute("myInfo", memeDao.userInfo(params));
		model.addAttribute("boardInfo", boardService.selectBoardInfo(bnum));
		return "/tiles/view/board/boardContent";
	}
	//글 삭제
	@PostMapping("/deleteB")
	@ResponseBody
	public Map<String, Object> deleteB(@RequestBody Map<String, Object> param) {
		System.out.println("deleteB");
		return boardService.deleteBoard(param);
	}
	//글 수정 페이지
	@GetMapping("/boardEdit/{bnum}")
	public String boardEdit(@PathVariable("bnum") String bnum, Model model) {
		System.out.println("boardEdit");
		model.addAttribute("editList", boardService.selectBoardInfo(bnum));
		return "/tiles/view/board/boardEdit";
	}
	//글 수정
	@PostMapping("/updateB")
	@ResponseBody
	public Map<String, Object> updateB(@RequestBody Map<String, Object> params) {
		System.out.println("updateB");
		return boardService.updateBoard(params);
	}
	
	
	
	
	
	
	
	
	
	
	
}
