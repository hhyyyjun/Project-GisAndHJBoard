<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>leaflet</title>

<link rel="stylesheet"
	href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css"
	integrity="sha256-kLaT2GOSpHechhsozzB+flnD+zUyjE2LlfWPgU04xyI="
	crossorigin="" />

<!-- Make sure you put this AFTER Leaflet's CSS -->
<script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"
	integrity="sha256-WBkoXOwTeyKclOHuWtc+i2uENFpDZ9YPdf5Hf+D7ewM="
	crossorigin=""></script>



<style>
#mapwrap {
	width: 100%;
	display: flex;
	/* justify-content: space-between; */
}

#map {
	height: 800px;
	width: 900px;
}
</style>
</head>
<body>
	<div id="mapwrap">
		<div id="map"></div>
		<div id="search">
			<div>검색하기</div>
			<div>
				<form action="search" method="get">
					주소 검색해 : <input type="text" name="query"> <input
						id="searchbtn" type="submit" value="검색">
				</form>
			</div>
		</div>
	</div>
	<button onClick="me()">내 위치 찾기</button>
	<button onclick="move()">서울역</button>

	<script src="/js/common.js"></script>

	<script>
		//var map = L.map("map").setView([ 37.497952, 127.027619 ], 15);
		var map = L.map("map",{
			//지도가 처음 출력될 때 중심 좌표
			//center : [37.497952, 127.027619],
			center : [seoulstationLat, seoulstationLng],
			
			//지도가 처음 출력될 때 줌 레벨
			zoom : 15,
			//지도 드래그 이동 가능 여부
			dragging : true,
			//마우스 휠로 줌 가능 여부
			scrollWheelZoom : true,
			touchZoom : 'center'
		});
		var tilelayer = L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png',
						{
							//투명도
							opacity : 1,
							//최대 줌 레벨
							maxZoom : 19,
							minZoom : 5,
							//우측 하단에 출력될 정보
							attribution : '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
						}).addTo(map);
		console.log("초기화")
		/*
		console.log("지도 중심 좌표 : "+map.getCenter());
		console.log("지도 현재 줌 레벨 : "+map.getZoom());
		console.log("지도의 최대 줌 설정 레벨 : "+map.getMaxZoom());
		console.log("지도의 최소 줌 설정 레벨 : "+map.getMinZoom());
		
		map.on('zoomstart', function(){
			console.log("지도의 줌이 변경되는 중");
		})
		*/
		
		//내 위치 찾기
		function me(){
		map.on('locationfound',
				function(e) {
					console.log(e);
					//반경 구하기
					var radius = e.accuracy / 2;
					//해당 위경도 위치에 마커,팝업 생성
					var locationMarker = L.marker(e.latlng).addTo(map)
							.bindPopup(
					// tofixed 소수점 처리(소수점 6번째 자리까지)
									'당신은 반경 ' + radius.toFixed(6)
											+ '미터 안에 계시겠군요.').openPopup();
					var locationCircle = L.circle(e.latlng, radius).addTo(map);
					console.log(radius.toFixed(6));
				});
		//위치 에러가 발생한 경우
		map.on('locationerror', function(e) {
			console.log(e.message)
		});
		
		map.locate({
			setView : true,
			maxZoom : 16
		});
		}
		 
	</script>


	<script>
		
// 		map.on('click', function(e){
// 			//getZoom 줌레벨 확인
// 			console.log("ZoomLevel : "+map.getZoom());
// 			//getCenter 현재 지도의 지리적 중심 위경도값
// 			console.log("CenterLatLng : "+map.getCenter());
// 			//지도의 현재 크기(css로 설정한 값)
// 			console.log("mapSize : "+map.getSize());
// 			//getPixelOrigin 픽셀좌표 반환
// 			console.log("PixelCRS : "+map.getPixelOrigin());
// 			//클릭한 위치의 위경도값
// 			console.log("LatLngVal : "+e.latlng);
// 			//좌표 사이 거리
// 			console.log("좌표사이거리 : "+map.distance(e.latlng,[openmateLat, openmateLng]));
// 		});
		
		
		//툴팁이 열릴 때 이벤트
		/*
		map.on('tooltipopen', function(){
			console.log("되니?");
		});
		*/
		
		//이미지 오버레이
		/*
		var imgurl = '/images/leaf-green.png';
		var imageBounds = [[37.500738, 127.024999], [37.49386, 127.029676]];
		var imgoverlay = L.imageOverlay(imgurl, imageBounds,{
			opacity : 0.5,
			attribution : "openmate"
		}).addTo(map);
		
		imgoverlay.on('load', function(){
			console.log("이미지 생성");
		})
		*/
		/*
		var poly = [
			[openmateLat, openmateLng], 
			[seoulstationLat, seoulstationLng], 
			[cityhallLat, cityhallLng]
			];
		L.polyline(poly, {
			color : 'red'
		}).addTo(map);
		*/
		
		/*
		var seoulPoint = L.marker([37.55236577, 126.97077348],{
			//투명도
			opacity : 1,
			//마우스 드래그로 마커 이동하기
			draggable : true
		}).addTo(map);
		*/
		
		//마커 찍기
		//마커들의 정보를 담을 배열
		var markers = [];
		//생성할 마커
		var marker;
		map.on('click', function(e){
			//마커가 존재하고, 5개 이상 찍혀있을 시 찍혀있던 마커 삭제 후 재 생성
			if(markers.length >= 5){
				for(var i = 0; i<markers.length;i++){
					markers[i].remove();
				}
				markers = [];
			}
			
				marker = L.marker(e.latlng, {
				//마커들이 충접되어 있을 때 마우스 호버 시 해당 마커가 위로 올라오며 표시됨
				riseOnHover : true,
				opacity : 1,
				//드래그 가능 여부
				draggable : true,
				//마커 가장자리 이동시 지도 패닝(지도 이동)할지 여부
				autoPan : true,
				//지도 패닝(지도이동)속도
				autoPanSpeed : 8
			}).addTo(map);
			markers.push(marker);
			
			console.log("마커 갯수 : " + markers.length);
				
			//dragstart, movestart, dragend, moveend
			marker.on('drag', function(){
				console.log("움직이는중");
				console.log("현재 마커의 위치 : "+marker.getLatLng());
			})
			
			//마우스 클릭 시
			marker.on('click', function(e){
				marker.bindPopup(('<div>안녕!</div>'),{
					//팝업창 닫기 존재 여부
					//closeButton : false
					//팝업창이 열려있는 상태에서 지도 클릭 시 팝업창 안닫힘
					closeOnClick : true
				}).openPopup;
				console.log("나옴?");
			})
			
			//툴팁 이벤트
			/*
			marker.bindTooltip(("하이"),{
				opacity : 1,
				//팝업창이 해당 기능 중심에 고정되어있지 않고 마우스를 따라다님
				sticky : true,
				//팝업창이 열리는 방향, 기본은 auto
				direction : 'right',
				//팝업창을 영구적으로 열어놓을지 여부
				permanent : false
			}).openTooltip();
			*/
		})
		
	</script>


	<script>
	/*
	//WMS(Web Map Service)
	var gangnamStation = [37.497929, 127.027669];
	var map = L.map('map', {
	        "center": gangnamStation,
	        "zoom": 18,
	        "zoomControl": true,
	        "minZoom": 6,
	        "maxZoom": 22
	    });
	var osmLayer = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
	attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
	});
	var vworldLayer = L.tileLayer('https://xdworld.vworld.kr/2d/Base/service/{z}/{x}/{y}.png', {
	        "minZoom": 6,
	        "maxZoom": 22,
	        "maxNativeZoom": 19,
	        "attribution": '&copy; <a href="http://www.vworld.kr/">vworld</a> contributors'
	});
	//wms 레이어 추가
	var cadastral = L.tileLayer.wms("http://api.vworld.kr/req/wms", {
	        "version": "1.3.0",
	        //브이월드에서 제공하는 레이어 목록을 콤마로 연결
	        "layers": "lp_pa_cbnd_bonbun,lp_pa_cbnd_bubun",
	        //브이월드에서 제공하는 스타일 목록을 콤마로 연결
	        "styles": "lp_pa_cbnd_bonbun,lp_pa_cbnd_bubun,lp_pa_cbnd_bonbun_line,lp_pa_cbnd_bubun_line",
	        "format": "image/png",
	        "transparent": true,
	        "opacity": 1.0,
	        "maxZoom": 22,
	        "maxNativeZoom": 19,
	        //브이월드 인증키
	        "key": "E375A39D-7B0F-39D2-ADDD-97066A55263A",
	        //브이월드 인증키 발급 시 작성한 도메인 주소
	        "domain": "localhost:8080"
	    }).addTo(map);
	 
	var baseMaps = {
	"OSM" : osmLayer,
	"브이월드": vworldLayer
	};
	var overlayMaps = {
	"지적도": cadastral
	};
	vworldLayer.addTo(map);
	L.control.layers(baseMaps, overlayMaps).addTo(map);
	*/
	</script>

	<script>
	/*
	//레이어 컨트롤 추가
	//서울역 위치
	var seoulstation = [seoulstationLat, seoulstationLng];
	//맵 출력 시 시작할 좌표와 줌 레벨
	var map = L.map('map').setView(seoulstation, 12);
	 
	//오픈 스트리트 맵 바탕 지도
	var osmLayer = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
	    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
	});
	//vworld 맵 바탕 지도
	var vworldLayer =  L.tileLayer('https://xdworld.vworld.kr/2d/Base/service/{z}/{x}/{y}.png', {
	    attribution: '&copy; <a href="http://www.vworld.kr/">vworld</a>  contributors'
	});
	// 한강 좌표 팝업
	var markerLayer = L.marker(seoulstation).addTo(map)
	    .bindPopup('서울역');
	// 레이어 컨트롤에 바탕지도로 지정할 2개 레이어 정의
	var baseMaps = {
	  "OSM" : osmLayer,
	  "브이월드": vworldLayer
	};
	// 레이어 컨트롤에 중첩지도로 지정할 1개 레이어 정의
	var overlayMaps = {
	    "마커": markerLayer
	};
	//웹이 시작할 때 처음으로 출력될 지도 설정
	vworldLayer.addTo(map);
	//레이어 컨트롤 지도에 출력
	L.control.layers(baseMaps, overlayMaps,{
		//위치 설정
		position : 'bottomright'
	}).addTo(map);
	*/
	</script>

	<script>
	//이미지 아이콘 마커 생성하기
	/*
	var greenIcon = L.icon({
	    iconUrl: '/images/leaf-green.png',
	    shadowUrl: '/images/leaf-shadow.png',

	    iconSize:     [38, 95], // size of the icon
	    shadowSize:   [50, 64], // size of the shadow
	    iconAnchor:   [22, 94], // point of the icon which will correspond to marker's location
	    shadowAnchor: [4, 62],  // the same for the shadow
	    popupAnchor:  [-3, -76] // point from which the popup should open relative to the iconAnchor
	});
	L.marker([37.497952, 127.027619], {icon: greenIcon}).addTo(map);
	*/
	
	
	/*
	var LeafIcon = L.Icon.extend({
	    options: {
	        shadowUrl: '/images/leaf-shadow.png',
	        iconSize:     [38, 95],
	        shadowSize:   [50, 64],
	        iconAnchor:   [22, 94],
	        shadowAnchor: [4, 62],
	        popupAnchor:  [-3, -76]
	    }
	});
	var greenIcon = new LeafIcon({iconUrl: '/images/leaf-green.png'}),
    redIcon = new LeafIcon({iconUrl: '/images/leaf-red.png'}),
    orangeIcon = new LeafIcon({iconUrl: '/images/leaf-orange.png'});
	
	
	L.icon = function (options) {
	    return new L.Icon(options);
	};
	L.marker([37.4937713, 127.02506232], {icon: greenIcon}).addTo(map).bindPopup("I am a green leaf.");
	L.marker([37.4910701, 127.02644047], {icon: redIcon}).addTo(map).bindPopup("I am a red leaf.");
	L.marker([37.49284381, 127.02906758], {icon: orangeIcon}).addTo(map).bindPopup("I am an orange leaf.");
	*/
	</script>

	<script>
	/*
		//강남역
		var gangnam = L.marker([ 37.497952, 127.027619 ]).addTo(map);

		//동그라미 도형맵 표현
		var circle = L.circle([37.5025459, 127.0296267], {
		 color: 'red',
		 fillColor: '#f03',
		 fillOpacity: 0.5,
		 radius: 200
		 }).addTo(map);

		//폴리곤 표현
		 var polygon = L.polygon([
		 [37.4937713, 127.02506232],
		 [37.4910701, 127.02644047],
		 [37.49284381, 127.02906758]
		 ]).addTo(map);

		//팝업띄우기
		gangnam.bindPopup("<b>강남역</b>").openPopup();
		circle.bindPopup("역삼공원");
		polygon.bindPopup("Polygon");
		
		//레이어 팝업
		var popup = L.popup()
	    .setLatLng([37.497952, 127.027619])
	    .setContent("I am a standalone popup.")
	    //.openOn(map);
	    .addTo(map);

		//alert 안내
		function onMapClick(e) {
		alert("You clicked the map at " + e.latlng);
		}

		// map.on('click', onMapClick);

		// 맵 상 안내
		var popup = L.popup();

		function onMapClick(e) {
			popup.setLatLng(e.latlng).setContent(
					"You clicked the map at<br>" + e.latlng.toString()).openOn(map);
		}

		map.on('click', onMapClick);

		
		//서울역 이동
		function move() {
			map.panTo(new L.LatLng(37.55236577, 126.97077348));
		}
		*/
	</script>
</body>
</html>