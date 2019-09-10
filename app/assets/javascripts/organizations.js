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
    "<h5 class='text-muted m-2' style='font-size: 0.75em;'>" + organization + "</h5>" +
    "<h6 class='text-muted m-2' style='font-size: 0.75em;'>" + location + "</h6>"
  $(element).html(content);
}

function addSector(value, label) {
  addElement("base-selected-sectors", "selected_sectors", value, label);
}

function addLocation(value, label) {
  addElement("base-selected-countries", "selected_countries", value, label);
}

function addContact(value, label) {
  addElement("base-selected-contacts", "selected_contacts", value, label);
}

var setupMapView = function() {
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

    var fontSize = parseInt($("body").css("font-size")) * 0.75;

    var baseBottom = -4 * fontSize;
    var headerHeight = parseInt($(element).find("h5").height());
    var lineOfHeader = Math.floor(headerHeight / fontSize)
    if (lineOfHeader >= 2) {
      $(element).css("bottom", baseBottom - lineOfHeader * fontSize);
    }

    var bodyHeight = parseInt($(element).find("h6").height());
    var lineOfBody = Math.floor(bodyHeight / fontSize);
    if (lineOfBody >= 2) {
      $(element).css("bottom", baseBottom - lineOfBody * fontSize);
    }
  });
}

var setupAutoComplete = function() {
  var productAutoComplete = autoComplete("/products.json?without_paging=true", addProduct)
  $('#base-selected-products').hide();
  $("#product-search").autocomplete(productAutoComplete);

  // Init the autocomplete for the sector field.
  var sectorAutoComplete = sectorCustomAutoComplete("/sectors.json?without_paging=true", addSector);
  $('#base-selected-sectors').hide();
  $("#sector-search").autocomplete(sectorAutoComplete)
                     .focus(function() {
                       $(this).data("uiAutocomplete").search($(this).val());
                      });

  // Init the autocomplete for the country field.
  var countryAutoComplete = autoComplete("/locations.json?without_paging=true", addLocation)
  $('#base-selected-countries').hide();
  $("#country-search").autocomplete(countryAutoComplete);

  // Init the autocomplete for the country field.
  var contactAutoComplete = autoComplete("/contacts.json?without_paging=true", addContact)
  $('#base-selected-contacts').hide();
  $("#contact-search").autocomplete(contactAutoComplete);

}

function sectorCustomAutoComplete(source, callback) {
  return {
    minLength: 0,
    maxShowItems: 8,
    source: function(request, response) {
      $.getJSON(
        source, {
          search: request.term
        },
        function(responses) {
          response($.map(responses, function(response) {
            return {
              id: response.id,
              label: response.name,
              value: response.name
            }
          }));
        }
      );
    },
    select: function(event, ui) {
      callback(ui.item.id, ui.item.label);
      $(this).blur();
      $(this).val("");
      return false;
    }
  }
}

function addOffice(label, officeId, magicKey) {
  var copy = $("#base-selected-offices").clone();

  $(copy).removeAttr("id");
  $(copy).find(".text-label").html(label);

  if (officeId) {
    var input = $(copy).find("input").first();
    $(input).attr("name",  "office_ids[" + officeId + "]");
    $(input).val(officeId);
  }

  if (magicKey) {
    var input = $(copy).find("input").last();
    $(input).attr("name",  "office_magickeys[" + magicKey + "]");
    $(input).val(magicKey);
  }
  
  $(copy).appendTo($("#base-selected-offices").parent());

  $(copy).show();
}

function sourceHandle(request, response) {
  $.getJSON(
    "/locations.json?office_only=true", {
      search: request.term
    },
    function(sectors) {
      if (sectors.length <= 0) {
        $.getJSON(
          esri_api, {
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
    }
  );
}

var setupFormView = function() {
  // Init the datepicker field.
  $('#organization_when_endorsed').datepicker();
  
  $('.custom-file-input').on('change', function () {
    var fileName = $(this).val().split('\\').pop();
    $(this).next('.custom-file-label').html(fileName);
  });

  $("#base-selected-offices").hide();
  $("#office-label").autocomplete({
    source: sourceHandle,
    select: function(event, ui) {
      addOffice(ui.item.label, ui.item.id, ui.item.magicKey)
      $(this).val("")
      return false;
    }
  });
};

$(document).on('organizations#new:loaded', setupFormView);
$(document).on('organizations#show:loaded', setupMapView);
$(document).on('organizations#edit:loaded', setupFormView);

$(document).on('organizations#new:loaded', setupAutoComplete);
$(document).on('organizations#edit:loaded', setupAutoComplete);
