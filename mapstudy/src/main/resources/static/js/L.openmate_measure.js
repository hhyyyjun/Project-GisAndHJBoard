L.GeometryUtil.readableArea = function( area, isMetric ){
	var areaStr;

	if (isMetric) {
		if (area >= 1000000) {
			areaStr = (area/ 1000000 ).toFixed(2)  + ' km&sup2;';
		} else {
			areaStr = area.toFixed(2) + ' m&sup2;';
		}
	} else {
		area /= 0.836127; // Square yards in 1 meter

		if (area >= 3097600) { //3097600 square yards in 1 square mile
			areaStr = (area / 3097600).toFixed(2) + ' mi&sup2;';
		} else if (area >= 4840) {//48040 square yards in 1 acre
			areaStr = (area / 4840).toFixed(2) + ' acres';
		} else {
			areaStr = Math.ceil(area) + ' yd&sup2;';
		}
	}

	return areaStr;
}



function getElementsByClassName(node,classname) {
  if (node.getElementsByClassName) { // use native implementation if available
    return node.getElementsByClassName(classname);
  } else {
    return (function getElementsByClass(searchClass,node) {
        if ( node == null )
          node = document;
        var classElements = [],
            els = node.getElementsByTagName("*"),
            elsLen = els.length,
            pattern = new RegExp("(^|\\s)"+searchClass+"(\\s|$)"), i, j;

        for (i = 0, j = 0; i < elsLen; i++) {
          if ( pattern.test(els[i].className) ) {
              classElements[j] = els[i];
              j++;
          }
        }
        return classElements;
    })(classname, node);
  }
}
L.vTooltip = L.Tooltip.extend({
	latestlatlng : null,
	initialize : function(map,latlng) {
		this._map = map;
		this._popupPane = map._panes.popupPane;

		this._container = map.options.drawControlTooltips ? L.DomUtil.create(
				'div', 'leaflet-draw-tooltip', this._popupPane) : null;
		this._singleLineLabel = false;
		this._map.on('zoomend', this._onZoomEnd, this);
		this.latestlatlng = latlng;
	},

	dispose : function() {
		this._map.off('zoomend', this._onZoomEnd, this);

		if (this._container) {
			this._popupPane.removeChild(this._container);
			this._container = null;
		}
	},
	_onZoomEnd : function(e) {
		this.updatePosition(this.latestlatlng);
	},
	updateContent: function (labelText,subtext) {
		if (!this._container) {
			return this;
		}
		this._container.style.marginTop = "0px";
		this._container.innerHTML =	'<span class="leaflet-draw-tooltip-subtext">' + subtext + '</span>' + '<br />';
		return this;
	},
	finishContent: function (prefix , subtext) {
		if (!this._container) {
			return this;
		}
		this._container.style.marginTop="10px";
		this._container.innerHTML =prefix+' : <span class="leaflet-draw-tooltip-subtext">' + subtext + '</span> <a href="#" class="close"><img src=\"/gis/js/leaflet-1.3.4/images/ic_tooltip_close.png\"/></a>' + '<br />' ;
		return this;
	},
	updatePosition : function(latlng) {
		var pos = this._map.latLngToLayerPoint(latlng),
		tooltipContainer = this._container;

		if (this._container) {
			tooltipContainer.style.visibility = 'inherit';
			L.DomUtil.setPosition(tooltipContainer, pos);
		}
		this.latestlatlng = latlng;
		//this._latlng = latlng;
		return this;
		/*
		this._updatePosition();
		*/
	}

});
L.Polyline.area = L.Draw.Polygon.extend({
	options: {
		showArea: true,
		allowIntersection: false,
		shapeOptions: {
			stroke: true,
			color: '#0000ff',
			weight: 4,
			opacity: 1,
			fill: true,
			fillColor: null, //same as color by default
			fillOpacity: 0.2,
			clickable: true
		},
		metric: true // Whether to use the metric measurement system or imperial
	},
	_tips:[],
	_dummyTips:[],
	_polyArr:[],
	_fireCreatedEvent: function () {
		var poly = new this.Poly(this._poly.getLatLngs(), this.options.shapeOptions);
		this._polyArr.push(poly);
		var latlng = this._poly.getLatLngs()[this._poly.getLatLngs().length - 1];
		
		var vtooltip = new L.vTooltip(this._map,latlng);
		vtooltip.updatePosition(latlng);
		var tip = vtooltip.finishContent("면적",this._getTooltipText().subtext);
		this._tips.push(vtooltip);
		
		var closer = getElementsByClassName(tip._container,"close");
		L.DomEvent.on(closer[0], 'click',function(e){
			this._removeMeasureItem(poly);
			vtooltip.dispose();
		}, this);
		L.Draw.Feature.prototype._fireCreatedEvent.call(this, poly);
		this._map.fire('measure:finished', { method: "area",message: "finish!" });
	},
	_geodesicArea: function (latLngs) {
		var pointsCount = latLngs.length,
			area = 0.0,
			d2r = Math.PI / 180,
			p1, p2;

		if (pointsCount > 2) {
			for (var i = 0; i < pointsCount; i++) {
				p1 = latLngs[i];
				p2 = latLngs[(i + 1) % pointsCount];
				area += ((p2.lng - p1.lng) * d2r) *
						(2 + Math.sin(p1.lat * d2r) + Math.sin(p2.lat * d2r));
			}
			area = area * 6378137.0 * 6378137.0 / 2.0;
		}

		return Math.abs(area);
	},
	_vertexChanged: function (latlng, added) {
		var latLngs;
		// Check to see if we should show the area
		if (!this.options.allowIntersection && this.options.showArea) {
			latLngs = this._poly.getLatLngs();

			this._area = this._geodesicArea(latLngs);
		}

		L.Draw.Polyline.prototype._vertexChanged.call(this, latlng, added);
	},
	_removeMeasureItem: function(poly){
		this._map.removeLayer(poly);
	},
	removeAllMeasureItem: function(){
		for(var i = 0 ;i<this._polyArr.length;i++){
			this._removeMeasureItem(this._polyArr[i]);
		}
		
		for(var j = 0;j< this._tips.length;j++){
			this._tips[j].dispose();
		}
	}
});

L.Polyline.distance = L.Draw.Polyline.extend({
	options: {
		allowIntersection: true,
		repeatMode: false,
		drawError: {
			color: '#b00b00',
			timeout: 2500
		},
		icon: new L.DivIcon({
			iconSize: new L.Point(8, 8),
			className: 'leaflet-div-icon leaflet-editing-icon'
		}),
		touchIcon: new L.DivIcon({
			iconSize: new L.Point(20, 20),
			className: 'leaflet-div-icon leaflet-editing-icon leaflet-touch-icon'
		}),
		guidelineDistance: 20,
		maxGuideLineLength: 4000,
		shapeOptions: {
			stroke: true,
			color: '#ED5D5C',
			weight: 4,
			opacity: 1,
			fill: false,
			clickable: true
		},
		metric: true, // Whether to use the metric measurement system or imperial
		feet: true, // When not metric, to use feet instead of yards for display.
		showLength: true, // Whether to display distance in the tooltip
		zIndexOffset: 2000 // This should be > than the highest z-index any map layers
	},
	_tips:[],
	_dummyTips:[],
	_contents : [],
	_lastContents : [],
	_polyArr:[],
	_lastAddVertextTime : 0,
	_finishtooltip: false,
	addVertex: function (latlng) {
		
		var clickTime  = new Date().getTime();
		if((clickTime - this._lastAddVertextTime) < 50)return;
		this._lastAddVertextTime = clickTime;
		var markersLength = this._markers.length;

		if (markersLength > 0 && !this.options.allowIntersection && this._poly.newLatLngIntersects(latlng)) {
			this._showErrorTooltip();
			return;
		}
		else if (this._errorShown) {
			this._hideErrorTooltip();
		}

		this._markers.push(this._createMarker(latlng));

		this._poly.addLatLng(latlng);

		if (this._poly.getLatLngs().length === 2) {
			this._map.addLayer(this._poly);
		}

		this._vertexChanged(latlng, true);
		
		var indx = this._markers.length - 2;
		indx = (indx < 0) ? 0 : indx;
		var previousLatLng = this._markers[indx].getLatLng();
		var vdistance = latlng.distanceTo(previousLatLng);
		var vdistancetxt = L.GeometryUtil.readableDistance(vdistance, this.options.metric, this.options.feet)
		
		var vtooltip = new L.vTooltip(this._map,latlng);
		vtooltip.updatePosition(latlng);
		vtooltip.refPolyId = this._poly._leaflet_id;

		vtooltip.updateContent(this._getTooltipText(), vdistancetxt);
		this._tips.push(vtooltip);
		
		// 첫번째 tooptip의 refPolyId 값을 부여
		if(this._tips.length > 2){
			for(var i = 0 ; i < this._tips.length; i++){
				if(this._tips[i].refPolyId === undefined){
					this._tips[i].refPolyId = this._poly._leaflet_id;
				}
			}
		}
		
		this._finishtooltip = false;
	
	},	
	_getTooltipText: function () {
		var showLength = this.options.showLength,
			labelText, distanceStr;
		if (this._markers.length === 0) {
			labelText = {
				text: L.drawLocal.draw.handlers.distance.tooltip.start
			};
		} else {
			distanceStr = showLength ? this._getMeasurementString() : '';

			if (this._markers.length === 1) {
				labelText = {
					text: L.drawLocal.draw.handlers.distance.tooltip.cont,
					subtext: distanceStr
				};
			} else {
				labelText = {
					text: L.drawLocal.draw.handlers.distance.tooltip.end,
					subtext: distanceStr
				};
			}
		}
		return labelText;
	},

	disable: function () {
		if(!this._finishtooltip){
			for(var i = 0;i<this._tips.length; i++){
				if(this._poly !== undefined && this._tips[i].refPolyId == this._poly._leaflet_id)
					this._tips[i].dispose();
			}	
		}
		
		if (!this._enabled) { return; }

		L.Handler.prototype.disable.call(this);

		this._map.fire('draw:drawstop', { layerType: this.type });

		this.fire('disabled', { handler: this.type });
	},
	_finishShape: function () {
		var intersects = this._poly.newLatLngIntersects(this._poly.getLatLngs()[this._poly.getLatLngs().length - 1]);

		if ((!this.options.allowIntersection && intersects) || !this._shapeIsValid()) {
			this._showErrorTooltip();
			return;
		}

		this._fireCreatedEvent();
		this.disable();
		if (this.options.repeatMode) {
			this.enable();
		}
	},
	_fireCreatedEvent: function () {
		var poly = new this.Poly(this._poly.getLatLngs(), this.options.shapeOptions);
		this._polyArr.push(poly);
		var latlng = this._poly.getLatLngs()[this._poly.getLatLngs().length - 1];
		
		var vtooltip = new L.vTooltip(this._map,latlng);
		vtooltip.updatePosition(latlng);
		var tip = vtooltip.finishContent("총거리", this._getTooltipText().subtext);
		this._tips.push(vtooltip);
		this._finishtooltip = true;
		
		var closer = getElementsByClassName(tip._container,"close");
		L.DomEvent.on(closer[0], 'click',function(e){
			this._removeMeasureItem(poly);
			vtooltip.dispose();
		}, this);
		L.Draw.Feature.prototype._fireCreatedEvent.call(this, poly);
		this._map.fire('measure:finished', { method: "distance",message: "finish!" });
	},
	_removeMeasureItem: function(poly){
		var lns = poly.getLatLngs();
		for(var i = 0 ;i< lns.length;i++){
			for(var j = 0;j< this._tips.length;j++){
				if(lns[i]==this._tips[j].latestlatlng){
					this._tips[j].dispose();
				}
			}
		}
		this._map.removeLayer(poly);
	},
	removeAllMeasureItem: function(){
		for(var i = 0 ;i<this._polyArr.length;i++){
			this._removeMeasureItem(this._polyArr[i]);
		}
	}
});

L.Polyline.correction = L.Draw.Polyline.extend({
	options: {
		allowIntersection: true,
		repeatMode: false,
		drawError: {
			color: '#b00b00',
			timeout: 2500
		},
		icon: new L.DivIcon({
			iconSize: new L.Point(8, 8),
			className: 'leaflet-div-icon leaflet-editing-icon'
		}),
		touchIcon: new L.DivIcon({
			iconSize: new L.Point(20, 20),
			className: 'leaflet-div-icon leaflet-editing-icon leaflet-touch-icon'
		}),
		guidelineDistance: 20,
		maxGuideLineLength: 4000,
		shapeOptions: {
			stroke: true,
			color: '#F98203',
			weight: 4,
			opacity: 0.5,
			fill: false,
			clickable: true
		},
		metric: true, // Whether to use the metric measurement system or imperial
		feet: true, // When not metric, to use feet instead of yards for display.
		showLength: true, // Whether to display distance in the tooltip
		zIndexOffset: 2000, // This should be > than the highest z-index any map layers
		corrTime: ""
	},
	_tips:[],
	_dummyTips:[],
	_contents : [],
	_lastContents : [],
	_polyArr:[],
	_lastAddVertextTime : 0,
	_finishtooltip: false,
	addVertex: function (latlng) {
		
		
		var clickTime  = new Date().getTime();
		if((clickTime - this._lastAddVertextTime) < 50)return;
		this._lastAddVertextTime = clickTime;
		var markersLength = this._markers.length;
		
		if (markersLength > 0 && !this.options.allowIntersection && this._poly.newLatLngIntersects(latlng)) {
			this._showErrorTooltip();
			return;
		}
		else if (this._errorShown) {
			this._hideErrorTooltip();
		}
		
		this._markers.push(this._createMarker(latlng));
		
		this._poly.addLatLng(latlng);
		
		if (this._poly.getLatLngs().length === 2) {
			this._map.addLayer(this._poly);
		}
		
		this._vertexChanged(latlng, true);
		
		
		var indx = this._markers.length - 2;
		indx = (indx < 0) ? 0 : indx;
		var previousLatLng = this._markers[indx].getLatLng();
		var vdistance = latlng.distanceTo(previousLatLng);
		var vdistancetxt = L.GeometryUtil.readableDistance(vdistance, this.options.metric, this.options.feet);
		
		var corrTime = this.options.corrTime;
		var disSecond = (vdistance / 7000) * 3600;
		corrTime.setSeconds(corrTime.getSeconds() + disSecond);
		var time = this.addZero(corrTime.getHours())+":"+this.addZero(corrTime.getMinutes())+":"+this.addZero(corrTime.getSeconds());
		
		
		var vtooltip = new L.vTooltip(this._map, latlng);
		vtooltip.updatePosition(vtooltip.latestlatlng);
		vtooltip.refPolyId = this._poly._leaflet_id;
		
		vtooltip.updateContent(this._getTooltipText(), time);
		this._tips.push(vtooltip);
		
		// 첫번째 tooptip의 refPolyId 값을 부여
		if(this._tips.length > 2){
			for(var i = 0 ; i < this._tips.length; i++){
				if(this._tips[i].refPolyId === undefined){
					this._tips[i].refPolyId = this._poly._leaflet_id;
				}
			}
		}
		
		this._finishtooltip = false;
		
	},
	addZero : function(num){
		return ((num < 10) ? '0' : '') + num
	},
	_getTooltipText: function () {
		var showLength = this.options.showLength,
		labelText, distanceStr;
		if (this._markers.length === 0) {
			labelText = {
					text: L.drawLocal.draw.handlers.polyline.tooltip.start
			};
		} else {
			distanceStr = showLength ? this._getMeasurementString() : '';
			
			if (this._markers.length === 1) {
				labelText = {
						text: L.drawLocal.draw.handlers.polyline.tooltip.cont,
						subtext: distanceStr
				};
			} else {
				labelText = {
						text: L.drawLocal.draw.handlers.polyline.tooltip.end,
						subtext: distanceStr
				};
			}
		}
		return labelText;
	},
	
	disable: function () {
		if(!this._finishtooltip){
			for(var i = 0;i<this._tips.length; i++){
				if(this._poly !== undefined && this._tips[i].refPolyId == this._poly._leaflet_id)
					this._tips[i].dispose();
			}	
		}
		
		if (!this._enabled) { return; }
		
		L.Handler.prototype.disable.call(this);
		
		this._map.fire('draw:drawstop', { layerType: this.type });
		
		this.fire('disabled', { handler: this.type });
	},
	_finishShape: function () {
		var intersects = this._poly.newLatLngIntersects(this._poly.getLatLngs()[this._poly.getLatLngs().length - 1]);
		
		if ((!this.options.allowIntersection && intersects) || !this._shapeIsValid()) {
			this._showErrorTooltip();
			return;
		}
		
		this._fireCreatedEvent();
		this.disable();
		if (this.options.repeatMode) {
			this.enable();
		}
	},
	_fireCreatedEvent: function () {
		var poly = new this.Poly(this._poly.getLatLngs(), this.options.shapeOptions);
		this._polyArr.push(poly);
		var latlng = this._poly.getLatLngs()[this._poly.getLatLngs().length - 1];
		
		var vtooltip = new L.vTooltip(this._map,latlng);
		vtooltip.updatePosition(latlng);
		var tip = vtooltip.finishContent("총거리", this._getTooltipText().subtext);
		this._tips.push(vtooltip);
		this._finishtooltip = true;
		
		var closer = getElementsByClassName(tip._container,"close");
		L.DomEvent.on(closer[0], 'click',function(e){
			this._removeMeasureItem(poly);
			vtooltip.dispose();
		}, this);
		
		L.Draw.Feature.prototype._fireCreatedEvent.call(this, poly);
		this._map.fire('measure:finished', { method: "distance",message: "finish!" });
		mvtDlvNewCreate();
		
	},
	_removeMeasureItem: function(poly){
		var lns = poly.getLatLngs();
		for(var i = 0 ;i< lns.length;i++){
			for(var j = 0;j< this._tips.length;j++){
				if(lns[i]==this._tips[j].latestlatlng){
					this._tips[j].dispose();
				}
			}
		}
		
		for(var j = 0;j< this._tips.length;j++){
			this._tips[j].dispose();
		}
		
		this._map.removeLayer(poly);
	},
	removeAllMeasureItem: function(){
		for(var i = 0 ;i<this._polyArr.length;i++){
			this._removeMeasureItem(this._polyArr[i]);
		}
	}
});