<%@ page language="java" contentType="text/html; charset=EUC-KR"
	pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="EUC-KR">
<title>openlayers</title>

<link rel="stylesheet"
	href="https://openlayers.org/en/v4.6.5/css/ol.css" type="text/css">
<!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->


<script
	src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
<script src="https://openlayers.org/en/v4.6.5/build/ol.js"></script>

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
</style>

</head>
<body>
	<div>
		<jsp:include page="/WEB-INF/views/common/header.jsp" />
	</div>
	<div id="map" class="map" tabindex="0"></div>
	<div id="apps">
		<button id="zoom-out">Zoom out</button>
		<button id="zoom-in">Zoom in</button>

		<button onclick="move()">클릭</button>
		<a class="skiplink" href="#map">Go to map</a>
	</div>
	
	<script src="js/common.js"></script>
	
	<script>
		var map = new ol.Map({
			layers : [ new ol.layer.Tile({
				source : new ol.source.OSM()
			}) ],
			target : 'map',
			controls : ol.control.defaults({
				attributionOptions : {
					collapsible : false
				}
			}),
			view : new ol.View({
				center : [ 0, 0 ],
				zoom : 16
			})
		});

		document.getElementById('zoom-out').onclick = function() {
			var view = map.getView();
			var zoom = view.getZoom();
			view.setZoom(zoom - 1);
		};

		document.getElementById('zoom-in').onclick = function() {
			var view = map.getView();
			var zoom = view.getZoom();
			view.setZoom(zoom + 1);
		};

		function move() {
			map.getView().setCenter(
					new ol.geom.Point([ 126.97077348, 37.55236577 ]).transform(
							'EPSG:4326', 'EPSG:3857').getCoordinates());
		}
	</script>
</body>
</html>