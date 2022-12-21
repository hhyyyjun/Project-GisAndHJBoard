package com.lee.mapstudy.go;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class StartController {
	
	@GetMapping("/leaflet")
	public String goleaflet() {
		System.out.println("leaflet");
		
		return "leaflet";
	}
	@GetMapping("/leaflet2")
	public String goleaflet2() {
		System.out.println("leaflet2");
		
		return "leaflet2";
	}
	
	@GetMapping("/openlayers")
	public String goopen() {
		System.out.println("openlayers");
		
		return "openlayers";
	}
	
	@GetMapping("/kakao")
	public String kakao() {
		System.out.println("kakao");
		
		return "kakaomap";
	}
	
	
	
}
