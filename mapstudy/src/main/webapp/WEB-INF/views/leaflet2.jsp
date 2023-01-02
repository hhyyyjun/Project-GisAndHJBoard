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

<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/0.4.2/leaflet.draw.css" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/leaflet.draw/0.4.2/leaflet.draw.js"></script>

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
		console.log("초기화");
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
		
		
		//도형이 생성되었을 때
		//map.on(L.Draw.Event.CREATED, function (e) {
		map.on('draw:created', function (e) {
			   var type = e.layerType,
			       layer = e.layer;
			   
			   //타입이 마커인 경우
			   if(type === 'marker'){
			   }
			   
			   //타입이 원인 경우
			   if(type === 'circle'){
				   //원의 중심 좌표
				   var circleLatlng = layer.getLatLng();
			       console.log("중심 좌표 : "+circleLatlng);
			       //원의 중심에 마커 생성
			       var circleMarker = L.marker(circleLatlng).addTo(map);
			       console.log("중심 좌표의 마커 정보 : "+circleMarker);
			       //마커 클릭 시 해당 좌표 출력
			       circleMarker.bindPopup("이곳은 "+circleLatlng+" 입니다.").addTo(map);
			       //원의 반지름
			       var theRadius = layer.getRadius();
			       //원 내부 클릭 시 반지름 안내
			       layer.bindPopup("반경은 "+theRadius.toFixed(3)+"m 입니다.").addTo(map);
			    }
			   
				//그리기 도구가 사각형이라면
				if(type === 'rectangle'){
					//사각형 경로의 점을 배열로 저장(2차 배열로 저장된다.)
					var rect = layer.getLatLngs();
					console.log("좌표값 : "+rect);
					//가로 길이 계산
					var width = map.distance(rect[0][1], rect[0][2]);
					//세로 길이 계산
					var height = map.distance(rect[0][2], rect[0][3]);
					console.log(width, height);
					//넓이 계산
					var area = width * height;
					console.log(area);
					//사각형 내부 클릭 시 넓이를 팝업으로 출력
					layer.bindPopup("사각형의 넓이는 <br>"+area.toFixed(2)+"m 입니다.").addTo(map); 
				}
				//그리기 도구가 폴리곤이라면
				if(type === 'polygon'){
					
				}
				//그리기 도구가 마커라면
				if(type === 'marker'){
					
				}
			   
			   
			   
				drawnItems.addLayer(layer);
			});
		
		//그리기 종료 시
		map.on('draw:drawstop',function(e){
			//클릭 이벤트 해제
			map.off('click');
			map.off('mousedown');
		});

		
		//그리기 시작 시
		map.on('draw:drawstart',function(e){
			//그리기 도구의 타입체크			
			var type = e.layerType;
			//그리기 타입 체크
			console.log(type);
			
			//그리기 도구가 폴리라인 이라면
			if(type === 'polyline'){
				//클릭한 곳의 좌표값들이 들어갈 배열
				var clicks = [];
				//총 거리
				var totalDistance = 0;
				//마커
				var polylineMarker;
				//마커들
				var polylineMarkers = [];
				//지도 클릭하면 포인트 사이의 거리를 바인드 팝업으로 생성
				map.on('click', function(e){
					clicks.push(e.latlng);
					console.log("마커의 좌표 값 : "+clicks);
					//지도에 마커 추가
					polylineMarker = L.marker(e.latlng).addTo(map);
					//마커정보를 배열에 추가
					polylineMarkers.push(polylineMarker);
					console.log(polylineMarkers);
					//만약 clicks의 길이가 2이상이면
					if(clicks.length >= 2){
						//배열의 길이
						var i = clicks.length;
						//이전 마커의 좌표
						var distance1 = clicks[i-2];
						//이후 마커의 좌표
						var distance2 = clicks[i-1];
						//거리 계산
						var measure = map.distance(distance1, distance2);
						//거리 값
						console.log("마커 사이 거리 : "+measure.toFixed(3));
						//마커 사이의 거리를 툴팁으로 출력
						polylineMarker.bindTooltip(("거리 : "+measure.toFixed(3)+"m"),{
							permanent : true
						}).addTo(map).openTooltip();
						//총 거리 계산
						totalDistance += measure;
						console.log("현재까지 총 거리 : "+totalDistance.toFixed(3));
						//마커 배열의 마지막 인덱스의 마커 정보를 가져와
						var lastMarker = polylineMarkers[polylineMarkers.length-1];
						//마지막 마커에 총 거리 출력
						lastMarker.bindPopup("<div style='font-weight : bold; color : green;'>총 거리 : "+totalDistance.toFixed(3)+"m</div>");
						console.log("총 거리 : "+totalDistance.toFixed(3));
					}
				});
			}
		})
		
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
		
	</script>

		
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
</body>
</html>