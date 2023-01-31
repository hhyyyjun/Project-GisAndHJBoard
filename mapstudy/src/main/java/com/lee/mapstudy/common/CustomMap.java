package com.lee.mapstudy.common;

import java.util.HashMap;

import org.springframework.jdbc.support.JdbcUtils;
//mapper resultmap 생략
//camel case 처리
@SuppressWarnings("serial")
public class CustomMap extends HashMap<String, Object> {

    @Override
    public Object put(String key, Object value) {
        return super.put(JdbcUtils.convertUnderscoreNameToPropertyName(key), value);
    }
    
}