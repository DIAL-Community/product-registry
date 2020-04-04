var mapOfProject = {

  map : {},
  projects: {},
  locations: {},
  projectsByCountry: {},

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
      mapOfProject.countryHighlightStyle.getText().setText(feature.get('name'));
      return mapOfProject.countryHighlightStyle;
    }
  }),

  countryLayer: new ol.layer.Vector({
    source: new ol.source.Vector({
      url: '/assets/map/countries.json',
      format: new ol.format.GeoJSON()
    }),
    style: function(feature) {
      mapOfProject.countryStyle.getText().setText(feature.get('name'));
      return mapOfProject.countryStyle;
    }
  }),

  initMap: function() {
    mapOfProject.popup = new ol.Overlay({
      element: document.getElementById('popup')
    });

    mapOfProject.map = new ol.Map({
      target: 'map-of-project',
      layers: [
        mapOfProject.countryLayer,
        mapOfProject.countryHightlightLayer
      ],
      overlays: [mapOfProject.popup],
      view: new ol.View({
        center: ol.proj.fromLonLat([10, 20.3]),
        zoom: 2,
        maxZoom: 10,
        minZoom: 2
      })
    });

    mapOfProject.map.on('click', mapOfProjectClickHandler);
  },

  initLocations: function() {
    $.getJSON('/locations.json?without_paging=true', function(locations) {
      locations.forEach(function(location) {
        mapOfProject.locations[location.id] = location;
      });
    });
  },

  initProjects: function() {
    $.getJSON('/projects.json', function(projects) {
      projects
        .forEach(function(project) {
          const normalized = {
            id: project.id,
            name: project.name,
            slug: project.slug,
            organizations: project.organizations,
            countries: project.locations
          }

          const option = new Option(project.name, project.id);
          $(option).html(project.name);
          $('#project-selector').append(option);

          mapOfProject.projects[normalized.id] = normalized;
          project.locations.forEach(function(location) {
            const countries = mapOfProject.projectsByCountry[location.name] || []
            countries.push(normalized.id);
            mapOfProject.projectsByCountry[location.name] = countries;
          });
        });
      
      // Hightlight our initial country list.
      highlightProjectCountries(Object.keys(mapOfProject.projectsByCountry));
    });
  },

  init: function() {
    $("#map-of-project").empty();
    mapOfProject.initMap();
    mapOfProject.initLocations();
    mapOfProject.initProjects();
  },
};

function highlightProjectCountries(countries) {
  countries.forEach(function(country) {
    mapOfProject.countryLayer.getSource().forEachFeature(function(projectFeature) {
      if (country == projectFeature.get('name')) {
        mapOfProject.countryHightlightLayer.getSource().addFeature(new ol.Feature({
          name: projectFeature.get("name"),
          coordinate: projectFeature.get("coordinate"),
          geometry: projectFeature.get("geometry"),
          projects: mapOfProject.projectsByCountry[country]
        }));
      }
    });
  });
}

function mapOfProjectClickHandler(evt) {
  var projectFeature = mapOfProject.map.forEachFeatureAtPixel(
    evt.pixel,
    function(ft, layer) {
      if (layer == mapOfProject.countryHightlightLayer) {
        return ft;
      }
    }
  );
  if (projectFeature) {
    const element = mapOfProject.popup.element;
    const projectIds = projectFeature.get("projects");
    if (projectIds.length == 1) {
      const project = mapOfProject.projects[projectIds[0]];
      const content =
        `<div class="card map-popup" style="bottom: -6.5rem; padding: 0">
          <h6 class="card-header py-2 px-2">${project.name}</h6>
          <p class="py-2 px-2 mb-0">
            <a href="/projects/${project.slug}"><small>View project</small></a> <br />
          </p>
        </div>`;
      $(element).html(content);
    } else {
      const contentDiv = $('<div class="card map-popup" style="overflow: hidden; max-height: 20rem; bottom: -7rem; padding: 0"/>');
      
      const contentHeader = $('<h6 class="card-header py-2 px-2">' + projectIds.length + ' Projects</h6>');
      contentDiv.append(contentHeader);

      const projectElements = $('<div class="list-group" style="overflow-y: auto;" />');
      contentDiv.append(projectElements);
      
      projectIds.forEach(function (aggregatorId) {
        const project = mapOfProject.projects[aggregatorId];
        const orgInfo = $('<div class="list-group-item list-group-item-action py-2 px-2" />');
        
        orgInfo.click(function() {
          $(this).parents(".list-group").find('.org-details').hide();
          $(this).find('.org-details').show();
        });

        orgInfo.append(`<strong>${project.name}</strong>`);
        orgInfo.append(`<p class="org-details mb-0" style="display:none">
                          <small>
                            <a href="/projects/${project.slug}">View project</a> <br />
                          </small>
                        </p>`)
        projectElements.append(orgInfo);
      });
      $(element).empty();
      $(element).append(contentDiv);
    }

    mapOfProject.popup.setPosition(evt.coordinate);
  } else {
    mapOfProject.popup.setPosition(undefined);
  }
};

mapOfProject.init();