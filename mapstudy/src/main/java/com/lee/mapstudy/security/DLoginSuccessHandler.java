package com.lee.mapstudy.security;
//package com.lee.mapstudy.security;
//
//import java.io.IOException;
//
//import javax.servlet.ServletException;
//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpServletResponse;
//import javax.servlet.http.HttpSession;
//
//import org.springframework.security.core.Authentication;
//import org.springframework.security.web.authentication.AuthenticationSuccessHandler;
//import org.springframework.stereotype.Component;
//
//import com.lee.mapstudy.vo.UserVo;
//
//@Component
//public class LoginSuccessHandler implements AuthenticationSuccessHandler {
//
//	@Override
//    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication auth) throws IOException, ServletException {
//        HttpSession session = request.getSession();
//		//session에 넣을항목
//		session.setAttribute("userId", ((UserVo) auth.getPrincipal()).getMid());
//		session.setAttribute("mrole", ((UserVo) auth.getPrincipal()).getMrole());
//
//        response.sendRedirect("/board");
//    }
//
//}
