package com.lee.mapstudy.gis;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

import com.fasterxml.jackson.databind.ObjectMapper;

public class HttpConnectionExample {

	private static final String USER_AGENT = "Mozilla/5.0";

	// HTTP GET request 
	public Map<String, Object> sendGet(String targetUrl) throws Exception { 
		URL url = new URL(targetUrl); 
		HttpURLConnection con = (HttpURLConnection) url.openConnection(); 
		con.setRequestMethod("GET"); // optional default is GET 
		con.setRequestProperty("User-Agent", USER_AGENT); // add request header 
		int responseCode = con.getResponseCode(); BufferedReader in = new BufferedReader(new InputStreamReader(con.getInputStream())); 
		String inputLine; 
		StringBuffer response = new StringBuffer(); 
		
		while ((inputLine = in.readLine()) != null) { 
			response.append(inputLine); 
		} 
		
		in.close(); 
		
		// print result 
		System.out.println("HTTP 응답 코드 : " + responseCode); 
		System.out.println("HTTP body : " + response.toString()); 
		
		ObjectMapper mapper = new ObjectMapper();
		Map<String, Object> map = mapper.readValue(response.toString(), Map.class);
		return map;
	}
}
