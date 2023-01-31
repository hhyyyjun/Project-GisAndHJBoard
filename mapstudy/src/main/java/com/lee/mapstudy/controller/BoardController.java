package com.lee.mapstudy.controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.MalformedURLException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.Principal;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.util.UriUtils;

import com.lee.mapstudy.boardDao.MemberDao;
import com.lee.mapstudy.boardDto.PagingContentDto;
import com.lee.mapstudy.boardDto.PagingDto;
import com.lee.mapstudy.service.BoardService;
import com.lee.mapstudy.service.MemberService;
import com.lee.mapstudy.service.ReplyService;
import com.lee.mapstudy.service.RreplyService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class BoardController {
	
	private final MemberService memberService;
	private final BoardService boardService;
	private final ReplyService replyService;
	private final RreplyService rreplyService;
	private final MemberDao memeDao;
	
	//로그인 화면
	@GetMapping("/login")
	public String login(HttpServletResponse res, Principal principal) throws IOException {
		
		if(principal != null) {
			res.sendRedirect("/board");
		}
		
		System.out.println("login");
		return "/tiles/view/auth/login";
	}
	//로그아웃
//	@GetMapping("/logout")
//	public String logout(HttpSession session) {
//		session.invalidate();
//		System.out.println("logout");
//		return "/tiles/view/auth/login";
//	}
	//회원가입 화면
	@GetMapping("/join")
	public String join(HttpServletResponse res, Principal principal) throws IOException {
		
		if(principal != null) {
			res.sendRedirect("/board");
		}
		
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
	@GetMapping("/boardAjax/{pageNum}")
	public String boardAjax(@PathVariable int pageNum, @RequestParam Map<String, Object> params, PagingContentDto pcd, Model model) throws Exception {
		System.out.println("board");
		//페이징 객체
		PagingDto paging = new PagingDto();
		int boardListCnt = 0;

		if("2".equals(params.get("optionVal"))) {
			// 전체 글 개수
	        boardListCnt = boardService.ReplyListCnt(params);
	        
	        pcd.setPage(pageNum);
	        
	        paging.setPcd(pcd);
	        paging.setTotalCount(boardListCnt);  
	        
	        model.addAttribute("paging", paging);
	        model.addAttribute("page", pcd.getPage());
			model.addAttribute("list", boardService.replySearchList(params, pcd));
		}
		if("1".equals(params.get("optionVal"))) {
			// 전체 글 개수
	        boardListCnt = boardService.boardListCnt(params);
	        
	        pcd.setPage(pageNum);
	        
	        paging.setPcd(pcd);
	        paging.setTotalCount(boardListCnt);  
	        model.addAttribute("paging", paging);
	        model.addAttribute("page", pcd.getPage());
			model.addAttribute("list", boardService.boardList(params, pcd));
		}
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
		Map<String, Object> boardWright = new HashMap<String, Object>();
		boardWright.putAll(params);
		boardWright.put("text" ,((String)params.get("bcontent")).replaceAll("<([^>]+)>", ""));
		
		//게시판 글등록
		return boardService.insertBoard(boardWright);
	}
	//파일 업로드
	@PostMapping(value="/uploadSummernoteImageFile", produces = "application/json")
	@ResponseBody
	public Map<String, Object> uploadSummernoteImageFile(@RequestParam("file") MultipartFile multipartFile) {
		Map<String, Object> result = new HashMap<String, Object>();
		Map<String, Object> fileInput = new HashMap<String, Object>();
		String fileRoot = "C:\\summernote_image\\";	//저장될 외부 파일 경로
		String originalFileName = multipartFile.getOriginalFilename();	//오리지날 파일명
		String extension = originalFileName.substring(originalFileName.lastIndexOf(".")); //파일 확장자
				
		String savedFileName = UUID.randomUUID() + extension; //저장될 파일 명
		
		File targetFile = new File(fileRoot + savedFileName);	
		
		fileInput.put("fileroot", fileRoot);
		fileInput.put("sfname", savedFileName);
		fileInput.put("ofname", originalFileName);
		fileInput.put("extension", extension);
		
		
		try {
			String fileSeq = boardService.insertFile(fileInput);
			InputStream fileStream = multipartFile.getInputStream();
			FileUtils.copyInputStreamToFile(fileStream, targetFile); //파일 저장
			result.put("url", "/thubnail/"+fileSeq);
			result.put("responseCode", "success");
		} catch (IOException e) {
			FileUtils.deleteQuietly(targetFile); //저장된 파일 삭제
			result.put("responseCode", "error");
			e.printStackTrace();
		}
		return result;
	}
	//첨부파일 다운로드
	@GetMapping("/download/{fnum}")
	public ResponseEntity<Resource> downloadAttach(@PathVariable String fnum) throws MalformedURLException {
		 //...itemId 이용해서 고객이 업로드한 파일 이름인 uploadFileName랑 서버 내부에서 사용하는 파일 이름인 storeFileName을 얻는다는 내용은 생략
	    Map<String, Object> fileInfo = boardService.downloadFile(fnum);
	    String filePath = String.valueOf(fileInfo.get("fileroot"));
	    String serverFileName = String.valueOf(fileInfo.get("sfilename"));
	    String originalName = String.valueOf(fileInfo.get("ofilename"));
	    
	    
	    UrlResource resource = new UrlResource("file:" + filePath + serverFileName);
	    
	    //한글 파일 이름이나 특수 문자의 경우 깨질 수 있으니 인코딩 한번 해주기
	    String encodedUploadFileName = UriUtils.encode(originalName,
	    StandardCharsets.UTF_8);
	    
	    //아래 문자를 ResponseHeader에 넣어줘야 한다. 그래야 링크를 눌렀을 때 다운이 된다.
	    //정해진 규칙이다.
	    String contentDisposition = "attachment; filename=\"" + encodedUploadFileName + "\"";
	    
	    return ResponseEntity.ok()
	 			.header(HttpHeaders.CONTENT_DISPOSITION, contentDisposition)
			 	.body(resource);
	}
	//첨부파일 삭제
	@PostMapping("/deleteAttachFile")
	@ResponseBody
	public Map<String, Object> deleteAttachFile(@RequestBody Map<String, Object> param) {
		return boardService.deleteAttachFile(param);
	}
	
	//썸네일 url 변경
	@GetMapping("/thubnail/{fileseq}")
	public ResponseEntity<Resource> thubnail(@PathVariable("fileseq") String seq) {
		Map<String, Object> fileCheck = boardService.fileCheck(seq);
		
		String path = "";
		String filename = "";
		if(fileCheck!=null) {
			path = String.valueOf(fileCheck.get("fileroot"));
			filename = String.valueOf(fileCheck.get("sfilename"));
		}
		
		Resource resource = new FileSystemResource(path + filename);
		if(!resource.exists()) 
			return new ResponseEntity<Resource>(HttpStatus.NOT_FOUND);
			HttpHeaders header = new HttpHeaders();
			Path filePath = null;
		try{
			filePath = Paths.get(path + filename);
			header.add("Content-type", Files.probeContentType(filePath));
		}catch(IOException e) {
			e.printStackTrace();
		}
		return new ResponseEntity<Resource>(resource, header, HttpStatus.OK);
	}
	
	//글 상세보기
	@GetMapping("/boardContent/{bnum}")
	public String boardContent(@PathVariable("bnum") String bnum, Model model, HttpSession session) {
		System.out.println("board");
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("id", session.getAttribute("userId"));
		model.addAttribute("myInfo", memeDao.userInfo(params));
		model.addAttribute("boardInfo", boardService.selectBoardInfo(bnum));
		model.addAttribute("fileInfo", boardService.attachFileList(bnum));
		
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
		Map<String, Object> boardWright = new HashMap<String, Object>();
		boardWright.putAll(params);
		boardWright.put("text" ,((String)params.get("bcontent")).replaceAll("<([^>]+)>", ""));
		return boardService.updateBoard(boardWright);
	}
	
	////////////////////////////////////////////////////////////////////////////////////
	//댓글 입력
	@PostMapping("/replyInput")
	@ResponseBody
	public String replyInsert(@RequestBody Map<String, Object> params, HttpSession session){
		params.put("mid", session.getAttribute("userId"));
		replyService.insertReply(params);
		
		String bnum = (String) params.get("bnum");
		return bnum;
	}
	//댓글수정
	@PostMapping("/updateReply")
	@ResponseBody
	public int updateReply(@RequestBody Map<String, Object> params) {
		return replyService.updateReply(params);
	}
	//댓글 완전 삭제
	@PostMapping("/deleteReplyA")
	@ResponseBody
	public int deleteReplyA(@RequestBody Map<String, Object> params) {
		return replyService.deleteReplyA(params);
	}
	//댓글 삭제 남김
	@PostMapping("/deleteReply")
	@ResponseBody
	public int deleteReply(@RequestBody Map<String, Object> params) {
		return replyService.deleteReply(params);
	}
	
	//댓글 리스트
	@GetMapping("/replyAjax/{bnum}")
	public String replyAjax(@PathVariable("bnum") String bnum, Model model, HttpSession session) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("userId", session.getAttribute("userId"));
		param.put("bnum", bnum);
		model.addAttribute("rList", replyService.selectReply(param));
		model.addAttribute("userNick", rreplyService.selectMember(param));
		model.addAttribute("rrList", rreplyService.selectRreply(param));
		return "/tiles/ajax/ajax/ajax-reply";
	}
	/////////////////////////////////////////////////////////////////////////
	//대댓글 입력
	@PostMapping("/rreplyInput")
	@ResponseBody
	public int rreplyInsert(@RequestBody Map<String, Object> params, HttpSession session) {
		params.put("mid", session.getAttribute("userId"));
		return rreplyService.insertRreply(params);
	}
	//대댓글 수정&삭제
	@PostMapping("/updateOrDeleteRR")
	@ResponseBody
	public int updateOrDeleteRR(@RequestBody Map<String, Object> params) {
		return rreplyService.updateOrDeleteRR(params);
	}
}













