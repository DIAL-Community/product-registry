var mapObject = {

  countryHightlightLayer : new ol.layer.Vector({
    source: new ol.source.Vector(),
    map: this.map,
    style: function(feature) { var toRet = new ol.style.Style({
      stroke: new ol.style.Stroke({
        color: '#ff9d2d',
        width: 2
      }),
      fill: new ol.style.Fill({
        color: 'rgba(256,157,45,0.5)',
      }),
      text: new ol.style.Text({
        font: '12px Calibri,sans-serif',
        fill: new ol.style.Fill({
          color: '#fff'
        }),
        stroke: new ol.style.Stroke({
          color: '#000',
          width: 3
        })
      }),
    });
    toRet.getText().setText(feature.get('name'));
    return toRet;}
  }),

  countryLayer : new ol.layer.Vector({
    source: new ol.source.Vector({
      url: 'assets/countries.geojson',
      format: new ol.format.GeoJSON()
    }),
    style: function(feature) {
      mapObject.countryStyle.getText().setText(feature.get('name'));
      return mapObject.countryStyle;
    }
  }),

  markerLayer : new ol.layer.Vector({
    source: new ol.source.Vector(),
    style: new ol.style.Style({
      image: new ol.style.Icon({
        anchor: [11, 29],
        anchorXUnits: 'pixels',
        anchorYUnits: 'pixels',
        opacity: 1,
        src: '/assets/marker.png'
      })
    }),
  }),

  markerHoldingLayer : new ol.layer.Vector({
    source: new ol.source.Vector(),
    style: new ol.style.Style({
      image: new ol.style.Icon({
        anchor: [11, 29],
        anchorXUnits: 'pixels',
        anchorYUnits: 'pixels',
        opacity: 1,
        src: '/assets/marker.png'
      })
    }),
  }),

  map : {},

  initMap : function() {

    mapObject.YearSelectorControl.prototype = Object.create(ol.control.Control.prototype);
    mapObject.YearSelectorControl.prototype.constructor = mapObject.YearSelectorControl;

    mapObject.YearSelectorControl.prototype.handleYearSelection = mapObject.handleYearSelection;

    mapObject.map = new ol.Map({
      controls: ol.control.defaults().extend([
        new mapObject.YearSelectorControl(this.yearSelector)
      ]),
      target: 'map',
      layers: [
        /*new ol.layer.Tile({
          source: new ol.source.OSM()
        }),*/
        mapObject.countryLayer,
        mapObject.countryHightlightLayer,
        mapObject.markerLayer
      ],
      view: new ol.View({
        center: ol.proj.fromLonLat([10, 20.3]),
        zoom: 2.5,
      })
    });
    $.getJSON('/organizations.json?without_paging=true', function(organizations) {
      organizations.forEach(function(o) {
        o.offices.forEach(function(of) {
          var iconFeature = new ol.Feature({
            geometry: new ol.geom.Point(ol.proj.transform([of.lon, of.lat],'EPSG:4326','EPSG:3857')),
            name: o.name,
            website: o.website,
            when_endorsed: o.when_endorsed.substr(0,4),
            countries: o.countries
          });
          mapObject.markerLayer.getSource().addFeature(iconFeature);
        });
      });
    });
    mapObject.map.addOverlay(mapObject.popup);
    mapObject.map.on('click', mapObject.clickHandler);
  },

  popup : new ol.Overlay({
    element: document.getElementById('popup')
  }),

};
