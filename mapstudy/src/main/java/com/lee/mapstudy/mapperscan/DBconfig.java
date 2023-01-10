package com.lee.mapstudy.mapperscan;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@Configuration
@PropertySource("classpath:/application.properties")
@MapperScan(value="com.lee.mapstudy.mapperInterface")
public class DBconfig {
	
}
