package com.lee.mapstudy.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import com.lee.mapstudy.boardDto.MemberDto;

@Controller
public class BoardController {
	
	@RequestMapping("/login")
	public String main() {
		System.out.println("login");
		return "/tiles/view/auth/login";
	}
	@RequestMapping("/join")
	public String join() {
		System.out.println("join");
		return "/tiles/view/auth/join";
	}
	@RequestMapping("/joinMember")
	public String joinMember(MemberDto mdto, Model model) {
		System.out.println("joinMember");
		model.addAttribute("userId", mdto.getMid());
		model.addAttribute("userRole", mdto.getMrole());
		return "/tiles/view/auth/board";
	}
	@RequestMapping("/useredit")
	public String useredit() {
		System.out.println("useredit");
		return "/tiles/view/auth/useredit";
	}
	@RequestMapping("/board")
	public String board() {
		System.out.println("board");
		return "/tiles/view/board/board";
	}
	@RequestMapping("/content")
	public String boardedit() {
		System.out.println("boardedit");
		return "/tiles/view/board/boardedit";
	}
	@RequestMapping("/contentedit")
	public String contentedit() {
		System.out.println("contentedit");
		return "/tiles/view/board/contentedit";
	}
}
