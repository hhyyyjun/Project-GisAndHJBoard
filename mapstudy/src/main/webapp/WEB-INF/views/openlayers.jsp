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
.tooltip {
	position: relative;
	background: rgba(0, 0, 0, 0.5);
	border-radius: 4px;
	color: white;
	padding: 4px 8px;
	opacity: 0.7;
	white-space: nowrap;
}

.tooltip-measure {
	opacity: 1;
	font-weight: bold;
}

.tooltip-static {
	background-color: #1DDB16;
	color: #fff;
	border: 1px solid white;
}

.tooltip-measure:before, .tooltip-static:before {
	border-top: 6px solid rgba(0, 0, 0, 0.5);
	border-right: 6px solid transparent;
	border-left: 6px solid transparent;
	content: "";
	position: absolute;
	bottom: -6px;
	margin-left: -7px;
	left: 50%;
}

.tooltip-static:before {
	border-top-color: #1DDB16;
}
</style>

</head>
<body>
	<div>
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
	</div>
	<div id="map" class="map" tabindex="0"></div>
<!-- 	<div id="popup" class="ol-popup"> -->
<!-- 		<a href="#" id="popup-closer" class="ol-popup-closer"></a> -->
<!-- 		<div id="popup-content"></div> -->
<!-- 	</div> -->
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
		</div>
		<div id="buttons">
			<button onClick="me()">내 위치 찾기</button>
			<button onclick="move()">서울역</button>
		</div>
		<select id="type">
			<option value="None">None</option>
			<option value="Point">Point</option>
			<option value="LineString">LineString</option>
			<option value="Polygon">Polygon</option>
			<option value="Circle">Circle</option>
		</select> <span>shift 클릭 시 자유 그리기</span>
		<select id="colorsel">
					<option value='rgba(255, 255, 255, 0.5)'>None</option>
					<option value='red'>red</option>
					<option value='blue'>blue</option>
					<option value='orange'>orange</option>
					<option value='green'>green</option>
					<option value='pink'>pink</option>
					<option value='yellow'>yellow</option>
					<option value='purple'>purple</option>
		</select>채우기 색 
		<select id="stroke">
					<option value="3">3</option>
					<option value="4">4</option>
					<option value="5">5</option>
					<option value="6">6</option>
					<option value="7">7</option>
					<option value="8">8</option>
					<option value="9">9</option>
		</select> 선 두께
		<select id="strokeColor">
					<option value='black'>None</option>
					<option value='red'>red</option>
					<option value='blue'>blue</option>
					<option value='orange'>orange</option>
					<option value='green'>green</option>
					<option value='pink'>pink</option>
					<option value='yellow'>yellow</option>
					<option value='purple'>purple</option>
		</select> 선 색깔
	</div>
	<script src="js/common.js"></script>

	<script>
	
		//레스터 레이어 설정
		var raster = new ol.layer.Tile({
			    source : new ol.source.OSM({
					url : 'https://{a-c}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png'
				}),
				visible : true
		});

		//좌표를 저장할 공간 생성
		var source = new ol.source.Vector();
		//백터 레이어 설정
		var vector = new ol.layer.Vector({
			source : source,
			//벡터 레이어의 스타일 설정
			style: new ol.style.Style({
	            fill: new ol.style.Fill({
	                color: "rgba(255, 255, 255, 0.5)"
	            }),
	            stroke: new ol.style.Stroke({
	                color: '#1DDB16',
	                width: 3
	            })
	        })
		});
		
		//처음 랜더링 시 나오는 지도 설정
		var mapView = new ol.View({
			//오픈레이어스는 위경도를 다른 api와 반대로 넣어야 함
			center : new ol.geom.Point([ NHLng, NHLat ]).transform('EPSG:4326',
					'EPSG:3857').getCoordinates(),
			maxZoon : 20,
			minZoon : 3,
			zoom : 15
			})
		//지도 설정
		var map = new ol.Map({
					//뷰 관리 설정
					layers : [raster, vector ],
					//지도를 표시할 대상의 id
					target : 'map',
					controls : ol.control.defaults({
						//우측하단 정보 표시
						attributionOptions : {
							//생략 버튼 생성할지 말지
							collapsible : false
						}
					}),
					view : mapView
				});
	</script>

	<script>
		//현재 그려진 도형
		var sketch;
		//안내 툴팁 요소
		var helpTooltipElement;
		//마우스 툴팁 메세지
		var helpTooltip;
		//측정값 툴팁 요소
		var measureTooltipElement;
		//오버레이할 측정값 툴팁
		var measureTooltip;
		//폴리곤 그릴 때 나올 설명
		var continuePolygonMsg = 'Click to continue drawing the polygon';
		//라인 그릴 때 나올 설명
		var continueLineMsg = 'Click to continue drawing the line';
		//원 그릴 때 나올 설명
		var continueCircle = 'Drag to continue drawing circle';
	
		
		////////////////////////////////////////핸들 포인터
		var pointerMoveHandler = function(e) {
	        if (e.dragging) {
	          return;
	        }
	        //그리기 도구 선택 시 안내 문구
	        var helpMsg = 'Click to start drawing';
			if(typeSelect == 'none'){
	        	helpMsg = '';
			}
			
	        if (sketch) {
	          //현재 도형의 요소 판별
	          var geom = (sketch.getGeometry());
	          if (geom instanceof ol.geom.Polygon) {
	            helpMsg = continuePolygonMsg;
	          } else if (geom instanceof ol.geom.LineString) {
	            helpMsg = continueLineMsg;
	          } else if	(geom instanceof ol.geom.Circle){
	        	helpMsg = continueCircle;
	          }
	        }
	        //HTML 삽입
	        helpTooltipElement.innerHTML = helpMsg;
	        //helpMsg를 마우스 포인터에 따라 생성
	        helpTooltip.setPosition(e.coordinate);
	        helpTooltipElement.classList.remove('hidden');
	      };
	
		///////////////////////////////////////도형 그리기 및 편집 기능
		var modify = new ol.interaction.Modify({
			source : source
		});
		map.addInteraction(modify);

		///////////////////////////////////////선 길이 측정
		var formatLength = function(line) {
			//선 길이 측정
	        var length = ol.Sphere.getLength(line);
	        var output;
	        // m기준 길이가 100이 초과하면
	        if (length > 1000) {
	        	//km 단위로 변경, math.round 반올림 함수
	          output = (Math.round(length / 1000 * 100) / 100) +
	              ' ' + 'km';
	        } else {
	          output = (Math.round(length * 100) / 100) +
	              ' ' + 'm';
	        }
	        return output;
	      };
	    ////////////////////////////////////폴리곤의 면적 측정
	    var formatArea = function(polygon) {
	    	//폴리곤 면적 측정
	        var area = ol.Sphere.getArea(polygon);
	        var output;
	        if (area > 10000) {
	          output = (Math.round(area / 1000000 * 100) / 100) +
	              ' ' + 'km<sup>2</sup>';
	        } else {
	          output = (Math.round(area * 100) / 100) +
	              ' ' + 'm<sup>2</sup>';
	        }
	        return output;
	      };
	    ///////////////////////////////////////원의 반경 측정
	    var formatCircle = function(circle){
	    	//원의 반경
	    	var radius = circle.getRadius();
	    	console.log("반경"+radius);
	    	var output;
	        // m기준 길이가 100이 초과하면
	        if (radius > 1000) {
	        	//km 단위로 변경, math.round 반올림 함수
	          output = '반경 ' + (Math.round(radius / 1000 * 100) / 100) +
	              ' ' + 'km';
	        } else {
	          output = '반경 ' + (Math.round(radius * 100) / 100) +
	              ' ' + 'm';
	        }
	        return output;
	    }
	    
	    var draw, snap;
		//id명이 type인 요소
		var typeSelect = document.getElementById('type');
		//색 변경 요소
		var fillSelect = document.getElementById('colorsel');
		//선 두께
		var stroke = document.getElementById('stroke');
		//선 색깔
		var strokeColor = document.getElementById('strokeColor');
		////////////////////////////////////////그리기 도구 시작
		function addInteractions() {
			draw = new ol.interaction.Draw({
				source : source,
				type : typeSelect.value,
				stopClick : true,
				style: new ol.style.Style({
		            fill: new ol.style.Fill({
		                color: 'rgba(255, 255, 255, 0.2)',
		            }),
		            stroke: new ol.style.Stroke({
		                color: 'red',
		                lineDash: [10, 10],
		                width: 2,
		            }),
		            image: new ol.style.Circle({
		                radius: 5,
		                stroke: new ol.style.Stroke({
		                    color: 'rgba(0, 0, 0, 0.7)'
		                }),
		                fill: new ol.style.Fill({
		                  color: 'rgba(255, 255, 255, 0.2)'
		                })
		            }),
				}),
			});
			//맵에 그리기 기능 시작
			map.addInteraction(draw);
			createMeasureTooltip();
	        createHelpTooltip();
			
			//////////////////////////////////////라인에 가까이 가면 마우스 포인터가 붙는다.
			snap = new ol.interaction.Snap({
				source : source
			});
			map.addInteraction(snap);
			
			
			var listener;
			//////////////////////////////////////////////그리기 시작하면
	        draw.on('drawstart',function(e) {
	              //현재 그린 도형의 요소
	              sketch = e.feature;

	              /** @type {ol.Coordinate|undefined} */
	              var tooltipCoord = e.coordinate;
				  //현재 그린 도형이 변경되면
	              listener = sketch.getGeometry().on('change', function(e) {
	                var geom = e.target;
	                var output;
	                if (geom instanceof ol.geom.Polygon) {
	                  output = formatArea(geom);
	                  tooltipCoord = geom.getInteriorPoint().getCoordinates();
	                } else if (geom instanceof ol.geom.LineString) {
	                  output = formatLength(geom);
	                  tooltipCoord = geom.getLastCoordinate();
	                } else if (geom instanceof ol.geom.Circle){
	                  output = formatCircle(geom);
	                  tooltipCoord = geom.getCenter();
	                }
	                measureTooltipElement.innerHTML = output;
	                measureTooltip.setPosition(tooltipCoord);
	              });
	            }, this);
			
			/////////////////////////////////////////그리기 완료 시
			draw.on('drawend', function(e){
				//방금 그린 도형 정보
	 			var feature = e.feature;
				//방금 그린 도형을 제외한 도형들 정보
	 			var features = source.getFeatures();
				//모든 도형의 정보
	 			var allFeats = features.concat(feature);
// 	 			console.log(feature);
// 	 			console.log(features);
// 	 			console.log(allFeats);
	 			
	 			measureTooltipElement.className = 'tooltip tooltip-static';
	            measureTooltip.setOffset([0, -7]);
	            // unset sketch
	            sketch = null;
	            // unset tooltip so that a new one can be created
	            measureTooltipElement = null;
	            createMeasureTooltip();
	            ol.Observable.unByKey(listener);
	            
	            //생성 시 사용자의 선택 옵션에 따라 색, 선 설정
	            feature.setStyle([
	            	new ol.style.Style({
	        			fill: new ol.style.Fill({
	    	           	    color: fillSelect.value
	    	          	}),
	    	          	stroke: new ol.style.Stroke({
	    	                color: strokeColor.value,
	    	                width: stroke.value
	    	            })
	            	})
	        	]);
	            vector.setOpacity(0.2);
	        	console.log(fillSelect.value);
	        	console.log(vector.getOpacity);
	        	
			}, this);
		}
		///////////////////////////////////툴팁 생성
		function createHelpTooltip() {
			//툴팁 요소가 존재하면
	        if (helpTooltipElement) {
	          //해당 요소 삭제
	          helpTooltipElement.parentNode.removeChild(helpTooltipElement);
	        }
			//툴팁 요소에 div html 태그 추가
	        helpTooltipElement = document.createElement('div');
			//추가한 태그에 클래스명 추가
	        helpTooltipElement.className = 'tooltip hidden';
			//위에서 셋업한 요소의 옵션 설정
	        helpTooltip = new ol.Overlay({
	          element: helpTooltipElement,
	          offset: [15, 0],
	          positioning: 'center-left'
	        });
	        map.addOverlay(helpTooltip);
	      }
		////////////////////////////////////측정값 툴팁 생성
		function createMeasureTooltip() {
	        if (measureTooltipElement) {
	          measureTooltipElement.parentNode.removeChild(measureTooltipElement);
	        }
	        measureTooltipElement = document.createElement('div');
	        measureTooltipElement.className = 'tooltip tooltip-measure';
	        measureTooltip = new ol.Overlay({
	          element: measureTooltipElement,
	          offset: [0, -15],
	          positioning: 'bottom-center'
	        });
	        map.addOverlay(measureTooltip);
	      }

		///////////////////////////////////그리기 도형 변경
		typeSelect.onchange = function() {
			map.removeInteraction(draw);
			map.removeInteraction(snap);
			//그리기 타입이 none인 경우
			if(typeSelect.value === 'None'){
				//기능 해제
				map.un('pointermove', pointerMoveHandler);
				//툴팁 삭제
				map.removeOverlay(helpTooltip);
				return;
			}
			addInteractions();
			map.on('pointermove', pointerMoveHandler);
		};
		
	</script>

	<script>
	//클릭 시 위경도값 받는다.
		map.on('click', function(e){
			var coordinate = ol.proj.transform(e.coordinate, 'EPSG:3857', 'EPSG:4326');
		    console.log(coordinate);
// 		    mapView.animate({zoom: 12}, {center: [0, 0]});
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
// 		var container = document.getElementById('popup');
// 		var content = document.getElementById('popup-content');
// 		var closer = document.getElementById('popup-closer');

		/**
		 * Create an overlay to anchor the popup to the map.
		 */
// 		var overlay = new ol.Overlay({
// 			element : container,
// 			autoPan : true,
// 			autoPanAnimation : {
// 				duration : 250
// 			}
// 		});

		/**
		 * Add a click handler to hide the popup.
		 * @return {boolean} Don't follow the href.
		 */
// 		closer.onclick = function() {
// 			overlay.setPosition(undefined);
// 			closer.blur();
// 			return false;
// 		};

// 		map.on('singleclick', function(evt) {
// 			var coordinate = evt.coordinate;
// 			var hdms = ol.coordinate.toStringHDMS(ol.proj.transform(coordinate,
// 					'EPSG:3857', 'EPSG:4326'));

// 			content.innerHTML = '<p>You clicked here:</p><code>' + hdms
// 					+ '</code>';
// 			overlay.setPosition(coordinate);
// 		});

	</script>

	<script>
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
</body>
</html>