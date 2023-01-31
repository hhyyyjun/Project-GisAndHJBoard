package com.lee.mapstudy.security;


import javax.annotation.Resource;

import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import lombok.NonNull;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class CustomAuthenticationProvider implements AuthenticationProvider {
	
	@Resource
	private UserDetailService userDetailService;
	
	@NonNull
	private BCryptPasswordEncoder passwordEncoder;
	
    @Override
    public Authentication authenticate(Authentication authentication) 
      throws AuthenticationException {
 
        String name = authentication.getName();
        String password = authentication.getCredentials().toString();
        
        UserDetails userInfo = userDetailService.loadUserByUsername(name);
    
        if(userInfo == null) {
        	throw new BadCredentialsException("idException");
        }else {
        	BCryptPasswordEncoder bCryptPasswordEncoder = new BCryptPasswordEncoder();
        	if(!bCryptPasswordEncoder.matches(password, userInfo.getPassword())) {
        		throw new BadCredentialsException("pwdException");
        	}
        }
        
        return new UsernamePasswordAuthenticationToken(userInfo, userInfo.getPassword(), userInfo.getAuthorities());
   
    }

    @Override
    public boolean supports(Class<?> authentication) {
        return authentication.equals(UsernamePasswordAuthenticationToken.class);
    }
}