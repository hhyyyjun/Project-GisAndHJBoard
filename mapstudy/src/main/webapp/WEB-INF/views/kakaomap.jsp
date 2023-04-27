<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>kakaomap</title>

<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.12.4.min.js"></script>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
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
			<div>
				<button onclick="showMarkers()">마커 보이기</button>
				<button onclick="hideMarkers()">마커 숨기기</button>
			</div>
		</div>
		<div id="clickLatlng"></div>
		<div id="buttons">
			<button onClick="me()">내 위치 찾기</button>
			<button onclick="move()">서울역</button>
			<button onclick="addPin()">핀 생성하기</button>
			<button onclick="pinchk()" id="pinchk">핀 확인</button>
			<button onclick='pindel()' id="pindel" disabled>핀 삭제</button>
			<button onclick="polygon()" id="polygon" disabled>폴리곤 연결</button>
			<button onclick="circle()" id="circle" disabled>회사 주변 확인</button>
		</div>
		<div>
			<button onclick="letsDraw()">지도 그리기</button>
			<button class="draw" onclick="selectOverlay('MARKER')" disabled>마커</button>
			<button class="draw" onclick="selectOverlay('POLYLINE')" disabled>선</button>
			<button class="draw" onclick="selectOverlay('CIRCLE')" disabled>원</button>
			<button class="draw" onclick="selectOverlay('RECTANGLE')" disabled>사각형</button>
			<button class="draw" onclick="selectOverlay('POLYGON')" disabled>다각형</button>
		</div>
	</div>
	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=5a1f9ffba7242dca60963ad07d1d79b3&libraries=drawing"></script>
	<script src="js/common.js"></script>

	<script type="text/javascript"
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=5a1f9ffba7242dca60963ad07d1d79b3"></script>
	<script>
		//////////////////지도 띄우기
		var container = document.getElementById('map');
		var options = {
			center : new kakao.maps.LatLng(NHLat, NHLng),
			level : 3
		};
		var map = new kakao.maps.Map(container, options);

		/////////////////지도 컨트롤
		// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
		var mapTypeControl = new kakao.maps.MapTypeControl();

		// 지도에 컨트롤을 추가해야 지도위에 표시됩니다
		// kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미합니다
		map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);

		// 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 생성합니다
		var zoomControl = new kakao.maps.ZoomControl();
		map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

		//////////////////////////////////////////////////////////////////////////////////////////////
		////////////////////핀 확인
		//서울역, 시청역, 오픈메이트에 마커가 생성되고 모든 마커가 보이는 레벨로 변경
		function pinchk() {
			// 마커를 표시할 위치와 title 객체 배열입니다 
			var positions = [
					{
						title : '시청역',
						content : '<div>시청역이다</div>',
						latlng : new kakao.maps.LatLng(cityhallLat, cityhallLng)
					},
					{
						title : '오픈메이트',
						content : '<div>오픈이다</div>',
						latlng : new kakao.maps.LatLng(openmateLat, openmateLng)
					},
					{
						title : '서울역',
						content : '<div>설역이다</div>',
						latlng : new kakao.maps.LatLng(seoulstationLat,
								seoulstationLng)
					}, ];
			//지도 레벨 변경
			map.setLevel(5);

			// 이동할 위도 경도 위치를 생성합니다 
			var moveToPinCenter = new kakao.maps.LatLng(moveToPinCenterLat,
					moveToPinCenterLng);
			// 지도 중심을 부드럽게 이동시킵니다
			// 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
			map.panTo(moveToPinCenter);

			// 마커 이미지의 이미지 주소입니다
			var imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png";

			for (var i = 0; i < positions.length; i++) {

				// 마커 이미지의 이미지 크기 입니다
				var imageSize = new kakao.maps.Size(24, 35);

				// 마커 이미지를 생성합니다    
				var markerImage = new kakao.maps.MarkerImage(imageSrc,
						imageSize);

				// 마커를 생성합니다
				var marker = new kakao.maps.Marker({
					map : map, // 마커를 표시할 지도
					position : positions[i].latlng, // 마커를 표시할 위치
					title : positions[i].title, // 마커의 타이틀, 마커에 마우스를 올리면 타이틀이 표시됩니다
					image : markerImage
				// 마커 이미지 
				});
				// 마커에 표시할 인포윈도우를 생성합니다 
				var infowindow = new kakao.maps.InfoWindow({
					content : positions[i].content
				// 인포윈도우에 표시할 내용
				});
				// 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
				// 이벤트 리스너로는 클로저를 만들어 등록합니다 
				// for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
				kakao.maps.event.addListener(marker, 'mouseover',
						makeOverListener(map, marker, infowindow));
				kakao.maps.event.addListener(marker, 'mouseout',
						makeOutListener(infowindow));
			}
			// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
			function makeOverListener(map, marker, infowindow) {
				return function() {
					infowindow.open(map, marker);
				};
			}
			// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
			function makeOutListener(infowindow) {
				return function() {
					infowindow.close();
				};
			}

		}

		/*
		// 지도에 클릭 이벤트를 등록합니다
		// 지도를 클릭하면 마지막 파라미터로 넘어온 함수를 호출합니다
		kakao.maps.event.addListener(map, 'click', function(mouseEvent) {        
		    
		    // 클릭한 위도, 경도 정보를 가져옵니다 
		    var latlng = mouseEvent.latLng; 
		    
		    // 마커 위치를 클릭한 위치로 옮깁니다
		    marker.setPosition(latlng);
		    
		    var message = '클릭한 위치의 위도는 ' + latlng.getLat() + ' 이고, ';
		    message += '경도는 ' + latlng.getLng() + ' 입니다';
		    
		    var resultDiv = document.getElementById('clickLatlng'); 
		    resultDiv.innerHTML = message;
		    
		});
		 */

		//////////////////////////////////////////////////////////////////////////////////////////////
		//핀 추가하기
		var latLng = "";
		var infowindow = "";
		var flag = false;
		function addPin() {
			// 지도에 마커 추가여부 버튼 생성
			var makeMarker = "<button style='padding : 5px;' onclick='plusPin()'>마커추가</button>";
			// 마커에 클릭이벤트를 등록합니다
			flag = true;
			kakao.maps.event.addListener(map, 'click', function(mouseEvent) {
				if (flag) {
					//인포 윈도우 생성
					infowindow = new kakao.maps.InfoWindow({
						map : map,
						position : mouseEvent.latLng,
						content : makeMarker,
						removable : true
					});

					latLng = mouseEvent.latLng;
					flag = false;
				}
			});
		}

		function plusPin() {
			//alert(latLng);
			addMarker(latLng);
			infowindow.close();
		}

		//////////////////////////////////////////////////////////////////////////////////////////////
		// 지도에 표시된 마커 객체를 가지고 있을 배열입니다
		//클릭 시 들어가는 마커 전체 정보
		var markers4clk = [];
		//클릭 시 들어가는 마커 위경도 값
		var markers4polygon = [];
		// 마커를 생성하고 지도위에 표시하는 함수입니다
		function addMarker(position) {

			// 마커를 생성합니다
			var clkmarker = new kakao.maps.Marker({
				position : position
			});
			// 마커가 지도 위에 표시되도록 설정합니다
			clkmarker.setMap(map);
			// 생성된 마커를 배열에 추가합니다
			markers4polygon.push(position);
			markers4clk.push(clkmarker);
			console.log(markers4polygon);
		}

		// 배열에 추가된 마커들을 지도에 표시하거나 삭제하는 함수입니다
		function setMarkers(map) {
			console.log(markers4clk);
			for (var i = 0; i < markers4clk.length; i++) {
				markers4clk[i].setMap(map);
			}
		}
		// "마커 보이기" 버튼을 클릭하면 호출되어 배열에 추가된 마커를 지도에 표시하는 함수입니다
		function showMarkers() {
			setMarkers(map)
		}
		// "마커 감추기" 버튼을 클릭하면 호출되어 배열에 추가된 마커를 지도에서 삭제하는 함수입니다
		function hideMarkers() {
			setMarkers(null);
		}

		//클릭한 마커끼리 폴리곤 생성하기
		function addpolygon() {
			console.log("시작");
			var colorsel = document.getElementById("colorsel").value;
			var polygonW = document.getElementById("polygonW").value;
			// 다각형을 구성하는 좌표 배열입니다. 이 좌표들을 이어서 다각형을 표시합니다
			// markers4polygon 배열에 저장되어 있음.
			console.log("배열값확인1 : " + markers4polygon);
			// 지도에 표시할 다각형을 생성합니다
			var polygon = new kakao.maps.Polygon({
				path : markers4polygon, // 그려질 다각형의 좌표 배열입니다
				strokeWeight : polygonW, // 선의 두께입니다
				strokeColor : '#39DE2A', // 선의 색깔입니다
				strokeOpacity : 0.8, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
				strokeStyle : 'longdash', // 선의 스타일입니다
				fillColor : colorsel, // 채우기 색깔입니다
				fillOpacity : 0.7
			// 채우기 불투명도 입니다
			});
			console.log("여긴 지나감?");
			// 지도에 다각형을 표시합니다
			if (markers4polygon.length >= 3) {
				polygon.setMap(map);
				markers4polygon = [];
			} else {
				alert("마커를 3개 이상 지정해주세요.");
			}
			console.log("배열값확인2 : " + markers4polygon);
		}

		/*
		// 마커가 표시될 위치입니다 
		var markerPosition = new kakao.maps.LatLng(37.56249213, 126.96849315);

		// 마커를 생성합니다
		var marker = new kakao.maps.Marker({
			position : markerPosition
		});

		// 마커가 지도 위에 표시되도록 설정합니다
		marker.setMap(map);

		// 마커가 드래그 가능하도록 설정합니다 
		marker.setDraggable(true);
		 */

		//////////////////////////////////////////////////////////////////////////////////////////////
		//버튼 클릭 시 이동
		function move() {
			// 이동할 위도 경도 위치를 생성합니다 
			var moveLatLon = new kakao.maps.LatLng(seoulstationLat,
					seoulstationLng);

			// 지도 중심을 부드럽게 이동시킵니다
			// 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
			map.panTo(moveLatLon);
		}

		//////////////////////////////////////////////////////////////////////////////////////////////
		// 그리기 도구
		function letsDraw() {
			console.log($(".draw"));
			$(".draw").prop("disabled", false);
		}
		// 도형 스타일을 변수로 설정합니다
		var strokeColor = '#39f', fillColor = '#cce6ff', fillOpacity = 0.5, hintStrokeStyle = 'dash';
		var drawOptions = { // Drawing Manager를 생성할 때 사용할 옵션입니다
			map : map, // Drawing Manager로 그리기 요소를 그릴 map 객체입니다
			drawingMode : [ // drawing manager로 제공할 그리기 요소 모드입니다
			kakao.maps.drawing.OverlayType.MARKER,
					kakao.maps.Drawing.OverlayType.ARROW,
					kakao.maps.drawing.OverlayType.POLYLINE,
					kakao.maps.drawing.OverlayType.RECTANGLE,
					kakao.maps.drawing.OverlayType.CIRCLE,
					kakao.maps.Drawing.OverlayType.ELLIPSE,
					kakao.maps.drawing.OverlayType.POLYGON ],
			// 사용자에게 제공할 그리기 가이드 툴팁입니다
			// 사용자에게 도형을 그릴때, 드래그할때, 수정할때 가이드 툴팁을 표시하도록 설정합니다
			guideTooltip : [ 'draw', 'drag', 'edit' ],
			markerOptions : { // 마커 옵션입니다 
				draggable : true, // 마커를 그리고 나서 드래그 가능하게 합니다 
				removable : true
			// 마커를 삭제 할 수 있도록 x 버튼이 표시됩니다  
			},
			arrowOptions : {
				draggable : true,
				removable : true,
				strokeColor : strokeColor,
				hintStrokeStyle : hintStrokeStyle
			},
			polylineOptions : { // 선 옵션입니다
				draggable : true, // 그린 후 드래그가 가능하도록 설정합니다
				removable : true, // 그린 후 삭제 할 수 있도록 x 버튼이 표시됩니다
				editable : true, // 그린 후 수정할 수 있도록 설정합니다 
				strokeColor : '#39f', // 선 색
				hintStrokeStyle : 'dash', // 그리중 마우스를 따라다니는 보조선의 선 스타일
				hintStrokeOpacity : 0.5
			// 그리중 마우스를 따라다니는 보조선의 투명도
			},
			rectangleOptions : {
				draggable : true,
				removable : true,
				editable : true,
				strokeColor : '#39f', // 외곽선 색
				fillColor : '#39f', // 채우기 색
				fillOpacity : 0.5
			// 채우기색 투명도
			},
			circleOptions : {
				draggable : true,
				removable : true,
				editable : true,
				strokeColor : '#39f',
				fillColor : '#39f',
				fillOpacity : 0.5
			},
			ellipseOptions : {
				draggable : true,
				removable : true,
				strokeColor : strokeColor,
				fillColor : fillColor,
				fillOpacity : fillOpacity
			},
			polygonOptions : {
				draggable : true,
				removable : true,
				editable : true,
				strokeColor : '#39f',
				fillColor : '#39f',
				fillOpacity : 0.5,
				hintStrokeStyle : 'dash',
				hintStrokeOpacity : 0.5
			}
		};

		// 위에 작성한 옵션으로 Drawing Manager를 생성합니다
		var manager = new kakao.maps.drawing.DrawingManager(drawOptions);

		// Toolbox를 생성합니다. 
		// Toolbox 생성 시 위에서 생성한 DrawingManager 객체를 설정합니다.
		// DrawingManager 객체를 꼭 설정해야만 그리기 모드와 매니저의 상태를 툴박스에 설정할 수 있습니다.
		var toolbox = new kakao.maps.Drawing.Toolbox({
			drawingManager : manager
		});
		// 지도 위에 Toolbox를 표시합니다
		// kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOP은 위 가운데를 의미합니다.
		map.addControl(toolbox.getElement(), kakao.maps.ControlPosition.TOP);

		// 버튼 클릭 시 호출되는 핸들러 입니다
		function selectOverlay(type) {
			console.log("선택은 된거?");
			// 그리기 중이면 그리기를 취소합니다
			//manager.cancel();

			// 클릭한 그리기 요소 타입을 선택합니다
			manager.select(kakao.maps.drawing.OverlayType[type]);
		}
	</script>
</body>
</html>
