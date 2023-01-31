package com.lee.mapstudy.boardDao;

import java.util.Map;

import com.lee.mapstudy.vo.UserVo;


public interface MemberDao {
	//회원가입
	public int insertMember(Map<String, Object> params);
	//로그인
	public UserVo selectLoginMember(String mid);
	//아이디 중복검사
	public int checkId(String id);
	//회원정보페이지
	public Map<String, Object> userInfo(Map<String, Object> params);
	//회원정보 변경
	public int updateMemberInfo(Map<String, Object> params);
	//회원 비밀번호 변경
	public int updateMemberPwd(Map<String, Object> params);
	
}
