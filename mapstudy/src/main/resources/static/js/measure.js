/**
 * 
 */
(function (factory, window) {
  // define an AMD module that relies on 'leaflet'
  if (typeof define === 'function' && define.amd) {
    define(['leaflet'], function (L) {
        factory(L, window.toGeoJSON);
    });

    // define a Common JS module that relies on 'leaflet'
  } else if (typeof exports === 'object') {
    module.exports = function (L) {
      if (L === undefined) {
        if (typeof window !== 'undefined') {
          L = require('leaflet');
        }
      }
      factory(L);
      return L;
    };
  } else if (typeof window !== 'undefined' && window.L) {
    factory(window.L);
  }
}(function (L) {
	L.Polyline.Measure = L.Draw.Polyline.extend({
	    addHooks: function () {
	        L.Draw.Polyline.prototype.addHooks.call(this);
	        if (this._map) {
	        	this._startShape();

	            L.DomEvent.on(this._container, 'keyup', this._cancelDrawing, this);
	        }
	    },

	    removeHooks: function () {
	    	
	    	L.Draw.Feature.prototype.removeHooks.call(this);

			this._clearHideErrorTimeout();

			this._cleanUpShape();

			this._mouseMarker
				.off('mousedown', this._onMouseDown, this)
				.off('mouseout', this._onMouseOut, this)
				.off('mouseup', this._onMouseUp, this)
				.off('mousemove', this._onMouseMove, this);
			this._map.removeLayer(this._mouseMarker);
			delete this._mouseMarker;

			// clean up DOM
			this._clearGuides();

			this._map
				.off('mouseup', this._onMouseUp, this)
				.off('mousemove', this._onMouseMove, this)
				.off('zoomlevelschange', this._onZoomEnd, this)
				.off('zoomend', this._onZoomEnd, this)
				.off('click', this._onTouch, this);

	        this._container.style.cursor = '';

	        this._removeShape();

	        this._map.off('click', this._onClick, this);

	        L.DomEvent.off(this._container, 'keyup', this._cancelDrawing, this);
	    },

	    _startShape: function () {
	        this._drawing = true;
	        this.options.shapeOptions.className = "lineMeasure";
	        this._poly = new L.Polyline([], this.options.shapeOptions);

	        this._container.style.cursor = 'crosshair';

	        this._updateTooltip();
	        this._map.on('mousemove', this._onMouseMove, this);
	    },

	    _finishShape: function () {
	        this._drawing = false;
	        
			if (this.type == "polyline")
	        {
		        //마지막 점은 총거리도 추가
		        var markersLength = this._markers.length;
		        if (markersLength > 1)
		        {
		        	var marker = this._markers[markersLength-1];
		            var txt = '총길이: ' + this._getTooltipText().subtext + '</br>' + '구간길이: ' + marker._tooltip._content;
		        	marker._tooltip.setContent(txt);
		        }
	        }
			
			if ((!this.options.allowIntersection) || !this._shapeIsValid()) {
				this._showErrorTooltip();
				return;
			}
			this._fireCreatedEvent();
			this.disable();
	    },

	    _removeShape: function () {
	        if (!this._poly)
	            return;
	        this._map.removeLayer(this._poly);

	        delete this._poly;
	        this._markers.splice(0);
	    },

		_onTouch: function (e) {
			// #TODO: use touchstart and touchend vs using click(touch start & end).
			/*if (L.Browser.touch) { // #TODO: get rid of this once leaflet fixes their click/touch.
				this._onMouseDown(e);
				this._onMouseUp(e);
			}*/
		},
		
		_onClick: function (e) {
	        if (!this._drawing) {
	            this._removeShape();
	            this._startShape();
	            return;
	        }
	    },

	    _getTooltipText: function () {
	        var labelText = L.Draw.Polyline.prototype._getTooltipText.call(this);
	        if (!this._drawing) {
	            labelText.text = '';
	        }
	        return labelText;
	    },

	    _cancelDrawing: function (e) {
	        if (e.keyCode === 27) {
	            disableMeasureBtn();
	        }
	    },
	    
	    clearLayers: function (e) {
	    	if (this._markerGroup)
	    	{
	    		if (this._markerGroup._layers)
		    	{
		    		for (var i in this._markerGroup._layers) {
		    			if (this._markerGroup._layers[i]._tooltip)
		    				this._map.removeLayer(this._markerGroup._layers[i]._tooltip);
		    		}
		    		
		    		this._markerGroup.clearLayers();
		    		this._map.removeLayer(this._markerGroup);
		    		delete this._markerGroup;
		    	}
	    	}
	    }
	});

	L.Control.MeasureControl = L.Control.extend({

	    statics: {
	        TITLE: 'Measure Distance'
	    },
	    options: {
	        position: 'topleft',
	        handler: {}
	    },

	    toggle: function () {
	        if (this.handler.enabled()) {
	            this.handler.disable.call(this.handler);
	        } else {
	            this.handler.enable.call(this.handler);
	        }
	    },

	    onAdd: function (map) {
	        var className = 'leaflet-control-draw';

	        var elList = document.getElementsByClassName('leaflet-bar');
	        if (elList.length < 1)
	            this._container = L.DomUtil.create('div', 'leaflet-bar');
	        else
	            this._container = elList[0];

	        this.handler = new L.Polyline.Measure(map, this.options.handler);

	        this.handler.on('enabled', function () {
	            L.DomUtil.addClass(this._container, 'enabled');
	        }, this);

	        this.handler.on('disabled', function () {
	            L.DomUtil.removeClass(this._container, 'enabled');
	        }, this);

	        var link = L.DomUtil.create('a', className + '-measure', this._container);
	        link.href = '#';
	        link.title = L.Control.MeasureControl.TITLE;

	        L.DomEvent
	            .addListener(link, 'click', L.DomEvent.stopPropagation)
	            .addListener(link, 'click', L.DomEvent.preventDefault)
	            .addListener(link, 'click', this.toggle, this);

	        return this._container;
	    }
	});
 
  L.Map.mergeOptions({
    measureControl: false
  });

  L.Map.addInitHook(function () {
    if (this.options.measureControl) {
      this.measureControl = L.Control.measureControl().addTo(this);
    }
  });

  L.Control.measureControl = function (options) {
    return new L.Control.MeasureControl(options);
  };

}, window));
