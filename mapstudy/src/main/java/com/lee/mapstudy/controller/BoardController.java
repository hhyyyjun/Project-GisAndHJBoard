package com.lee.mapstudy.controller;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lee.mapstudy.boardDao.MemberDao;
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
	
	//게시판
	@GetMapping("/board")
	public String board() {
		System.out.println("board");
		return "/tiles/view/board/board";
	}
	//게시판
	@GetMapping("/boardAjax")
	public String boardAjax(Model model) {
		System.out.println("board");
		model.addAttribute("list", boardService.selectAllBoard());
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
	//글 상세보기
	@GetMapping("/boardContent/{bnum}")
	public String boardContent(@PathVariable("bnum") String bnum, Model model) {
		System.out.println("board");
		model.addAttribute("boardInfo", boardService.selectBoardInfo(bnum));
		return "/tiles/view/board/boardContent";
	}
	//글 삭제
	@GetMapping("/deleteB")
	public String deleteB() {
		System.out.println("deleteB");
		return "/tiles/view/board/board";
	}
	//글 수정
	@PostMapping("/updateB")
	public String updateB() {
		System.out.println("updateB");
		return "/tiles/view/board/boardEdit";
	}
}
