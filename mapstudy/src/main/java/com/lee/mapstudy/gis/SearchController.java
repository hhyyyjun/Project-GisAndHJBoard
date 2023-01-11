package com.lee.mapstudy.gis;

import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;

@RestController
public class SearchController {

	@Value("${vworld.apiKey}")
	private String apiKey;	

	//	@GetMapping("/search")
	//@ResponseBody
	@PostMapping("/search")
	public Map<String, Object> search(HttpServletResponse response, @RequestBody Map<String,Object> paramss) throws Exception {

		String url = makeSearchUrl("http://api.vworld.kr/req/search", paramss);
		System.out.println("url : " + url);
		
		response.setHeader("Access-Control-Allow-Origin", "*");
		response.setHeader("Access-Control-Allow-Methods", "POST, GET");
		response.setHeader("Access-Control-Max-Age", "3600");
		response.setHeader("Access-Control-Allow-Headers", "x-requested-with, origin, content-type, accept");
		
		HttpConnectionExample httpConnectionExample = new HttpConnectionExample();
		return httpConnectionExample.sendGet(url);
		
		
		
		
//		Map<String, Object> result = new HashMap<String, Object>();

		//파라미터 받기
//		String query = (String)paramss.get("query");
//		System.out.println(query);

		//url 메소드 파라미터 셋팅
		//		Map<String, Object> params = new HashMap<String, Object>();
		//		params.put("service", "search");
		//		params.put("request", "search");
		//		params.put("version", "2.0");
		//		params.put("crs", "EPSG:900913");
		//		params.put("bbox", "14140071.146077,4494339.6527027,14160071.146077,4496339.6527027");
		//		params.put("size", "10");
		//		params.put("page", "1");
		//		params.put("type", "address");
		//		params.put("category", "road");
		//		params.put("format", "json");
		//		params.put("errorformat", "json");
		//		//들어갈 값
		//		params.put("key", apiKey);
		//		params.put("query", query);

		//RestTemplate 객체 생성
//		RestTemplate template = new RestTemplate();
//		String response = "";
//
//		try {
//			//http://api.vworld.kr/req/search?service=search&request=search&version=2.0&crs=EPSG:900913&bbox=14140071.146077,4494339.6527027,14160071.146077,4496339.6527027&size=10&page=1&query=성남시 분당구 판교로 242&type=address&category=road&format=json&errorformat=json&key=[KEY]
//			response = 
//					template.getForObject("http://api.vworld.kr/req/search",String.class, params);
//			//todo
//			//json String convert to map
//
//		} catch (HttpStatusCodeException e) {
//			if (e.getStatusCode() == HttpStatus.NOT_FOUND) {
//
//				//						HttpStatusCodeException 
//				//						HttpClientErrorException 
//				//						HttpServerErrorException
//
//			}
//
//		}
//		return result;
	}


	private String makeSearchUrl(String url, Map<String, Object> params) throws Exception {

		String service = (String) params.get("service");
		String request = (String) params.get("request");
		String version = (String) params.get("version");
		String crs = (String) params.get("crs");
		int size = (int) params.get("size");
		int page = (int) params.get("page");
		String query = URLEncoder.encode((String) params.get("query"), "UTF-8");
		String type = (String) params.get("type");
		String category = (String) params.get("category");
		String format = (String) params.get("format");
		String errorformat = (String) params.get("errorformat");
		String key = (String) params.get("key");

		url = url+"?key="+key+"&service="+service+"&request="+request+"&version="+version
				+"&crs="+crs+"&size="+size+"&page="+page+"&query="+query
				+"&type="+type+"&category="+category+"&format="+format+"&errorformat="+errorformat;
		System.out.println(url);
		return url;
	}

}
