<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
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
	height: 700px;
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


	<script>
		//var map = L.map("map").setView([37.55236577, 126.97077348], 15);
		var map = L.map("map").setView([ 37.56249213, 126.96849315 ], 15);
		L
				.tileLayer(
						'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
						{
							maxZoom : 19,
							attribution : '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
						}).addTo(map);
		console.log("초기화")

		//내 위치 찾기
		function me(){
		map.on('locationfound',
				function(e) {
					console.log(e);
					var radius = e.accuracy / 2;
					var locationMarker = L.marker(e.latlng).addTo(map)
							.bindPopup(
									'당신의 반경 ' + radius.toFixed(6)
											+ '미터 안에 계시겠군요.').openPopup();
					var locationCircle = L.circle(e.latlng, radius).addTo(map);
					console.log(radius);
				});
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
		var openmate = L.marker([ 37.56249213, 126.96849315 ]).addTo(map);
		// var marker2 = L.marker([51.494423, -0.076561]).addTo(map);

		//동그라미 도형맵 표현
		// var circle = L.circle([51.508, -0.11], {
		// color: 'red',
		// fillColor: '#f03',
		// fillOpacity: 0.5,
		// radius: 500
		// }).addTo(map);

		//폴리곤 표현
		// var polygon = L.polygon([
		// [51.509, -0.08],
		// [51.503, -0.06],
		// [51.51, -0.047]
		// ]).addTo(map);

		//팝업띄우기
		openmate.bindPopup("<b>Openmate</b>").openPopup();
		// circle.bindPopup("I am a circle.");
		// polygon.bindPopup("I am a polygon.");

		//alert 안내
		// function onMapClick(e) {
		// alert("You clicked the map at " + e.latlng);
		// }

		// map.on('click', onMapClick);

		// 맵 상 안내
		var popup = L.popup();

		function onMapClick(e) {
			popup.setLatLng(e.latlng).setContent(
					"You clicked the map at<br>" + e.latlng.toString()
							+ "<br><button>즐겨찾기</button>").openOn(map);
		}

		map.on('click', onMapClick);

		//서울역 이동
		function move() {
			map.panTo(new L.LatLng(37.55236577, 126.97077348));
		}
	</script>
</body>
</html>