package com.lee.mapstudy.security;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;
import com.google.gson.JsonObject;
import lombok.extern.slf4j.Slf4j;

/* 로그인 실패시 타는 핸들러 */

@Slf4j
@Component
public class LoginFailureHandler extends CoTopComponent implements AuthenticationFailureHandler {

	@Override
	public void onAuthenticationFailure(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException exception) throws IOException, ServletException {
		writeResponse(response, parseException(request.getParameter("un"), exception));
	}
	
	private JsonObject parseException(String userName, AuthenticationException exception) {
		String errCode = "99";
		String errMsg = exception.getMessage();

		JsonObject result = new JsonObject();
		result.addProperty("result", errCode);
		result.addProperty("resultMessage", errMsg);
		return result;
	}
}