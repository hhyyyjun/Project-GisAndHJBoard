package com.lee.mapstudy.security;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.google.gson.JsonObject;
import com.lee.mapstudy.vo.UserVo;

import lombok.RequiredArgsConstructor;

/* 로그인 성공시 타는 handler */
@Component
@RequiredArgsConstructor
public class LoginSuccessHandler extends CoTopComponent implements AuthenticationSuccessHandler {
	
	
	@Override
	public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
			Authentication auth) throws IOException, ServletException {
		
		//default 성공
		String result = "success";
		
		HttpSession session = request.getSession();
		session.setAttribute("userId", ((UserVo) auth.getPrincipal()).getMid());
		session.setAttribute("mrole", ((UserVo) auth.getPrincipal()).getMrole());
//		session.setMaxInactiveInterval(60 * 60 * 3);
		//세션 유지시간
		session.setMaxInactiveInterval(1200);
		
	    //Response 결과 값을 넣어줌
	    JsonObject loginResult = new JsonObject();
	    loginResult.addProperty("result", result);
	  
	    //응답 전송
	    writeResponse(response, loginResult);
	}
	
}
