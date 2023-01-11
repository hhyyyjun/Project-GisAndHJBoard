package com.lee.mapstudy.controller;

import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lee.mapstudy.boardDto.BoardDto;
import com.lee.mapstudy.boardDto.MemberDto;
import com.lee.mapstudy.service.MemberService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class BoardController {
	
	private final MemberService memberService;
	//로그인 화면
	@GetMapping("/login")
	public String login(MemberDto mdto, Model model) {
		System.out.println("login");
		return "/tiles/view/auth/login";
	}
	//로그인 클릭 시
	@PostMapping("/loginMember")
	@ResponseBody
	public Map<String, Object> loginMember(@RequestBody Map<String, Object> params, HttpSession session) {
		System.out.println("loginMember");
		return memberService.selectOne(params, session);
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
		
		return memberService.insertM(params);
	}
	@RequestMapping("/useredit")
	public String useredit() {
		System.out.println("useredit");
		return "/tiles/view/auth/useredit";
	}
	
	
	//게시판
	@GetMapping("/board")
	public String board(BoardDto boardDto, Model model) {
		System.out.println("board");
		return "/tiles/view/board/board";
	}
	//글 상세보기
	@GetMapping("/boardContent")
	public String boardContent(BoardDto boardDto, Model model) {
		System.out.println("board");
		return "/tiles/view/board/boardContent";
	}
	//글 작성화면
	@GetMapping("/boardWrite")
	public String boardWrite(BoardDto boardDto, Model model) {
		System.out.println("board");
		return "/tiles/view/board/boardWrite";
	}
	//글 작성
	@PostMapping("/insertB")
	public String insertB() {
		System.out.println("insertB");
		return "/tiles/view/board/board";
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
