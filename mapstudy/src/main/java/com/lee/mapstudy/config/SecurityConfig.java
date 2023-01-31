package com.lee.mapstudy.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.ProviderManager;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

import com.lee.mapstudy.security.CustomAuthenticationProvider;
import com.lee.mapstudy.security.LoginFailureHandler;
import com.lee.mapstudy.security.LoginSuccessHandler;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
	private final LoginSuccessHandler loginSuccessHandler;
	private final LoginFailureHandler loginFailHandler;
	
	@Bean
	public BCryptPasswordEncoder bCryptPasswordEncoder(){
		return new BCryptPasswordEncoder();
	};
	
    @Bean
    public AuthenticationManager authenticationManager() {
    	return new ProviderManager(customAuthenticationProvider());
    }
    
    @Bean
    public CustomAuthenticationProvider customAuthenticationProvider() {
    	return new CustomAuthenticationProvider(bCryptPasswordEncoder());
    }
    
	@Bean
	public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
		http.csrf().disable()
				.authorizeRequests()
				.antMatchers("/join").permitAll()
				.antMatchers("/joinMember").permitAll()
				.anyRequest()
				.authenticated()
				.and()
					.formLogin()
					.loginPage("/login")
					.loginProcessingUrl("/login_proc")
					.successHandler(loginSuccessHandler)
					.failureHandler(loginFailHandler)
					.usernameParameter("mid")
		            .passwordParameter("mpw")
				.and()
					.logout()
					.logoutRequestMatcher(new AntPathRequestMatcher("/logout"))
					.logoutSuccessUrl("/login")
					.invalidateHttpSession(true)
					.permitAll()
				.and()
					.sessionManagement()
					.maximumSessions(1)
					.maxSessionsPreventsLogin(false) //true면 중복로그인 막기, false면 로그인 세션 해제
					.expiredUrl("/login");
			return http.build();	
	}
	
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return (web) -> web.ignoring().antMatchers("/css/**", "/images/**", "/js/**", "/smarteditor/**");
    }	
}
