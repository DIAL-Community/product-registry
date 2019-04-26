/*
 * Global variables
 */
var map;
var tooltip;
var feature;
var markerCoordinate;

feature = new ol.Feature({
  name: "Organization Marker"
})

var markerLayer = new ol.layer.Vector({
  source: new ol.source.Vector({
    features: [feature]
  }),
  style: new ol.style.Style({
    image: new ol.style.Icon({
      anchor: [11, 29],
      anchorXUnits: 'pixels',
      anchorYUnits: 'pixels',
      opacity: 1,
      src: '/assets/marker.png'
    })
  }),
});

/*
 * Prepare the office marker on the map and center the map on the office location.
 */
function setOfficeMarker(organization, location, lon, lat) {
  if (typeof map === "undefined" || typeof map.getView() === "undefined" || typeof tooltip === "undefined") {
    setTimeout(function() {
      setOfficeMarker(organization, location, lon, lat);
    }, 500);
    return;
  }

  console.log("Setting up the office marker ...");

  // Project the lon lat to the map.
  markerCoordinate = ol.proj.transform([parseFloat(lon), parseFloat(lat)], 'EPSG:4326', 'EPSG:3857');

  // Center the map to the coordinate
  map.getView().setCenter(markerCoordinate);

  // Set the feature geometry.
  feature.setGeometry(new ol.geom.Point(markerCoordinate));

  // Set the tooltip structure and location.
  tooltip.setPosition(undefined);
  var element = tooltip.getElement();
  var content =
    "<h5 class='text-muted'>" + organization + "</h5>" +
    "<h6 class='text-muted'>" + location + "</h6>"
  $(element).html(content);
}

function addSector(value, label) {
  addElement("base-selected-sectors", "selected_sectors", value, label);
}

function addLocation(value, label) {
  addElement("base-selected-countries", "selected_countries", value, label);
}

var setupMapView = function() {  // Clean the map holder.
  // Might need to find another way to prevent duplicate maps.
  console.log("Setting map view ...");

  tooltip = new ol.Overlay({
    element: document.getElementById('office-popup')
  });
  map = new ol.Map({
    target: "office",
    layers: [
      new ol.layer.Tile({
        source: new ol.source.OSM()
      }),
      markerLayer
    ],
    overlays: [tooltip],
    view: new ol.View({
      center: markerCoordinate ? markerCoordinate : [0, 0],
      zoom: 10
    })
  });

  // Display tooltip when the user click on the office marker.
  map.on("click", function(e) {
    var feature = map.forEachFeatureAtPixel(e.pixel, function(feature, layer) {
      if (layer === markerLayer && tooltip) {
        return feature;
      }
    });

    coordinate = feature ? markerCoordinate : undefined;
    tooltip.setPosition(coordinate);

    var element = tooltip.getElement();

    var fontSize = parseInt($("body").css("font-size"));

    var headerHeight = parseInt($(element).find("h5").height());
    var lineOfHeader = headerHeight / 24
    if (lineOfHeader > 1) {
      var baseBottom = parseInt($(element).css("bottom"));
      $(element).css("bottom", baseBottom - lineOfHeader * fontSize);
    }

    var bodyHeight = parseInt($(element).find("h6").height());
    var lineOfBody = bodyHeight / 19;
    if (lineOfBody > 1) {
      var baseBottom = parseInt($(element).css("bottom"));
      $(element).css("bottom", baseBottom - (lineOfBody + 0.5) * fontSize);
    }
  });
}

var setupFormView = function() {
  // Init the datepicker field.
  $('#organization_when_endorsed').datepicker();

  // Init the autocomplete for the sector field.
  var sectorAutoComplete = autoComplete("/sectors.json?without_paging=true", addSector);
  $('#base-selected-sectors').hide();
  $("#sector-search").autocomplete(sectorAutoComplete);

  // Init the autocomplete for the country field.
  var countryAutoComplete = autoComplete("/locations.json?without_paging=true", addLocation)
  $('#base-selected-countries').hide();
  $("#country-search").autocomplete(countryAutoComplete);

  $("#office-label").autocomplete({
    source: function(request, response) {
      $.getJSON(
        "/locations.json?office_only=true", {
          search: request.term
        },
        function(sectors) {
          if (sectors.length <= 0) {
            $.getJSON(
              "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/suggest", {
                f: 'json',
                category: 'City',
                maxSuggestions: 10,
                text: request.term
              },
              function(data) {
                response($.map(data.suggestions, function(city) {
                  return {
                    id: null,
                    label: city.text,
                    value: city.text,
                    magicKey: city.magicKey
                  }
                }));
              });
          }
          response($.map(sectors, function(sector) {
            return {
              id: sector.id,
              label: sector.name,
              value: sector.name,
              magicKey: null
            }
          }));
        });
    },
    select: function(event, ui) {
      $("#office-id").val(ui.item.id);
      $("#office-magickey").val(ui.item.magicKey);
    }
  });
};

$(document).on('organizations#new:loaded', setupFormView);
$(document).on('organizations#show:loaded', setupMapView);
$(document).on('organizations#edit:loaded', setupFormView);
