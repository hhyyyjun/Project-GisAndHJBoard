package com.lee.mapstudy.controller;

import java.util.Map;

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
	public Map<String, Object> loginMember(@RequestBody Map<String, Object> params, MemberDto mdto, Model model) {
		System.out.println("loginMember");
		System.out.println(params);
		System.out.println(memberService.selectOne(params));
		
		model.addAttribute("userId", mdto.getMid());
		model.addAttribute("userRole", mdto.getMrole());
		return memberService.selectOne(params);
	}
	//회원가입 화면
	@GetMapping("/join")
	public String join() {
		System.out.println("join");
		return "/tiles/view/auth/join";
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
	
	
	
	@GetMapping("/board")
	public String board(BoardDto boardDto, Model model) {
		
		
		System.out.println("board");
		return "/tiles/view/board/board";
	}
	@GetMapping("/insertB")
	public String insertB() {
		System.out.println("insertB");
		return "/tiles/view/board/board";
	}
	@GetMapping("/deleteB")
	public String deleteB() {
		System.out.println("deleteB");
		return "/tiles/view/board/board";
	}
	@RequestMapping("/updateB")
	public String updateB() {
		System.out.println("updateB");
		return "/tiles/view/board/boardedit";
	}
}
