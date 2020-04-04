var mapObject = {
  countryHighlightStyle: new ol.style.Style({
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
    })
  }),

  countryStyle: new ol.style.Style({
    fill: new ol.style.Fill({
      color: 'rgba(45,115,199, 0.5)',
    }),
    stroke: new ol.style.Stroke({
      color:   'rgba(45,115,199, 1.0)',
      width: 2
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
    })
  }),

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
      url: '/assets/map/countries.json',
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
        src: '/assets/map/marker.png'
      })
    }),
  }),

  sectorMarkerHoldingLayer: new ol.layer.Vector({
    source: new ol.source.Vector(),
    style: new ol.style.Style({
      image: new ol.style.Icon({
        anchor: [11, 29],
        anchorXUnits: 'pixels',
        anchorYUnits: 'pixels',
        opacity: 1,
        src: '/assets/map/marker.png'
      })
    }),
  }),

  markerHoldingLayer: new ol.layer.Vector({
    source: new ol.source.Vector(),
    style: new ol.style.Style({
      image: new ol.style.Icon({
        anchor: [11, 29],
        anchorXUnits: 'pixels',
        anchorYUnits: 'pixels',
        opacity: 1,
        src: '/assets/map/marker.png'
      })
    }),
  }),

  map : {},

  initMap : function() {
    $("#map").empty();

    mapObject.popup = new ol.Overlay({
      element: document.getElementById('popup')
    });

    mapObject.map = new ol.Map({
      target: 'map',
      layers: [
        mapObject.countryLayer,
        mapObject.countryHightlightLayer,
        mapObject.markerLayer
      ],
      overlays: [mapObject.popup],
      view: new ol.View({
        center: ol.proj.fromLonLat([10, 20.3]),
        zoom: 2,
        maxZoom: 10,
        minZoom: 2
      })
    });

    $.getJSON('/organizations.json?without_paging=true', function(organizations) {
      var coordinatesToOrgs = {};
      organizations.forEach(function(o) {
        var officeObj = {
          id: o.id,
          name: o.name,
          slug: o.slug,
          website: o.website,
          when_endorsed: o.when_endorsed ? o.when_endorsed.substr(0,4) : "0000",
          countries: o.countries,
          sectors: o.sectors
        }
        o.offices.forEach(function(of) {
          var coordKey = "" + [of.lat] + "," + of.lon;
          var coord = ol.proj.transform([of.lon, of.lat],'EPSG:4326','EPSG:3857');
          if (!(coordKey in coordinatesToOrgs)) {
            coordinatesToOrgs[coordKey] = { coordinate: coord, orgs: [] };
          }
          coordinatesToOrgs[coordKey].orgs.push(officeObj)
        });
      });
      $.each(coordinatesToOrgs, function(coordKey, orgs) {
        var coord = coordinatesToOrgs[coordKey].coordinate;
        var orgs = coordinatesToOrgs[coordKey].orgs;
        mapObject.markerLayer.getSource().addFeature(new ol.Feature({
          coordinate: coord,
          geometry: new ol.geom.Point(coord),
          organizations: orgs
        }));
      });
    });
    mapObject.map.on('click', mapObject.clickHandler);
  },

  showCountries: function(countries) {
    countries.forEach(function(cLabel) {
      mapObject.countryLayer.getSource().forEachFeature(function(cFeature) {
        if (cLabel == cFeature.get('name')) {
          mapObject.countryHightlightLayer.getSource().addFeature(cFeature);
        }
      });
    });
    mapObject.countryHightlightLayer.getSource().forEachFeature(function (feature) {
      mapObject.countryLayer.getSource().removeFeature(feature);
    });
  },

  hideCountries: function() {
    mapObject.countryHightlightLayer.getSource().forEachFeature(function (feature) {
      mapObject.countryLayer.getSource().addFeature(feature);
    });
    mapObject.countryHightlightLayer.getSource().clear();
  },

};

mapObject.clickHandler = function(evt) {
  var feature = mapObject.map.forEachFeatureAtPixel(
    evt.pixel,
    function(ft, layer) {
      if (layer == mapObject.markerLayer) {
        return ft;
      }
    }
  );
  if (feature) {
    mapObject.countryHightlightLayer.getSource().forEachFeature(function (feature) {
      mapObject.countryLayer.getSource().addFeature(feature);
    });
    mapObject.countryHightlightLayer.getSource().clear();
    var element = mapObject.popup.element;
    if (feature.get("organizations").length == 1) {
      org = feature.get("organizations")[0];
      var content =
      `<div class="card map-popup" style="bottom: -6.5rem; padding: 0">
        <h6 class="card-header py-2 px-2">${org.name}</h6>
        <p class="small py-2 px-2 mb-0">
          <a href="//${org.website}" target="_blank" rel="noreferrer noopener">${org.website}</a> <br />
          Endorser since ${org.when_endorsed} <br />
          <a href="/organizations/${org.slug}" target="_blank" rel="noreferrer noopener"><small>View organization</small></a> <br />
        </p>
      </div>`;
      mapObject.showCountries(org.countries);
      $(element).html(content);
    } else {
      orgs = feature.get("organizations");
      var contentDiv = $('<div class="card map-popup" style="overflow: hidden; max-height: 20rem; bottom: -7rem; padding: 0"/>');
      var contentHeader = $('<h6 class="card-header py-2 px-2">' + orgs.length + ' Organizations</h6>');
      contentDiv.append(contentHeader);
      var orgElements = $('<div class="list-group" style="overflow-y: auto;" />');
      contentDiv.append(orgElements);
      orgs.forEach(function (org) {
        var orgInfo = $('<div class="list-group-item list-group-item-action py-2 px-2" />');
        orgInfo.click(function() {
          $(this).parents(".list-group").find('.org-details').hide();
          $(this).find('.org-details').show();
          mapObject.hideCountries();
          mapObject.showCountries(org.countries);
        });
        orgInfo.append(`<strong>${org.name}</strong>`);
        orgInfo.append(`<p class="org-details mb-0" style="display:none">
                        <small>
                          <a href="//${org.website}" target="_blank" rel="noreferrer noopener">${org.website}</a> <br />
                          Endorser since ${org.when_endorsed}. <br />
                          <a href="/organizations/${org.slug}" target="_blank" rel="noreferrer noopener">View organization</a> <br />
                        </small>
                      </p>`)
        orgElements.append(orgInfo);
      });
      $(element).empty();
      $(element).append(contentDiv);
    }

    mapObject.popup.setPosition(evt.coordinate);
  } else {
    mapObject.popup.setPosition(undefined);
    mapObject.hideCountries();
  }
};

var updateToHdCheck;
function updateToHd() {
  console.log("Checking to see if we can update map to HD!")
  if (mapObject.countryLayer) {
    console.log("Updating map to HD!");
    var hdSource = new ol.source.Vector({
      url: '/assets/map/countries-hd.json',
      format: new ol.format.GeoJSON()
    });
    mapObject.countryLayer.setSource(hdSource);
    clearTimeout(updateToHdCheck);
  }
}

// TODO: Enable this to allow switching to better looking map.
// We should also look into this to serve the high-def map:
// https://github.com/mapbox/geojson-vt
// https://openlayers.org/en/latest/examples/geojson-vt.html
// updateToHdCheck = setTimeout(updateToHd, 20000)
