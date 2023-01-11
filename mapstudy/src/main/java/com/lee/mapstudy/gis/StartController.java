package com.lee.mapstudy.gis;

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
	@GetMapping("/openDistance")
	public String openDistance() {
		System.out.println("openDistance");
		
		return "opendistance";
	}
	@GetMapping("/openfreedraw")
	public String openfreedraw() {
		System.out.println("openfreedraw");
		
		return "openfreedraw";
	}
	@GetMapping("/leafletexample")
	public String leafletexample() {
		System.out.println("leafletexample");
		
		return "leafletexample";
	}
	
	
	
}
