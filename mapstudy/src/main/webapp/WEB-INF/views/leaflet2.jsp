<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>leaflet</title>

<link rel="stylesheet"
	href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css"
	integrity="sha256-kLaT2GOSpHechhsozzB+flnD+zUyjE2LlfWPgU04xyI="
	crossorigin="" />

<link rel="stylesheet" href="css/style.css">
<!-- Make sure you put this AFTER Leaflet's CSS -->
<script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"
	integrity="sha256-WBkoXOwTeyKclOHuWtc+i2uENFpDZ9YPdf5Hf+D7ewM="
	crossorigin=""></script>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.12.4.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

	<script src="https://leaflet.github.io/Leaflet.draw/libs/leaflet-src.js"></script>
    <link rel="stylesheet" href="https://leaflet.github.io/Leaflet.draw/libs/leaflet.css"/>

    <script src="https://leaflet.github.io/Leaflet.draw/src/Leaflet.draw.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/Leaflet.Draw.Event.js"></script>
    <link rel="stylesheet" href="https://leaflet.github.io/Leaflet.draw/src/leaflet.draw.css"/>

    <script src="https://leaflet.github.io/Leaflet.draw/src/Toolbar.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/Tooltip.js"></script>

    <script src="https://leaflet.github.io/Leaflet.draw/src/ext/GeometryUtil.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/ext/LatLngUtil.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/ext/LineUtil.Intersect.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/ext/Polygon.Intersect.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/ext/Polyline.Intersect.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/ext/TouchEvents.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/draw/DrawToolbar.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/draw/handler/Draw.Feature.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/draw/handler/Draw.SimpleShape.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/draw/handler/Draw.Polyline.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/draw/handler/Draw.Marker.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/draw/handler/Draw.Circle.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/draw/handler/Draw.CircleMarker.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/draw/handler/Draw.Polygon.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/draw/handler/Draw.Rectangle.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/edit/EditToolbar.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/edit/handler/EditToolbar.Edit.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/edit/handler/EditToolbar.Delete.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/Control.Draw.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/edit/handler/Edit.Poly.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/edit/handler/Edit.SimpleShape.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/edit/handler/Edit.Rectangle.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/edit/handler/Edit.Marker.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/edit/handler/Edit.CircleMarker.js"></script>
    <script src="https://leaflet.github.io/Leaflet.draw/src/edit/handler/Edit.Circle.js"></script>

<style>
#btn{
	width : 120px;
	height : 100px;
	display : flex;
	justify-content: space-between;
}
#start{
	background-color : green;
}
#stop{
	background-color : red;
}
.rightBtn{
	width : 50px;
	height : 30px;
	color : #fff;
	border : 1px solid #fff;
	border-radius: 10%;
	font-weight : 800;
	font-size : 12px;
	cursor : pointer;
}
.rightBtn:hover{
	opacity : 0.7;
}
.rightMenu{
}
.info{
	width : 50px;
	background-color : black;
	color : #fff;
	border : 1px solid black;
	border-radius: 10%;
	display : none;
}
#lastDistanceBtn{
	border: 1px solid green; 
	color: green;
	border-radius: 10px;
	width: 130px;
	height: 30px;
	display: block;
	margin: 5px auto;
	cursor: pointer;
	background-color: #fff;
}
#lastDistanceInfo{
	font-weight: bold;
    color: green;
    display: block;
    margin : 0 auto;
}
</style>

</head>
<body>
	<div>
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
	</div>

	<div id="map"></div>
	<div id="apps">
		<div>
			<div id="search">
				<div id="searchmap">
					주소 검색 : <input type="text" name="query" id="searchadd"> <input
						id="searchBtn" type="button" value="검색">
				</div>
			</div>
			<div>
				<button onclick="addPin()">핀 추가하기</button>
			</div>
			<div>
				<button onclick="addpolygon()">추가한 마커 폴리곤 생성하기</button>
				<select id="colorsel">
					<option>red</option>
					<option>blue</option>
					<option>orange</option>
					<option>green</option>
					<option>pink</option>
					<option>yellow</option>
					<option>purple</option>
				</select> <select id="polygonW">
					<option>3</option>
					<option>4</option>
					<option>5</option>
					<option>6</option>
					<option>7</option>
					<option>8</option>
					<option>9</option>
				</select>
			</div>
		</div>
		<div id="buttons">
			<button onClick="me()">내 위치 찾기</button>
			<button onclick="move()">서울역</button>
			<button onclick="pinchk()" id="pinchk">핀 확인</button>
			<button onclick='pindel()' id="pindel" disabled>핀 삭제</button>
			<button onclick="polygon()" id="polygon" disabled>폴리곤 연결</button>
			<button onclick="circle()" id="circle" disabled>nh 주변 확인</button>
		</div>
		<div>
			<button onclick="delLayer()">레이어 전부 지우기</button>
		</div>
		<div>
			<button onclick="lineDraw()">선그리기</button>
		</div>
	</div>
	<div class="info">안녕하세요</div>

	<script src="js/common.js"></script>

	<script>
		var map = L.map("map",{
			center : [NHLat, NHLng],
			zoom : 18,
			//더블 클릭을 통한 줌 기능 해제
			doubleClickZoom : false
		});
		L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png',{
							maxZoom : 19,
							attribution : '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
						}).addTo(map);
		console.log("지도 초기화");
	</script>
		
	<script>
		// 그리기 도구 추가
		//생성된 레이어들을 저장할 곳
		var drawnItems = new L.FeatureGroup();
		map.addLayer(drawnItems);
		//그리기 컨트롤러 초기화 및 추가
		var drawControl = new L.Control.Draw({
			//컨트롤러 위치
			position : 'topright',
			//그리기 옵션
			draw : {
				//폴리라인 옵션
				polyline : {
					shapeOptions: {
						stroke: true,
						color: '#6799FF',
						weight: 7,
						opacity: 0.5,
						fill: false,
						clickable: true
					},
					showLength : true,
					metric : true
				},
				//원 옵션
				circle : {
					shapeOptions : {
						color : '#FFE400',
						fillColor : '#8041D9'
					}
				},
				//사각형 옵션
				rectangle : {
					shapeOptions : {
						color : '#2F9D27',
						fillColor : '#86E57F'
					}
				},
				//폴리곤 옵션
				polygon : {
					showArea : true
				}
			},
			//편집 옵션
			edit : {
				featureGroup : drawnItems
				//편집 도구 비활성화
				//edit : false
			}
		});
		console.log(drawControl);
		map.addControl(drawControl);
		
		//레이어의 타입 초기화
		var type = "";
		//레이어 정보
		var layer = "";
		//단위변환하여 출력할 값
		var output;
		var Totaloutput;
		//원의 중심 좌표
		var circleLatlng
		//원의 중심 좌표에 생성될 마커
		var circleMarker
		
		//그리기 시작 시
		map.on('draw:drawstart',function(e){
// 			alert(e.layerType);
			type = e.layerType;
			layer = e.layer;
			console.log("선택한 도구 : "+type);
			
			//그리기 도구가 폴리라인 이라면
			if(type === 'polyline'){
				//클릭한 곳의 좌표값들이 들어갈 배열
				var linePoint = [];
				//총 거리
				var totalDistance = 0;
				//마커
				var polylineMarker;
				//마커들
				var polylineMarkers = [];
				//지도 클릭하면 포인트 사이의 거리를 바인드 팝업으로 생성
				map.on('click', function(e){
					//클릭한 곳의 좌표값을 배열에 저장
					linePoint.push(e.latlng);
					console.log("마커의 좌표 값 : "+linePoint);
					//지도에 마커 추가
					polylineMarker = L.marker(e.latlng).addTo(map);
					//마커정보를 배열에 추가
					polylineMarkers.push(polylineMarker);
					console.log(polylineMarkers);
					//만약 clicks의 길이가 2이상이면
					if(linePoint.length >= 2){
						//배열의 길이
						var i = linePoint.length;
						//이전 마커의 좌표
						var distance1 = linePoint[i-2];
						//이후 마커의 좌표
						var distance2 = linePoint[i-1];
						//거리 계산
						var measure = map.distance(distance1, distance2);
						if(measure > 1000){
							output = (Math.round(measure / 1000 * 100) / 100) + ' km';
						} else{
							output = (Math.round(measure * 100) / 100) + ' m'
						}
						//거리 값
						console.log("마커 사이 거리 : "+output);
						//마커 사이의 거리를 툴팁으로 출력
						polylineMarker.bindTooltip(("거리 : "+output),{
							permanent : true //지도에 영구적으로 띄워놓을건지?
						}).addTo(map).openTooltip();
						//총 거리 계산
						totalDistance += measure;
						if(totalDistance > 1000){
							Totaloutput = (Math.round(totalDistance / 1000 * 100) / 100) + ' km';
						} else{
							Totaloutput = (Math.round(totalDistance * 100) / 100) + ' m'
						}
						//마커 배열의 마지막 인덱스의 마커 정보를 가져와
						var lastMarker = polylineMarkers[polylineMarkers.length-1];
						//마지막 마커에 총 거리 출력
						lastMarker.bindPopup("<div id='lastDistanceInfo'>총 거리 : "+Totaloutput+"</div>"
											 +"<button id='lastDistanceBtn'>지우기</button>");
						console.log("총 거리 : "+Totaloutput);
					}
				});
			}
			//그리기 도구가 폴리곤이라면
			if(type === 'polygon'){
				//폴리곤 꼭지점들의 좌표를 저장할 배열
				var polygonPoint = [];				
				map.on('click', function(e){
					polygonPoint.push(e.latlng);
					console.log("폴리곤 꼭지점 좌표 값 : "+polygonPoint);
				});
			}
		})
		
		
		//그리기 종료 시(종료 시점이 도형 생성 시점보다 나중임)
		map.on('draw:drawstop',function(e){
			
			//클릭 이벤트 해제
			map.off('click');
			map.off('mousedown');
		});
		
		
		//도형이 생성되었을 때
		//map.on(L.Draw.Event.CREATED, function (e) {
		map.on('draw:created', function (e) {
			   layer = e.layer;
			   drawnItems.addLayer(layer);
			   //타입이 원인 경우
			   if(type === 'circle'){
				   console.log("생성완료 : "+type);	
				   //원의 중심 좌표
				   circleLatlng = layer.getLatLng();
			       console.log("중심 좌표 : "+circleLatlng);
			       //원의 중심에 마커 생성
			       circleMarker = L.marker(circleLatlng).addTo(map);
			       //마커 클릭 시 해당 좌표 출력
			       circleMarker.bindPopup("중심좌표는 "+circleLatlng+" 입니다.").addTo(map);
			       console.log("중심 좌표의 마커 정보 : "+circleLatlng);
			       //원의 반지름
			       var theRadius = layer.getRadius();
			       //원 내부 클릭 시 반지름 안내
			       layer.bindPopup("반경은 "+theRadius.toFixed(3)+"m 입니다.").addTo(map);
			    }
			   
				//그리기 도구가 사각형이라면
				if(type === 'rectangle'){
					console.log("생성완료 : "+type);	
					//사각형 경로의 점을 배열로 저장(2차 배열로 저장된다.)
					var rect = layer.getLatLngs();
					console.log("좌표값 : "+rect);
					//가로 길이 계산
					var width = map.distance(rect[0][1], rect[0][2]);
					//세로 길이 계산
					var height = map.distance(rect[0][2], rect[0][3]);
					console.log("가로 : "+width+", 세로 : "+height);
					//넓이 계산
					var area = width * height;
					console.log("넓이 : "+area);
					//사각형 내부 클릭 시 넓이를 팝업으로 출력
					layer.bindPopup("사각형의 넓이는 <br>"+area.toFixed(2)+"m<sup>2</sup> 입니다.").addTo(map); 
				}
				//그리기 도구가 폴리곤이라면
				if(type === 'polygon'){
					console.log("created 이후 폴리곤");
					var area = L.GeometryUtil.geodesicArea(layer.getLatLngs()[0]);
					var readableArea = L.GeometryUtil.readableArea(area, true);

					layer.bindTooltip(readableArea, {permanent: true, direction: 'center'}).openTooltip();
// 					createAreaTooltip(layer);
				}
			});
		
		
		//편집도구 사용하고 저장 시
		map.on('draw:edited', function(e){
			console.log(type);
			if(type === 'circle'){
				if(circleMarker){
					circleMarker.remove();
				}
				//이전에 찍었던 마커 삭제해야 함 >> 전역으로 빼놓기
				console.log("편집 완료 : "+type);		
				//원의 중심 좌표
				circleLatlng = layer.getLatLng();
			    console.log("중심 좌표 : "+circleLatlng);
			    //원의 중심에 마커 생성
			    circleMarker = L.marker(circleLatlng).addTo(map);
			    //마커 클릭 시 해당 좌표 출력
			    circleMarker.bindPopup("중심좌표는 "+circleLatlng+" 입니다.").addTo(map);
			    console.log("중심 좌표의 마커 정보 : "+circleLatlng);
			    //원의 반지름
			    var theRadius = layer.getRadius();
			    //원 내부 클릭 시 반지름 안내
			    layer.bindPopup("반경은 "+theRadius.toFixed(3)+"m 입니다.").addTo(map);
			}
			if(type === 'rectangle'){
				console.log("편집 완료 : "+type);				
				//사각형 경로의 점을 배열로 저장(2차 배열로 저장된다.)
				var rect = layer.getLatLngs();
				console.log("좌표값 : "+rect);
				//가로 길이 계산
				var width = map.distance(rect[0][1], rect[0][2]);
				//세로 길이 계산
				var height = map.distance(rect[0][2], rect[0][3]);
				console.log("가로 : "+width+", 세로 : "+height);
				//넓이 계산
				var area = width * height;
				console.log("넓이 : "+area);
				//사각형 내부 클릭 시 넓이를 팝업으로 출력
				layer.bindPopup("사각형의 넓이는 <br>"+area.toFixed(2)+"m<sup>2</sup> 입니다.").addTo(map); 
			}
		})
	
		//레이어가 삭제된 경우
// 		map.on('draw:deleted', function(e){
// 			if(type === 'polyline'){
// 				for(var i=0; i<polylineMarkers.length;i++){
// 					polylineMarkers[i].remove();
// 				}
// 				polylineMarkers = [];
// 			}
// 			if(type === 'rectangle'){
// 			}
// 			if(type === 'circle'){
// 			}
// 			if(type === 'polygon'){
// 			}
// 		})
		
		
		map.on('click', function(e){
			console.log(e.latlng);
		})
		
		
		function createAreaTooltip(layer) {
            if(layer.areaTooltip) {
                return;
            }

            layer.areaTooltip = L.tooltip({
                permanent: true,
                direction: 'center',
                className: 'area-tooltip'
            });

            layer.on('remove', function(event) {
                layer.areaTooltip.remove();
            });

            layer.on('add', function(event) {
                updateAreaTooltip(layer);
                layer.areaTooltip.addTo(map);
            });

            if(map.hasLayer(layer)) {
                updateAreaTooltip(layer);
                layer.areaTooltip.addTo(map);
            }
        }

        function updateAreaTooltip(layer) {
            var area = L.GeometryUtil.geodesicArea(layer.getLatLngs()[0]);
            var readableArea = L.GeometryUtil.readableArea(area, true);
//             readableArea = readableArea.split(" ")[0]+"㎡";
            var latlng = layer.getCenter();

            layer.areaTooltip
                .setContent(readableArea)
                .setLatLng(latlng);
        }
		
		
		
		
		
		
		
		
		
		
		<!--
		//선 그리며 거리재기(그리기 도구 사용 x)
		function lineDraw(){
			//클릭한 곳의 좌표값들이 들어갈 배열
			var clicks = [];
			//총 거리
			var totalDistance = 0;
			//마커
			var distanceMarker;
			//마커들
			var distanceMarkers = [];
			//지도 클릭하면 포인트 사이의 거리를 바인드 팝업으로 생성
			map.on('click', function(e){
				clicks.push(e.latlng);
				console.log("마커의 좌표 값 : "+clicks);
				//지도에 마커 추가
				distanceMarker = L.marker(e.latlng).addTo(map);
				//마커정보를 배열에 추가
				distanceMarkers.push(distanceMarker);
				console.log(distanceMarkers);
				//만약 clicks의 길이가 2이상이면
				if(clicks.length >= 2){
					var i = clicks.length;
					//이전 마커의 좌표
					var distance1 = clicks[i-2];
					//이후 마커의 좌표
					var distance2 = clicks[i-1];
					//거리 계산
					var measure = map.distance(distance1, distance2);
					//선 그리기
					var polyline = L.polyline([distance1, distance2], {
						color: 'red'
					}).addTo(map);
					//거리 값
					console.log("마커 사이 거리 : "+measure.toFixed(3));
					//마커 사이의 거리를 툴팁으로 출력
					distanceMarker.bindTooltip(("거리 : "+measure.toFixed(3)+"m"),{
						permanent : true
					}).addTo(map).openTooltip();
					//총 거리 계산
					totalDistance += measure;
					console.log("현재까지 총 거리 : "+totalDistance.toFixed(3));
				}
			});
			//선 그리기 도중 더블 클릭 시
			map.on('dblclick', function(){
				//클릭 이벤트 해제
				map.off('click');
				map.off('dblclick');
				//마커 배열의 마지막 인덱스의 마커 정보를 가져와
				var lastMarker = distanceMarkers[distanceMarkers.length-1];
				//마지막 인덱스 값의 마커 정보 삭제
				lastMarker.remove();
				//마지막 인덱스 값 제거
				distanceMarkers.pop();
				//마지막 마커에 총 거리 출력(위에 줄에서 삭제한 마지막 마커와 다른 마커임 => 마지막 지운 후의 마지막 마커)
				distanceMarkers[distanceMarkers.length-1].bindPopup("총 거리 : "+totalDistance.toFixed(3)+"m").openPopup();
				console.log("총 거리 : "+totalDistance.toFixed(3));
			});
		};
		 -->
	</script>
	
	
	
	<script>
	//지도에 우클릭 시 팝업
	var startMarker = "";
	var stopMarker = "";
	var rightClick = "";
	map.on('contextmenu', function(e){
		var mouseLat = e.latlng.lat;	
		var mouseLng = e.latlng.lng;
		
		var latlng = e.latlng;
		rightClick = L.popup(e.latlng,{
// 			content : "<div id='btn'><button class='rightBtn' id='start' onclick='startBtn("+mouseLat+", "+mouseLng+")'>출발</button><button class='rightBtn' id='stop' onclick='stopBtn("+mouseLat+", "+mouseLng+")'>도착</button></div>",
			content : "<div id='btn'><button class='rightBtn' id='start' onclick='startBtn(this)' data-lat="+mouseLat+" data-lng="+mouseLng+">출발</button><button class='rightBtn' id='stop' onclick='stopBtn(this)' data-lat="+mouseLat+" data-lng="+mouseLng+">도착</button></div>",
			className : 'rightMenu'
		}).openOn(map);
		
	})
	
// 		function startBtn(lat, lng){
// 			alert(lat, lng);			
// 			var startMarker = L.marker([lat, lng]).addTo(map);
// 		}
	
		function startBtn(target){
			if(startMarker){
				startMarker.remove();
			}
			var lat = $(target).attr("data-lat");
			var lng = $(target).attr("data-lng");
			
			var startIcon = L.icon({
			    iconUrl: '/images/start.png',
			    iconSize:     [45, 35], // size of the icon
			    iconAnchor:   [22, 35], // point of the icon which will correspond to marker's location
			    popupAnchor:  [-3, -76] // point from which the popup should open relative to the iconAnchor
			});
			
			startMarker = L.marker([lat, lng], {
				icon: startIcon,
				draggable : true,
				autoPan : true
			}).addTo(map);
			map.closePopup();
			
			startMarker.bindTooltip("끌어서 이동", {
				direction : 'top',
				offset : [0,-30]
			}).openTooptip();
		}
	
		function stopBtn(target){
			if(stopMarker){
				stopMarker.remove();
			}
			var lat = $(target).attr("data-lat");
			var lng = $(target).attr("data-lng");
			
			var stopIcon = L.icon({
			    iconUrl: '/images/stop.png',
			    iconSize:     [45, 35], // size of the icon
			    iconAnchor:   [22, 35], // point of the icon which will correspond to marker's location
			    popupAnchor:  [-3, -76] // point from which the popup should open relative to the iconAnchor
			});
			stopMarker = L.marker([lat, lng], {
				icon: stopIcon,
				draggable : true,
				autoPan : true
			}).addTo(map);
			map.closePopup();
		}
	
	</script>

	<!-- 
	<script>
		//내 위치 찾기
		function me() {
			map.on('locationfound', function(e) {
				console.log(e);
				var radius = e.accuracy / 2;
				var locationMarker = L.marker(e.latlng).addTo(map).bindPopup(
						'당신의 반경 ' + radius.toFixed(6) * 50 + '미터 안에 계시겠군요.')
						.openPopup();
				var locationCircle = L.circle(e.latlng, radius * 50).addTo(map);
				console.log(radius.toFixed(6));
			});
			map.on('locationerror', function(e) {
				console.log(e.message)
			});

			map.locate({
				setView : true,
				maxZoom : 16
			});
		}

		//서울역 이동
		function move() {
			map.panTo(new L.LatLng(seoulstationLat, seoulstationLng));
		}
	</script>


	<script>
		//시청역, 서울역, 오픈메이트 핀 표현
		function pinchk() {
			console.log("핀 생성");
			//핀 클릭 시 해당 좌표로 이동 및 줌레벨 15
			map.panTo(new L.LatLng(moveToPinCenterLat, moveToPinCenterLng))
					.locate({
						setView : true,
						maxZoom : 15
					});

			cityhall = L.marker([ cityhallLat, cityhallLng ], {
				//핀 드래그 사용 가능 여부
				draggable : true
			}).addTo(map);
			NH = L.marker([ NHLat, NHLng ]).addTo(map);
			seoulstation = L.marker([ seoulstationLat, seoulstationLng ])
					.addTo(map);

			cityhall.bindPopup("<b>시시청청역역</b>");
			NH.bindPopup("<b>농협생명</b>");
			seoulstation.bindPopup("<b>서서울울역역</b>");

			//삭제버튼 show
			$("#pindel").removeAttr("disabled");
			//폴리곤 버튼 show 
			$("#polygon").removeAttr("disabled");
			//서클 버튼 show
			$("#circle").removeAttr("disabled");
			//픽 확인 버튼 none
			$("#pinchk").attr("disabled", "disabled");
		}

		//핀삭제
		function pindel() {
			console.log("판 삭제");
			map.removeLayer(cityhall);
			map.removeLayer(NH);
			map.removeLayer(seoulstation);
			$("#pindel").attr("disabled", "disabled")
			$("#polygon").attr("disabled", "disabled")
			$("#circle").attr("disabled", "disabled")
			$("#pinchk").removeAttr("disabled");
		}

		//폴리곤 연결
		function polygon() {
			console.log("폴리곤 생성");
			var latlngs = [ [ cityhallLat, cityhallLng ],
					[ NHLat, NHLng ],
					[ seoulstationLat, seoulstationLng ] ];
			var polygon = L.polygon(latlngs, {
				color : 'yellow'
			}).addTo(map);
			//폴리곤 중심
			map.fitBounds(polygon.getBounds());

			polygon.bindPopup("폴리곤");
			$("#polygon").attr("disabled", "disabled")
		}

		//동그라미 도형맵 표현
		function circle() {
			console.log("원 생성");
			var circle = L.circle([ NHLat, NHLng ], {
				//선
				color : 'red',
				//채우기
				fillColor : 'blue',
				fillOpacity : 0.5,
				radius : 500
			}).addTo(map);

			circle.bindPopup("농협생명 반경 500m");
			$("#circle").attr("disabled", "disabled")
		}

		// 맵 상 안내 & 마커 추가
		//팝업 추가
		var popup = L.popup();
		//좌표값들 저장할 배열
		var polyLatlng = [];

		function addPin() {
			//맵 클릭 시 해당 위도경도 값 출력
			map.on('click', onMapClick);
			function onMapClick(e) {
				popup.setLatLng(e.latlng).setContent("클릭한 곳<br>" + e.latlng.toString()
								+ "<br><button id='addMarker'>마커추가</button>")
						.openOn(map);

				//마커추가 버튼 클릭 시 해당 위도경도 값으로 마커 추가
				$('#addMarker').click(function() {
					//버튼 클릭 시 해당 좌표에 마커 추가
					var marker = L.marker(e.latlng).addTo(map);
					//배열에 좌표 추가
					polyLatlng.push(e.latlng);
					console.log("좌표 : " + e.latlng);
					console.log("좌표값들 : " + polyLatlng);
					//맵 클릭 끄기
					map.off('click', onMapClick);
				});
			}
		};

		//추가된 마커끼리 폴리곤 생성
		function addpolygon() {
			//option태그의 선택 값
			var colorsel = document.getElementById("colorsel").value; //색깔
			var polygonW = document.getElementById("polygonW").value; //선 두께
			console.log(colorsel + " / " + polygonW);

			//마커가 3개 이상일 때 폴리곤 생성 가능
			if(polyLatlng.length >= 3){
				console.log(polyLatlng.length);
				//추가한 마커들의 좌표값들을 통해 폴리곤 생성
				var addpoly = L.polygon(polyLatlng, {
					color : colorsel,
					weight : polygonW,
					opacity : 0.7
				}).addTo(map);
				map.fitBounds(addpoly.getBounds());
				console.log(addpoly.getBounds());

				//추가 폴리곤 bindpopup 생성 시 폴리곤 위 클릭이 안됨
				//addpoly.bindPopup("추가된 폴리곤");

				//새로운 폴리곤을 만들기 위해 위경도 값 초기화
				polyLatlng = [];
			} else {
				alert("마커를 3개 이상 추가해주세요.");
			}
		}
		//alert 안내
		// function onMapClick(e) {
		// alert("You clicked the map at " + e.latlng);
		// }

		// map.on('click', onMapClick);
	</script>


	<script>
		var x = "";
		var y = "";
		var markers = [];

		$("#searchBtn")
				.click(
						function() {

							//이전에 찍었던 마커 삭제
							for (var i = 0; i < markers.length; i++) {
								map.removeLayer(markers[i]);
							}

							var params = {
								service : "search",
								request : "search",
								version : "2.0",
								crs : "EPSG:4326",
								size : 10,
								page : 1,
								query : $.trim($("#searchadd").val()),
								type : "address",
								category : "road",
								format : "json",
								errorformat : "json",
								key : "E375A39D-7B0F-39D2-ADDD-97066A55263A"
							}
							console.log(params);

							$
									.ajax({
										type : 'POST',
										url : '/search',
										contentType : 'application/json',
										dataType : 'json',
										data : JSON.stringify(params),
										success : function(result) {

											var status = result.response.status;
											console.log(status);
											//조회 성공일 경우만
											if (status == "OK") {
												console.log(result);

												//leaflet 지도 띄우기 (EPSG : 4326)
												//			 				leafletMap.panTo(new L.LatLng(y, x), 10);

												var flyX = "";
												var flyY = "";

												for (var i = 0; i < result.response.result.items.length; i++) {
													x = result.response.result.items[i].point.x;
													y = result.response.result.items[i].point.y;

													var title = result.response.result.items[i].title;
													var address = result.response.result.items[i].address.road;

													//핀마커 찍기
													leafletAddMarker(y, x,
															title, address);

												}

												//		 					leafletMap.flyTo([flyY, flyX], 15);

											}

											else {
												alert("해당 장소를 찾을수 없습니다.");
											}

										},
										error : function(request, status, error) {

										}
									});

						})

		//마커 추가
		function leafletAddMarker(lon, lat, title, address) {
			//핀마커
			var marker = L.marker([ lon, lat ]).addTo(map);

			//팝업 클릭시
			marker.bindPopup("<b>" + address + "</b><br><b>" + title + "</b>");
			markers.push(marker);

			map.panTo(new L.LatLng(lon, lat), 10);
		}
	</script>
	
	 -->
</body>
</html>