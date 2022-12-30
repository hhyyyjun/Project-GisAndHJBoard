<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
<!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->
<script
	src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
<script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>
<script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=Set""></script>

<style>
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
	background-color: #ffcc33;
	color: black;
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
	border-top-color: #ffcc33;
}
</style>


</head>
<body>
	<div id="map" class="map"></div>
	<form class="form-inline">
		<label>Measurement type &nbsp;</label> <select id="type">
			<option value="none">none</option>
			<option value="LineString">Length (LineString)</option>
			<option value="Polygon">Area (Polygon)</option>
		</select>
	</form>
	<!-- 
    <form>
      <label>cluster distance</label>
      <input id="distance" type="range" min="0" max="100" step="1" value="40"/>
    </form>
     -->
	<form id="searchForm" action="#" class="form_data"
		onsubmit="return false;search();">
		<input type="hidden" name="page" value="1" /> <input type="hidden"
			name="type" value="PLACE" /> <input type="hidden" name="request"
			value="search" /> <input type="hidden" name="apiKey"
			value="E4A59B05-0CF4-3654-BD0C-A169F70CCB34" />

		<div>
			<input type="text" id="searchValue" name="query" value="야탑역"
				style="width: 100px;" /> <a href="javascript:search();">검색</a>
		</div>
	</form>

	<script>
      var raster = new ol.layer.Tile({
        source: new ol.source.OSM()
      });

      var source = new ol.source.Vector();

      var vector = new ol.layer.Vector({
        source: source,
        style: new ol.style.Style({
          fill: new ol.style.Fill({
            color: 'rgba(255, 255, 255, 0.2)'
          }),
          stroke: new ol.style.Stroke({
            color: '#ffcc33',
            width: 2
          }),
          image: new ol.style.Circle({
            radius: 7,
            fill: new ol.style.Fill({
              color: '#ffcc33'
            })
          })
        })
      });


      /**
       * Currently drawn feature.
       * @type {ol.Feature}
       */
      var sketch;


      /**
       * The help tooltip element.
       * @type {Element}
       */
      var helpTooltipElement;


      /**
       * Overlay to show the help messages.
       * @type {ol.Overlay}
       */
      var helpTooltip;


      /**
       * The measure tooltip element.
       * @type {Element}
       */
      var measureTooltipElement;


      /**
       * Overlay to show the measurement.
       * @type {ol.Overlay}
       */
      var measureTooltip;


      /**
       * Message to show when the user is drawing a polygon.
       * @type {string}
       */
      var continuePolygonMsg = 'Click to continue drawing the polygon';


      /**
       * Message to show when the user is drawing a line.
       * @type {string}
       */
      var continueLineMsg = 'Click to continue drawing the line';


      /**
       * Handle pointer move.
       * @param {ol.MapBrowserEvent} evt The event.
       */
      var pointerMoveHandler = function(evt) {
        if (evt.dragging) {
          return;
        }
        /** @type {string} */
        var helpMsg = 'Click to start drawing';
		if(typeSelect.value == 'none'){
        	helpMsg = '';
		}

        if (sketch) {
          var geom = (sketch.getGeometry());
          if (geom instanceof ol.geom.Polygon) {
            helpMsg = continuePolygonMsg;
          } else if (geom instanceof ol.geom.LineString) {
            helpMsg = continueLineMsg;
          }
        }
        helpTooltipElement.innerHTML = helpMsg;
        helpTooltip.setPosition(evt.coordinate);

        helpTooltipElement.classList.remove('hidden');
      };


      var map = new ol.Map({
        layers: [raster, vector],
        target: 'map',
        view: new ol.View({
          center: [-11000000, 4600000],
          zoom: 15
        })
      });

      //map.on('pointermove', pointerMoveHandler);

      /*
      map.getViewport().addEventListener('mouseout', function() {
        helpTooltipElement.classList.add('hidden');
      });
	  */
      var typeSelect = document.getElementById('type');

      var draw; // global so we can remove it later


      /**
       * Format length output.
       * @param {ol.geom.LineString} line The line.
       * @return {string} The formatted length.
       */
      var formatLength = function(line) {
        var length = ol.Sphere.getLength(line);
        var output;
        if (length > 100) {
          output = (Math.round(length / 1000 * 100) / 100) +
              ' ' + 'km';
        } else {
          output = (Math.round(length * 100) / 100) +
              ' ' + 'm';
        }
        return output;
      };


      /**
       * Format area output.
       * @param {ol.geom.Polygon} polygon The polygon.
       * @return {string} Formatted area.
       */
      var formatArea = function(polygon) {
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

      function addInteraction() {
        var type = typeSelect.value;
        draw = new ol.interaction.Draw({
          source: source,
          type: type,
          style: new ol.style.Style({
            fill: new ol.style.Fill({
              color: 'rgba(255, 255, 255, 0.2)'
            }),
            stroke: new ol.style.Stroke({
              color: 'rgba(0, 0, 0, 0.5)',
              lineDash: [10, 10],
              width: 2
            }),
            image: new ol.style.Circle({
              radius: 5,
              stroke: new ol.style.Stroke({
                color: 'rgba(0, 0, 0, 0.7)'
              }),
              fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)'
              })
            })
          })
        });
        map.addInteraction(draw);

        createMeasureTooltip();
        createHelpTooltip();

        var listener;
        draw.on('drawstart',
            function(evt) {
              // set sketch
              sketch = evt.feature;

              /** @type {ol.Coordinate|undefined} */
              var tooltipCoord = evt.coordinate;

              listener = sketch.getGeometry().on('change', function(evt) {
                var geom = evt.target;
                var output;
                if (geom instanceof ol.geom.Polygon) {
                  output = formatArea(geom);
                  tooltipCoord = geom.getInteriorPoint().getCoordinates();
                } else if (geom instanceof ol.geom.LineString) {
                  output = formatLength(geom);
                  tooltipCoord = geom.getLastCoordinate();
                }
                measureTooltipElement.innerHTML = output;
                measureTooltip.setPosition(tooltipCoord);
              });
            }, this);

        draw.on('drawend',
            function() {
              measureTooltipElement.className = 'tooltip tooltip-static';
              measureTooltip.setOffset([0, -7]);
              // unset sketch
              sketch = null;
              // unset tooltip so that a new one can be created
              measureTooltipElement = null;
              createMeasureTooltip();
              ol.Observable.unByKey(listener);
            }, this);
      }


      /**
       * Creates a new help tooltip
       */
      function createHelpTooltip() {
        if (helpTooltipElement) {
          helpTooltipElement.parentNode.removeChild(helpTooltipElement);
        }
        helpTooltipElement = document.createElement('div');
        helpTooltipElement.className = 'tooltip hidden';
        helpTooltip = new ol.Overlay({
          element: helpTooltipElement,
          offset: [15, 0],
          positioning: 'center-left'
        });
        map.addOverlay(helpTooltip);
      }


      /**
       * Creates a new measure tooltip
       */
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


      /**
       * Let user change the geometry type.
       */
      typeSelect.onchange = function() {
        map.removeInteraction(draw);
        if(typeSelect.value == 'none') return;
        addInteraction();
        map.on('pointermove', pointerMoveHandler);
      };

    </script>

	<!-- 
	<script>
      var map = new ol.Map({
        target: 'map',
        view: new ol.View({
          center: [0, 0],
          zoom: 1
        })
        //layers 추가하면 흐리게 지도 나옴
        /*
        layers: [
            new ol.layer.Tile({
            	source: new ol.source.OSM({
       			})
            })
          ]
      */
      });
	  //라벨 스타일 설정
      var labelStyle = new ol.style.Style({
        geometry: function(feature) {
          var geometry = feature.getGeometry();
          if (geometry.getType() == 'MultiPolygon') {
            // Only render label for the widest polygon of a multipolygon
            var polygons = geometry.getPolygons();
            var widest = 0;
            for (var i = 0, ii = polygons.length; i < ii; ++i) {
              var polygon = polygons[i];
              var width = ol.extent.getWidth(polygon.getExtent());
              if (width > widest) {
                widest = width;
                geometry = polygon;
              }
            }
          }
          return geometry;
        },
        text: new ol.style.Text({
          font: '12px Calibri,sans-serif',
          overflow: true,
          fill: new ol.style.Fill({
        	//글자색
            color: '#000'
          }),
          //글자 배경색
          stroke: new ol.style.Stroke({
            color: '#fff',
            width: 3
          })
        })
      });
	  //나라 스타일 설정
      var countryStyle = new ol.style.Style({
        fill: new ol.style.Fill({
        	//대륙 색
          color: 'rgba(255, 255, 255, 0.6)'
        }),
        stroke: new ol.style.Stroke({
        	//경계선 색
          color: '#319FD3',
          width: 1
        })
      });
      var style = [countryStyle, labelStyle];

      var vectorLayer = new ol.layer.Vector({
        source: new ol.source.Vector({
          url: 'https://openlayers.org/en/v4.6.5/examples/data/geojson/countries.geojson',
          format: new ol.format.GeoJSON()
        }),
        style: function(feature) {
          labelStyle.getText().setText(feature.get('name'));
          return style;
        },
        //작은 나라들 제외
        declutter: true
      });

      map.addLayer(vectorLayer);
    </script>
	 -->

	<!-- 
	<script type="text/javascript" src="http://map.vworld.kr/js/vworldMapInit.js.do?version=2.0&apiKey=767B7ADF-10BA-3D86-AB7E-02816B5B92E9"></script>
     <script>
     /*
		범위 설정
	
 var maxExtent = ol.proj.transformExtent([112.5, 29.53522956294847, 135, 45.089], 'EPSG:4326', 'EPSG:3857')
 var newProj = ol.proj.get('EPSG:3857');
 var newProjExtent = newProj.getExtent();
 var wgs84Sphere = new ol.Sphere(6378137);
 var radius = 800000;
 */
 /*
 	초기 위치 줌 설정 tile 설정
 	
 	브이월드 지도
 	source: new ol.source.XYZ({
			url: 'http://api.vworld.kr/req/wmts/1.0.0/E4A59B05-0CF4-3654-BD0C-A169F70CCB34/Base/{z}/{y}/{x}.png'
		})
 	OSM 지도
 	source: new ol.source.OSM()

 var map = new ol.Map({
   target: 'map',
   layers: [
     new ol.layer.Tile({
     	source: new ol.source.XYZ({
				url: 'http://api.vworld.kr/req/wmts/1.0.0/E4A59B05-0CF4-3654-BD0C-A169F70CCB34/Base/{z}/{y}/{x}.png'
			})
     })
   ],
   view: new ol.View({
     center: ol.proj.transform([126.9380517322744,37.16792263658907], 'EPSG:4326', 'EPSG:900913'),
     zoom: 7,
     extent :maxExtent
   })
 });*/
 
 vw.ol3.MapOptions = {
 	     basemapType: vw.ol3.BasemapType.GRAPHIC
 	   , controlDensity: vw.ol3.DensityType.EMPTY
 	   , interactionDensity: vw.ol3.DensityType.BASIC
 	   , controlsAutoArrange: true
 	   , homePosition: vw.ol3.CameraPosition
 	   , initPosition: vw.ol3.CameraPosition
 	  }; 
 	     
	  var map = new vw.ol3.Map("map",  vw.ol3.MapOptions);
	   
	  /* vw.ol3.SiteAlignType = {
	   NONE : "none",
	   TOP_LEFT: "top-left",
	   TOP_CENTER : "top-center",
	   TOP_RIGHT : "top-right",
	   CENTER_LEFT: "center-left",
	   CENTER_CENTER: "center-center",
	   CENTER_RIGHT : "center-right",
	   BOTTOM_LEFT : "bottom-left",
	   BOTTOM_CENTER : "bottom-center",
	   BOTTOM_RIGHT : "bottom-right"
	  }; */
	  var options = {
	      map: map
	    , site : vw.ol3.SiteAlignType.TOP_LEFT   //"top-left"
	    , vertical : true
	    , collapsed : false
	    , collapsible : false
	  };
	     
	  var _toolBtnList = [
	             new vw.ol3.button.Init(map),
	             new vw.ol3.button.ZoomIn(map),
	             new vw.ol3.button.ZoomOut(map),
	             new vw.ol3.button.DragZoomIn(map),
	             new vw.ol3.button.DragZoomOut(map) ,
	             new vw.ol3.button.Pan(map),    
	             new vw.ol3.button.Prev(map),
	             new vw.ol3.button.Next(map),
	             new vw.ol3.button.Full(map),
	             new vw.ol3.button.Distance(map),
	             new vw.ol3.button.Area(map)  
	            ];
	   
	  /* vw.ol3.SiteAlignType = {
	  NONE : "none",
	  TOP_LEFT: "top-left",
	  TOP_CENTER : "top-center",
	  TOP_RIGHT : "top-right",
	  CENTER_LEFT: "center-left",
	  CENTER_CENTER: "center-center",
	  CENTER_RIGHT : "center-right",
	  BOTTOM_LEFT : "bottom-left",
	  BOTTOM_CENTER : "bottom-center",
	  BOTTOM_RIGHT : "bottom-right"
	  }; */
	  var toolBar = new vw.ol3.control.Toolbar(options);
	  toolBar.addToolButtons(_toolBtnList);
	  map.addControl(toolBar);
 
 var features = new Array();
 var features2 = new Array();
 
 var styleCache = new Array();
 
	var search = function(){
		$.ajax({
			type: "get",
			url: "http://api.vworld.kr/req/search",
			data : $('#searchForm').serialize(),
			dataType: 'jsonp',
			async: false,
			success: function(data) {
				console.log(data);
				for(var o in data.response.result.items){ 
					if(o==0){
						move(data.response.result.items[o].point.x*1,data.response.result.items[o].point.y*1);
						features[o] = new ol.Feature({
					        geometry: new ol.geom.Point(ol.proj.transform([ data.response.result.items[o].point.x*1,data.response.result.items[o].point.y*1],'EPSG:4326', "EPSG:900913"))
					    
						}); // 포인트로 생성 확대하나 축소해도 길이 동일
						
						var radius = drawMeter(map,500,ol.proj.transform([ data.response.result.items[o].point.x*1,data.response.result.items[o].point.y*1],'EPSG:4326', "EPSG:900913"));
						features2[o] = new ol.Feature({
					        geometry: new ol.geom.Circle(ol.proj.transform([ data.response.result.items[o].point.x*1,data.response.result.items[o].point.y*1],'EPSG:4326', "EPSG:900913"),radius)
					    
						}); //원으로 생성 확대 축소 시 거리 수정
					
				        var stroke = new ol.style.Stroke({
				          color: 'rgba(255,255,0,0.9)',
				          width: 3
				        });
				        var style = new ol.style.Style({
				          stroke: stroke,
				          image: new ol.style.Circle({
				            radius: 10,
				            stroke: stroke
				          })
				        });
				        features[o].setStyle(style);
					}
					
				}
				
				var vectorSource = new ol.source.Vector({
		        	  features: features
		       	});
		       	
		        var VectorLayer = new ol.layer.Vector({
		            source: vectorSource
		        });
		        
				var vectorSource2 = new ol.source.Vector({
		        	  features: features2
		       	});
		       	
		        var VectorLayer2 = new ol.layer.Vector({
		            source: vectorSource2
		        });
		       	
		        /*
		        	기존검색결과를 제거하기 위해 키 값 생성
		   		*/
		   		VectorLayer.set("cluster","search_cluster")
		        VectorLayer2.set("cluster2","search_cluster")
		        
		        map.getLayers().forEach(function(layer){
					if(layer.get("cluster")=="search_cluster"||layer.get("cluster2")=="search_cluster"){
						map.removeLayer(layer);
					}
	    	    });
		        
				map.addLayer(VectorLayer);
				map.addLayer(VectorLayer2);
			},
			error: function(xhr, stat, err) {}
		});
		

	}
	
	var move = function(x,y){//127.10153, 37.402566
		console.log("move="+x+","+y);
		map.getView().setCenter(ol.proj.transform([ x, y ],'EPSG:4326', "EPSG:900913")); // 지도 이동
		map.getView().setZoom(16);
	}
	
	var coor1,coor2;
	/* 클릭 이벤트 제어 */ 
	map.on("click", function(evt) {
		var coordinate = evt.coordinate //좌표정보
		var pixel = evt.pixel
		var cluster_features = [];
		var features = [];
		
		if(coor1 == null){
			coor1 = coordinate;
		}else{
			if(coor2==null){
				coor2 = coordinate;
				console.log("두점거리 계산 구현 "+ol.proj.transform(coor1, "EPSG:900913",'EPSG:4326')+" 과 "+ol.proj.transform(coor2, "EPSG:900913",'EPSG:4326')+"의 거리계산");
				
				var wgs84Sphere= new ol.Sphere(6378137); //http://openlayers.org/en/latest/apidoc/ol.Sphere.html 참고
				
				//var distance = wgs84Sphere.haversineDistance(coor1,coor2)
				var distance = wgs84Sphere.haversineDistance(ol.proj.transform(coor1, "EPSG:900913",'EPSG:4326'),ol.proj.transform(coor2, "EPSG:900913",'EPSG:4326'))
				
				coor1=null;
				coor2=null;
				
				console.log("거리값 = "+ distance+ " 두점 초기화");
			}
		}
		
		map.forEachFeatureAtPixel(pixel, function(feature, layer) {
			console.log(feature);
		})
		
	});
	
	/* 선택시 스타일 설정*/
	var selectFeature = new ol.style.Style({
		image: new ol.style.Circle({
			radius: 10,
			stroke: new ol.style.Stroke({
				color: '#fff'
			}),
			fill: new ol.style.Fill({
				color: '#ff0000'
			})
		}),
		text: new ol.style.Text({
			font : '9px sans-serif',
			text:'★',
			fill: new ol.style.Fill({
				color: '#fff'
			})
		})
	});
	
	var selectInteraction = new ol.interaction.Select({
		features: function (feature) {
			return true;
		},
			style: [selectFeature]
		});
	map.getInteractions().extend([selectInteraction]);
	
	
	/**
		오버레이 삭제
	*/
	var deleteOverlay = function(id){
		map.removeOverlay(map.getOverlayById(id));
	}
     
     </script>
      -->

	<script>
	/*
	var sketch; //라인스트링 이벤트 시 geometry객체를 담을 변수
	var measureTooltipElement;//draw 이벤트가 진행 중일 때 담을 거리 값 element
	var measureTooltip; //툴팁 위치
	
        //브이월드 타일레이어 url 설정s
        var source =new ol.source.XYZ({
            url: 'http://xdworld.vworld.kr:8080/2d/Base/201802/{z}/{x}/{y}.png'
        });
		
        //타일레이어 생성하기
        var viewLayer = new ol.layer.Tile({
            source:source
        });
		//위치는 우리나라 중앙정도
        var view = new ol.View({
            center:[14248656.389982047, 4331624.063626864],
            zoom:7,
        });
        //빈객체생성
        var lineSource = new ol.source.Vector();
        var lineVector = new ol.layer.Vector({
            source:lineSource,
            style:function(feature){
                //linestring의 스타일 지정
                var style=new ol.style.Style({
                    stroke:new ol.style.Stroke({
                        color: '#ffcc33',
                        width: 2,
                    })
                })
            }
        })

        var mapView = new ol.Map({
            target:"map", // 지도를 생성할 element 객체의 id 값,
            layers:[viewLayer,lineVector], //생성한 레이어 추가,
            view:view,	//view 설정
        });
        
        
        
        mapView.addInteraction(new ol.interaction.Draw({
            source: lineSource,
            type: 'LineString',
		}))
		
		function addInteraction() {
    draw = new ol.interaction.Draw({
        source: lineSource,
        type: 'LineString',
        style: new ol.style.Style({
            fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)',
            }),
            stroke: new ol.style.Stroke({
                color: 'rgba(0, 0, 0, 0.5)',
                lineDash: [10, 10],
                width: 2,
            }),
            image: new ol.style.Circle({
                radius: 5
            }),
        }),
    })
    mapView.addInteraction(draw);
    createMeasureTooltip();

    var listener;
    draw.on('drawstart', function(evt) {
        console.log(evt)
        sketch = evt.feature;
        //var tooltipCoord = evt.coordinate;

        listener = sketch.getGeometry().on('change', function(evt) {
            var geom = evt.target;
            var output = formatLength(geom);
            tooltipCoord = geom.getLastCoordinate();

            measureTooltipElement.innerHTML = output;
            measureTooltip.setPosition(tooltipCoord);
        })
    })

    draw.on('drawend', function() {
        measureTooltipElement.className = 'ol-tooptip ol-tooltip-static';
        measureTooltip.setOffset([0, -7]);

        //unset sketch
        sketch = null;
        measureTooltipElement = null;
        createMeasureTooltip();
        new ol.Observable(listener)
    	})
	}
        function createMeasureTooltip() {
            if (measureTooltipElement) {
                measureTooltipElement.parentNode.removeChild(measureTooltipElement);
            }
            measureTooltipElement = document.createElement('div');
            measureTooltipElement.className = 'ol-tooltip ol-tooltip-measure';
            measureTooltip = new ol.Overlay({
                element: measureTooltipElement,
                offset: [0, -15],
                positioning: 'bottom-center',
            });
            mapView.addOverlay(measureTooltip);
        }

        function formatLength(line) {
            var length = ol.sphere.getLength(line);
            var output;
            if (length > 100) {
                output = Math.round((length / 1000) * 100) / 100 + ' ' + 'km';
            } else {
                output = Math.round(length * 100) / 100 + ' ' + 'm';
            }

            return output;
        };
        */
      </script>



	<script>
      /*
      // 포인트 레이어
        //브이월드 타일레이어 url 설정s
        var source =new ol.source.XYZ({
            url: 'http://xdworld.vworld.kr:8080/2d/Base/201802/{z}/{x}/{y}.png'
        });
		
        //타일레이어 생성하기
        var viewLayer = new ol.layer.Tile({
            source:source
        });
		
        //위치는 우리나라 중앙쯤(?)
        var view = new ol.View({
            center:[14248656.389982047, 4331624.063626864],
            zoom:8,
        });

        var mapView = new ol.Map({
            target:"map", // 지도를 생성할 element 객체의 id 값,
            layers:[viewLayer], //생성한 레이어 추가,
             view:view,	//view 설정
			
		});
    
        mapView.on('click',function(e){
            //console.log(e.coordinate);
            var x = e.coordinate[0];
            var y = e.coordinate[1];
            
            //point Geometry 객체를 생성한다.
            var point = new ol.geom.Point([x,y]);
            
            var pointSourceLayer = new ol.source.Vector({
                features:[new ol.Feature(point)]
            });
            //레이어 생성할 때 스타일을 지정해준다.
            var pointVectorLayer = new ol.layer.Vector({
                source:pointSourceLayer,
                style: new ol.style.Style({
                    image: new ol.style.Circle({
                         radius: 12,
                         fill: new ol.style.Fill({color: 'blue'}),
                    })
                })
            });
            
            this.addLayer(pointVectorLayer);
        })
        */
    </script>


	<script>
    /*
      var distance = document.getElementById('distance');

      //데이터 수
      var count = 500;
      var features = new Array(count);
      //범위
      var e = 20000000;
      for (var i = 0; i < count; ++i) {
        var coordinates = [2 * e * Math.random() - e, 2 * e * Math.random() - e];
        features[i] = new ol.Feature(new ol.geom.Point(coordinates));
      }

      var source = new ol.source.Vector({
        features: features
      });

      var clusterSource = new ol.source.Cluster({
        distance: parseInt(distance.value, 10),
        source: source
      });

      var styleCache = {};
      var clusters = new ol.layer.Vector({
        source: clusterSource,
        style: function(feature) {
          var size = feature.get('features').length;
          var style = styleCache[size];
          if (!style) {
            style = new ol.style.Style({
              image: new ol.style.Circle({
                radius: 10,
                stroke: new ol.style.Stroke({
                  color: '#fff'
                }),
                fill: new ol.style.Fill({
                  color: '#3399CC'
                })
              }),
              text: new ol.style.Text({
                text: size.toString(),
                fill: new ol.style.Fill({
                  color: '#fff'
                })
              })
            });
            styleCache[size] = style;
          }
          return style;
        }
      });

      var raster = new ol.layer.Tile({
        source: new ol.source.OSM()
      });

      var map = new ol.Map({
        layers: [raster, clusters],
        target: 'map',
        view: new ol.View({
          center: [0, 0],
          zoom: 2
        })
      });

      distance.addEventListener('input', function() {
        clusterSource.setDistance(parseInt(distance.value, 10));
      });
      */
    </script>
</body>
</html>