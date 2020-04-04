var aggregator = {

  map : {},
  aggregators: {},
  locations: {},
  operators: {},
  services: {},
  aggregatorsByCountry: {},

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
    }),
  }),

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
    }),
  }),

  countryHightlightLayer: new ol.layer.Vector({
    source: new ol.source.Vector(),
    map: this.map,
    style: function(feature) {
      aggregator.countryHighlightStyle.getText().setText(feature.get('name'));
      return aggregator.countryHighlightStyle;
    }
  }),

  countryLayer: new ol.layer.Vector({
    source: new ol.source.Vector({
      url: '/assets/map/countries.json',
      format: new ol.format.GeoJSON()
    }),
    style: function(feature) {
      aggregator.countryStyle.getText().setText(feature.get('name'));
      return aggregator.countryStyle;
    }
  }),

  initMap: function() {
    aggregator.popup = new ol.Overlay({
      element: document.getElementById('popup')
    });

    aggregator.map = new ol.Map({
      target: 'map',
      layers: [
        aggregator.countryLayer,
        aggregator.countryHightlightLayer
      ],
      overlays: [aggregator.popup],
      view: new ol.View({
        center: ol.proj.fromLonLat([10, 20.3]),
        zoom: 2,
        maxZoom: 10,
        minZoom: 2
      })
    });

    aggregator.map.on('click', aggregatorClickHandler);
  },

  initOperators: function() {
    $.getJSON('/operator_services.json?without_paging=true', function(data) {
      aggregator.operators = data.operators;
      for(operatorName in aggregator.operators) {
        const option = new Option(operatorName, operatorName);
        $(option).html(operatorName);
        $('#operators').append(option);
      };
    });
  },

  initLocations: function() {
    $.getJSON('/locations.json?without_paging=true', function(locations) {
      locations.forEach(function(location) {
        aggregator.locations[location.id] = location;
      });
    });
  },

  initAggregators: function() {
    $.getJSON('/organizations.json?without_paging=true&mni_only=true', function(organizations) {
      organizations
        .filter(function(organization) { return organization.is_mni; })
        .forEach(function(organization) {
          const normalized = {
            id: organization.id,
            name: organization.name,
            capabilities: organization.capabilities,
            operators: []
          }

          organization.capabilities.forEach(function(capability) {
            // create the object to be used to generate the select box.
            aggregator.services[capability.service] = capability.service;
            // create convenient list of operators for the aggregator.
            if (normalized.operators.indexOf(capability.operator) === -1) {
              normalized.operators.push(capability.operator)
            }
          });

          aggregator.aggregators[normalized.id] = normalized;
          organization.countries.forEach(function(country_name) {
            const countries = aggregator.aggregatorsByCountry[country_name] || []
            countries.push(normalized.id);
            aggregator.aggregatorsByCountry[country_name] = countries;
          });
        });
      
      // Hightlight our initial country list.
      highlightCountries(Object.keys(aggregator.aggregatorsByCountry));

      Object.keys(aggregator.aggregators).sort().forEach(function(aggregator_id) {
        const organization = aggregator.aggregators[aggregator_id];
        const option = new Option(organization.name, organization.id);
        $(option).html(organization.name);
        $('#aggregators').append(option);
      });

      // Prepare the service filter.
      Object.keys(aggregator.services).sort().forEach(function(service) {
        const option = new Option(service, service);
        $(option).html(service);
        $('#services').append(option);
      });
    });
  },

  init: function() {
    $("#map").empty();
    aggregator.initMap();
    aggregator.initOperators();
    aggregator.initLocations();
    aggregator.initAggregators();
  },
};

function highlightCountries(countries) {
  countries.forEach(function(country) {
    aggregator.countryLayer.getSource().forEachFeature(function(feature) {
      if (country == feature.get('name')) {
        aggregator.countryHightlightLayer.getSource().addFeature(new ol.Feature({
          name: feature.get("name"),
          coordinate: feature.get("coordinate"),
          geometry: feature.get("geometry"),
          aggregators: aggregator.aggregatorsByCountry[country]
        }));
      }
    });
  });
}

function aggregatorClickHandler(evt) {
  var feature = aggregator.map.forEachFeatureAtPixel(
    evt.pixel,
    function(ft, layer) {
      if (layer == aggregator.countryHightlightLayer) {
        return ft;
      }
    }
  );
  if (feature) {
    const element = aggregator.popup.element;
    const aggregatorIds = feature.get("aggregators");
    if (aggregatorIds.length == 1) {
      const organization = aggregator.aggregators[aggregatorIds[0]];
      const content =
        `<div class="card map-popup" style="bottom: -6.5rem; padding: 0">
          <h6 class="card-header py-2 px-2">${organization.name}</h6>
          <p class="py-2 px-2 mb-0">
            <a href="/organizations/${organization.name.toLowerCase()}"><small>View aggregator</small></a> <br />
          </p>
        </div>`;
      $(element).html(content);
    } else {
      const contentDiv = $('<div class="card map-popup" style="overflow: hidden; max-height: 20rem; bottom: -7rem; padding: 0"/>');
      
      const contentHeader = $('<h6 class="card-header py-2 px-2">' + aggregatorIds.length + ' Aggregators</h6>');
      contentDiv.append(contentHeader);

      const organizationElements = $('<div class="list-group" style="overflow-y: auto;" />');
      contentDiv.append(organizationElements);
      
      aggregatorIds.forEach(function (aggregatorId) {
        const organization = aggregator.aggregators[aggregatorId];
        const orgInfo = $('<div class="list-group-item list-group-item-action py-2 px-2" />');
        
        orgInfo.click(function() {
          $(this).parents(".list-group").find('.org-details').hide();
          $(this).find('.org-details').show();
        });

        orgInfo.append(`<strong>${organization.name}</strong>`);
        orgInfo.append(`<p class="org-details mb-0" style="display:none">
                          <small>
                            <a href="/organizations/${organization.name.replace(/ /g,'_').toLowerCase()}">View organization</a> <br />
                          </small>
                        </p>`)
        organizationElements.append(orgInfo);
      });
      $(element).empty();
      $(element).append(contentDiv);
    }

    aggregator.popup.setPosition(evt.coordinate);
  } else {
    aggregator.popup.setPosition(undefined);
  }
};

aggregator.init()
