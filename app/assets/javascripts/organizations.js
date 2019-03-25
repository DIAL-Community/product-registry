/*
 * Global variables
 */
var map;
var markerCoordinate;

var markerLayer = new ol.layer.Vector({
  source: new ol.source.Vector(),
  style: new ol.style.Style({
    image: new ol.style.Icon({
      anchor: [11, 29],
      anchorXUnits: 'pixels',
      anchorYUnits: 'pixels',
      opacity: 1,
      src: '/assets/marker.png'
    })
  })
});

var countryLayer = new ol.layer.Vector({
  source: new ol.source.Vector({
    url: '/assets/countries.geojson',
    format: new ol.format.GeoJSON()
  }),
  style: function(feature) {
    return new ol.style.Style({
      fill: new ol.style.Fill({
        color: 'rgba(45,115,199, 0.5)',
      }),
      stroke: new ol.style.Stroke({
        color: 'rgba(45,115,199, 1.0)',
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
        }),
        text: feature.get('name')
      })
    });
  }
});

function setMapCenter(lon, lat) {
  if (typeof map === "undefined" || typeof map.getView() === "undefined") {
    setTimeout(function() {
      setMapCenter(lon, lat);
    }, 500);
    return;
  }

  markerCoordinate = ol.proj.transform([parseFloat(lon), parseFloat(lat)], 'EPSG:4326', 'EPSG:3857');
  map.getView().setCenter(markerCoordinate);
}

function setMarker(name, lon, lat) {
  if (typeof map !== "undefined") {
    markerCoordinate = ol.proj.transform([parseFloat(lon), parseFloat(lat)], 'EPSG:4326', 'EPSG:3857');
    var iconFeature = new ol.Feature({
      geometry: new ol.geom.Point(markerCoordinate)
    });
    markerLayer.getSource().addFeature(iconFeature);
  } else {
    setTimeout(function() {
      setMarker(name, lon, lat);
    }, 500);
  }
}

/*
 * The function to remove grandparent element from the DOM. This will be called
 * when the user click on the delete button on the tag like object. In the future
 * this will be called on sectors, locations, and contacts.
 */
function remove(self) {
  var baseCard = $(self).parent().parent();
  $(baseCard).remove();
}

/*
 * Create a new sector section and assign the value of the sector to the hidden
 * input field. The hidden input field will be used to define the child objects.
 */
function addSector(value, label) {

  // Find the hidden based element and clone it.
  var copy = $("#base-selected-sectors").clone();

  // Remove the id so it won't have the same id with the hidden element.
  $(copy).removeAttr("id");

  // Display the value of the selection.
  $(copy).find("p").html(label);

  // Find the hidden input element and assign some values to it.
  // Make sure:
  // * The name for each hidden input will be different (or it won't work).
  var input = $(copy).find("input");
  $(input).attr("name", "selected_sector[" + value + "]");
  $(input).val(value);

  // Attach the copy to the parent of the hidden element.
  $(copy).appendTo($("#base-selected-sectors").parent());

  // Toggle the show to show it to the user. Yay!
  $(copy).show();
}

var ready = function() {
  // Init the datepicker field.
  $('#organization_when_endorsed').datepicker();

  // Hide the base sectors tag element.
  $('#base-selected-sectors').hide();

  // Init the autocomplete for the sector field.
  $("#sector-search").autocomplete({
    source: function(request, response) {
      $.getJSON(
        "/sectors.json?without_paging=true", {
          search: request.term
        },
        function(sectors) {
          response($.map(sectors, function(sector) {
            return {
              id: sector.id,
              label: sector.name,
              value: sector.name
            }
          }));
        }
      );
    },
    select: function(event, ui) {
      addSector(ui.item.id, ui.item.label)
      $(this).val("")
      return false;
    }
  });

  // Clean the map holder.
  // Might need to find another way to prevent duplicate maps.
  $("#office").empty();
  console.log("Setting office map ...");
  map = new ol.Map({
    target: "office",
    layers: [
      new ol.layer.Tile({
        source: new ol.source.OSM()
      }),
      markerLayer
    ],
    view: new ol.View({
      center: markerCoordinate ? markerCoordinate : [0, 0],
      zoom: 12
    })
  });
};


// Attach all of them to the browser, page, and turbolinks event.
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('turbolinks:load', ready)
