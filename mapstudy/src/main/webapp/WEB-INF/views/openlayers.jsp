<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>openlayers</title>

<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet"
	href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
<!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->


<script
	src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
<script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.12.4.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

<style>
a.skiplink {
	position: absolute;
	clip: rect(1px, 1px, 1px, 1px);
	padding: 0;
	border: 0;
	height: 1px;
	width: 1px;
	overflow: hidden;
}

a.skiplink:focus {
	clip: auto;
	height: auto;
	width: auto;
	background-color: #fff;
	padding: 0.3em;
}

#map:focus {
	outline: #4A74A8 solid 0.15em;
}
#marker {
        width: 20px;
        height: 20px;
        border: 1px solid #088;
        border-radius: 10px;
        background-color: #0FF;
        opacity: 0.5;
      }
</style>

</head>
<body>
	<div>
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
	</div>
	<div id="map" class="map" tabindex="0"></div>
	<div id="popup" class="ol-popup">
		<a href="#" id="popup-closer" class="ol-popup-closer"></a>
		<div id="popup-content"></div>
	</div>
	<div id="apps">
		<button id="zoom-out">Zoom out</button>
		<button id="zoom-in">Zoom in</button>
	</div>
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
			<a class="skiplink" href="#map">Go to map</a>
			<button onclick="pinchk()" id="pinchk">핀 확인</button>
			<button onclick='pindel()' id="pindel" disabled>핀 삭제</button>
			<button onclick="circle()" id="circle" disabled>회사 주변 확인</button>
		</div>
		<select id="type">
			<option value="None">None</option>
			<option value="Point">Point</option>
			<option value="LineString">LineString</option>
			<option value="Polygon">Polygon</option>
			<option value="Circle">Circle</option>
		</select> <span>shift 클릭 시 자유 그리기</span>
	</div>
	

	<script src="js/common.js"></script>

	<script>
		//좌표를 저장할 공간 생성
		var source = new ol.source.Vector();
		var vectorLayer1 = new ol.layer.Vector({
			//화면 상의 동일한 좌표에 대해 중복으로 도형 표시 x
			source : source
		});
		var map = new ol.Map(
				{
					//뷰 관리 설정
					layers : [
							new ol.layer.Tile(
									{
										source : new ol.source.OSM(
												{
													url : 'https://{a-c}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png'
												}),
										visible : true,
									}), vectorLayer1 ],
					//지도를 표시할 대상의 id
					target : 'map',
					controls : ol.control.defaults({
						attributionOptions : {
							collapsible : false
						}
					}),
					view : new ol.View(
							{
								//오픈레이어스는 위경도를 다른 api와 반대로 넣어야 함
								center : new ol.geom.Point([ NHLng, NHLat ]).transform('EPSG:4326',
										'EPSG:3857').getCoordinates(),
								maxZoon : 20,
								minZoon : 3,
								zoom : 18
							})
				});
		//줌 아웃
		document.getElementById('zoom-out').onclick = function() {
			var view = map.getView();
			var zoom = view.getZoom();
			view.setZoom(zoom - 1);
		};
		//줌 인
		document.getElementById('zoom-in').onclick = function() {
			var view = map.getView();
			var zoom = view.getZoom();
			view.setZoom(zoom + 1);
		};
		// 서울역 이동
		function move() {
			var view = map.getView();
			view.setZoom(15);
			map.getView().setCenter(
					new ol.geom.Point([ seoulstationLng, seoulstationLat ])
							.transform('EPSG:4326', 'EPSG:3857')
							.getCoordinates());
		}
	</script>

	<script>
		//도형 그리기 및 편집 기능
		var modify = new ol.interaction.Modify({
			source : source
		});
		map.addInteraction(modify);

		var draw, snap; // global so we can remove them later
		var typeSelect = document.getElementById('type');

		function addInteractions() {
			draw = new ol.interaction.Draw({
				source : source,
				type : typeSelect.value
			});
			map.addInteraction(draw);
			snap = new ol.interaction.Snap({
				source : source
			});
			map.addInteraction(snap);
		}

		//기능 변경
		typeSelect.onchange = function() {
			map.removeInteraction(draw);
			map.removeInteraction(snap);
			if(typeSelect.value === 'None') return;
			addInteractions();
		};
	</script>

	<script>
	//클릭 시 위경도값 받는다.
		map.on('click', function(e){
			var coordinate = ol.proj.transform(e.coordinate, 'EPSG:3857', 'EPSG:4326');
		    //var coordinate = e.coordinate;
		    console.log(coordinate);
		})
		
	</script>



	<script>
		/*
			//select 태그의 option 데이터들
			var drawObject = $("#type");
			var drawControl;
			
			var updateDrawControl = function () {
				//선택한 option 의 값 저장
				var geometryType = drawObject.val();
				console.log(geometryType);
				
				//그리기 도구 선택 삭제
				map.removeInteraction(drawControl);
				if(geometryType === 'None') return;
				
				drawControl = new ol.interaction.Draw({
					type : geometryType,
					source : vectorLayer1.getSource()
				});
				
				map.addInteraction(drawControl);
			}
			//클릭 시 updateDrawControl function 실행
			drawObject.on('click', updateDrawControl);
		 */
	</script>

	<script>

		//맵 상 클릭 시 팝업 출력
		/*
		 * Elements that make up the popup.
		 */
		var container = document.getElementById('popup');
		var content = document.getElementById('popup-content');
		var closer = document.getElementById('popup-closer');

		/**
		 * Create an overlay to anchor the popup to the map.
		 */
		var overlay = new ol.Overlay({
			element : container,
			autoPan : true,
			autoPanAnimation : {
				duration : 250
			}
		});

		/**
		 * Add a click handler to hide the popup.
		 * @return {boolean} Don't follow the href.
		 */
		closer.onclick = function() {
			overlay.setPosition(undefined);
			closer.blur();
			return false;
		};

		map.on('singleclick', function(evt) {
			var coordinate = evt.coordinate;
			var hdms = ol.coordinate.toStringHDMS(ol.proj.transform(coordinate,
					'EPSG:3857', 'EPSG:4326'));

			content.innerHTML = '<p>You clicked here:</p><code>' + hdms
					+ '</code>';
			overlay.setPosition(coordinate);
		});

	</script>

</body>
</html>