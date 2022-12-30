<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<link rel="stylesheet"
	href="https://unpkg.com/leaflet@1.9.3/dist/leaflet.css"
	integrity="sha256-kLaT2GOSpHechhsozzB+flnD+zUyjE2LlfWPgU04xyI="
	crossorigin="" />
<!-- Make sure you put this AFTER Leaflet's CSS -->
<script src="https://unpkg.com/leaflet@1.9.3/dist/leaflet.js"
	integrity="sha256-WBkoXOwTeyKclOHuWtc+i2uENFpDZ9YPdf5Hf+D7ewM="
	crossorigin=""></script>

<style>
/* 거리재기_leaflet */
#leafletDt {
	text-align: center;
	padding-left: 283px;
}

.leaflet-control-measure {
	font-size: 16px;
	font-weight: bold;
	line-height: 21px;
}

.leaflet-bar-part-top-and-bottom {
	-webkit-border-radius: 4px 4px 4px 4px;
	border-radius: 4px 4px 4px 4px;
	border-bottom: none;
}

.leaflet-touch .leaflet-bar-part-top-and-bottom {
	-webkit-border-radius: 7px 7px 7px 7px;
	border-radius: 7px 7px 7px 7px;
	border-bottom: none;
}

.leaflet-control-measure-on .leaflet-control-measure {
	box-shadow: 0 0 8px rgba(10, 10, 10, 1.0);
}

.leaflet-measure-tooltip {
	font: 20px/1.25 "Helvetica Neue", Arial, Helvetica, sans-serif;
	background-color: rgba(255, 255, 255, 0.7);
	box-shadow: 0 0 5px #BBB;
	margin: 0;
	padding: 2px;
	width: auto !important;
	height: auto !important;
	white-space: nowrap;
}

.leaflet-measure-tooltip-total {
	font-weight: bold;
}

.leaflet-measure-tooltip-difference {
	color: #777;
}
</style>

</head>
<body>

	<div class="container-fluid">
		<div class="row content">
			<div class="col-sm-6" style="border-left: 1px solid; height: 700px;">
				<h1>leaflet</h1>
				<div id="leafletMap"></div>
			</div>
		</div>
	</div>


	<script>
//leaflet 지도 띄우기
var leafletMap = L.map('leafletMap').setView([37.52470308242787, 14129046.928310394],14)    
//Vworld Tile 변경
L.tileLayer('http://xdworld.vworld.kr:8080/2d/Base/201802/{z}/{x}/{y}.png').addTo(leafletMap);
    
var plugin = L.control.measure({
    //  control position
    position: 'topleft',
    //  weather to use keyboard control for this plugin
    keyboard: true,
    //  shortcut to activate measure
    activeKeyCode: 'M'.charCodeAt(0),
    //거리재기 초기화 코드  //shortcut to cancel measure, defaults to 'Esc'
    cancelKeyCode: 27,
    //  line color
    lineColor: 'red',
    //  line weight
    lineWeight: 5,
    //  line dash
    lineDashArray: '6, 6',
    //  line opacity
    lineOpacity: 1,
    //  distance formatter
    // formatDistance: function (val) {
    //   return Math.round(1000 * val / 1609.344) / 1000 + 'mile';
    // }
}).addTo(leafletMap)
</script>

	<script>
L.Control.Measure = L.Control.extend({
  options: {
    position: 'topleft',
    //  weather to use keyboard control for this plugin
    keyboard: true,
    //  shortcut to activate measure
    activeKeyCode: 'M'.charCodeAt(0),
    //  shortcut to cancel measure, defaults to 'Esc'
    cancelKeyCode: 27,
    //  line color
    lineColor: 'black',
    //  line weight
    lineWeight: 2,
    //  line dash
    lineDashArray: '6, 6',
    //  line opacity
    lineOpacity: 1,
    //  format distance method
    formatDistance: null,
  },

  initialize: function (options) {
    //  apply options to instance
    L.Util.setOptions(this, options)
  },

  onAdd: function (map) {
    var className = 'leaflet-control-zoom leaflet-bar leaflet-control'
    var container = L.DomUtil.create('div', className)
    this._createButton('&#8674;', '嫄곕━�ш린',
    'leaflet-control-measure leaflet-bar-part leaflet-bar-part-top-and-bottom',
    container, this._toggleMeasure, this)

    if (this.options.keyboard) {
      L.DomEvent.on(document, 'keydown', this._onKeyDown, this)
    }

    return container
  },

  onRemove: function (map) {
    if (this.options.keyboard) {
      L.DomEvent.off(document, 'keydown', this._onKeyDown, this)
    }
  },

  _createButton: function (html, title, className, container, fn, context) {
    var link = L.DomUtil.create('a', className, container)
    link.innerHTML = html
    link.href = '#'
    link.title = title

    L.DomEvent
      .on(link, 'click', L.DomEvent.stopPropagation)
      .on(link, 'click', L.DomEvent.preventDefault)
      .on(link, 'click', fn, context)
      .on(link, 'dbclick', L.DomEvent.stopPropagation)
    return link
  },

  _toggleMeasure: function () {
    this._measuring = !this._measuring
    if (this._measuring) {
      L.DomUtil.addClass(this._container, 'leaflet-control-measure-on')
      this._startMeasuring()
    } else {
      L.DomUtil.removeClass(this._container, 'leaflet-control-measure-on')
      this._stopMeasuring()
    }
  },

  _startMeasuring: function () {
    this._oldCursor = this._map._container.style.cursor
    this._map._container.style.cursor = 'crosshair'
    this._doubleClickZoom = this._map.doubleClickZoom.enabled()
    this._map.doubleClickZoom.disable()
    this._isRestarted = false

    L.DomEvent
      .on(this._map, 'mousemove', this._mouseMove, this)
      .on(this._map, 'click', this._mouseClick, this)
      .on(this._map, 'dbclick', this._finishPath, this)

    if (!this._layerPaint) {
      this._layerPaint = L.layerGroup().addTo(this._map)
    }

    if (!this._points) {
      this._points = []
    }
  },

  _stopMeasuring: function () {
    this._map._container.style.cursor = this._oldCursor

    L.DomEvent
      .off(this._map, 'mousemove', this._mouseMove, this)
      .off(this._map, 'click', this._mouseClick, this)
      .off(this._map, 'dbclick', this._finishPath, this)

    if (this._doubleClickZoom) {
      this._map.doubleClickZoom.enabled()
    }
    if (this._layerPaint) {
      this._layerPaint.clearLayers()
    }

    this._restartPath()
  },

  _mouseMove: function (e) {
    if (!e.latlng || !this._lastPoint) {
      return
    }
    if (!this._layerPaintPathTemp) {
      //  customize style
      this._layerPaintPathTemp = L.polyline([this._lastPoint, e.latlng], {
        color: this.options.lineColor,
        weight: this.options.lineWeight,
        opacity: this.options.lineOpacity,
        clickable: false,
        dashArray: this.options.lineDashArray
      }).addTo(this._layerPaint)
    } else {
      //  replace the current layer to the newest draw points
      this._layerPaintPathTemp.getLatLngs().splice(0, 2, this._lastPoint, e.latlng)
      //  force path layer update
      this._layerPaintPathTemp.redraw()
    }

    //  tooltip
    if (this._tooltip) {
      if (!this._distance) {
        this._distance = 0
      }
      this._updateTooltipPosition(e.latlng)
      var distance = e.latlng.distanceTo(this._lastPoint)
      this._updateTooltipDistance(this._distance + distance, distance)
    }
  },

  _mouseClick: function (e) {
    if (!e.latlng) {
      return
    }

    if (this._isRestarted) {
      this._isRestarted = false
      return
    }

    if (this._lastPoint && this._tooltip) {
      if (!this._distance) {
        this._distance = 0
      }

      this._updateTooltipPosition(e.latlng)
      var distance = e.latlng.distanceTo(this._lastPoint)
      this._updateTooltipDistance(this._distance + distance, distance)

      this._distance += distance
    }

    this._createTooltip(e.latlng)

    //  main layer add to layerPaint
    if (this._lastPoint && !this._layerPaintPath) {
      this._layerPaintPath = L.polyline([this._lastPoint], {
        color: this.options.lineColor,
        weight: this.options.lineWeight,
        opacity: this.options.lineOpacity,
        clickable: false
      }).addTo(this._layerPaint)
    }

    //  push current point to the main layer
    if (this._layerPaintPath) {
      this._layerPaintPath.addLatLng(e.latlng)
    }

    if (this._lastPoint) {
      if (this._lastCircle) {
        this._lastCircle.off('click', this._finishPath, this)
      }
      this._lastCircle = this._createCircle(e.latlng).addTo(this._layerPaint)
      this._lastCircle.on('click', this._finishPath, this)
    }

    this._lastPoint = e.latlng
  },

  _finishPath: function (e) {
    if (e) {
      L.DomEvent.preventDefault(e)
    }
    if (this._lastCircle) {
      this._lastCircle.off('click', this._finishPath, this)
    }
    if (this._tooltip) {
      //  when remove from map, the _icon property becomes null
      this._layerPaint.removeLayer(this._tooltip)
    }
    if (this._layerPaint && this._layerPaintPathTemp) {
      this._layerPaint.removeLayer(this._layerPaintPathTemp)
    }

    //  clear everything
    this._restartPath()
  },

  _restartPath: function () {
    this._distance = 0
    this._lastCircle = undefined
    this._lastPoint = undefined
    this._tooltip = undefined
    this._layerPaintPath = undefined
    this._layerPaintPathTemp = undefined

    //  flag to stop propagation events...
    this._isRestarted = true
  },

  _createCircle: function (latlng) {
    return new L.CircleMarker(latlng, {
      color: 'black',
      opacity: 1,
      weight: 1,
      fillColor: 'white',
      fill: true,
      fillOpacity: 1,
      radius: 4,
      clickable: Boolean(this._lastCircle)
    })
  },

  _createTooltip: function (position) {
    var icon = L.divIcon({
      className: 'leaflet-measure-tooltip',
      iconAnchor: [-5, -5]
    })
    this._tooltip = L.marker(position, {
      icon: icon,
      clickable: false
    }).addTo(this._layerPaint)
  },

  _updateTooltipPosition: function (position) {
    this._tooltip.setLatLng(position)
  },

  _updateTooltipDistance: function (total, difference) {
    if (!this._tooltip._icon) {
      return
    }
    var totalRound = this._formatDistance(total)
    var differenceRound = this._formatDistance(difference)

    var text = '<div class="leaflet-measure-tooltip-total">' + totalRound + '</div>'
    if (differenceRound > 0 && totalRound !== differenceRound) {
      text += '<div class="leaflet-measure-tooltip-difference">(+' + differenceRound + ')</div>'
    }
    this._tooltip._icon.innerHTML = text
  },

  _formatDistance: function (val) {
    if (typeof this.options.formatDistance === 'function') {
      return this.options.formatDistance(val);
    }
    if (val < 1000) {
      return Math.round(val) + 'm'
    } else {
      return Math.round((val / 1000) * 100) / 100 + 'km'
    }
  },

  _onKeyDown: function (e) {
    // key control
    switch (e.keyCode) {
      case this.options.activeKeyCode:
        if (!this._measuring) {
          this._toggleMeasure()
        }
        break
      case this.options.cancelKeyCode:
        //  if measuring, cancel measuring
        if (this._measuring) {
          if (!this._lastPoint) {
            this._toggleMeasure()
          } else {
            this._finishPath()
            this._isRestarted = false
          }
        }
        break
    }
  }
})

L.control.measure = function (options) {
  return new L.Control.Measure(options)
}

L.Map.mergeOptions({
  measureControl: false
})

L.Map.addInitHook(function () {
  if (this.options.measureControl) {
    this.measureControl = new L.Control.Measure()
    this.addControl(this.measureControl)
  }
})
</script>
</body>
</html>