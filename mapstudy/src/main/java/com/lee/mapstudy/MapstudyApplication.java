package com.lee.mapstudy;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

//외장톰캣 설정 시 springbootservletinitializer 상속
// gradle dependency에 추가
//providedRuntime 'org.springframework.boot:spring-boot-starter-tomcat'
// gradle plugin에 id 'war' 추가

//@SpringBootApplication
//public class MapstudyApplication extends SpringBootServletInitializer {
//
//	public static void main(String[] args) {
//		SpringApplication.run(MapstudyApplication.class, args);
//	}
//
//	//configure 오버라이딩
//	@Override
//	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
//		// TODO Auto-generated method stub
//		return builder.sources(MapstudyApplication.class);
//	}
//		
//	
//	
//}


@SpringBootApplication
@MapperScan(basePackages = "com.lee.mapstudy")
public class MapstudyApplication {
	
	public static void main(String[] args) {
		SpringApplication.run(MapstudyApplication.class, args);
	}
	
}
