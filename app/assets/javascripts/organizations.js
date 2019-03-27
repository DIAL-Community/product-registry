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
  tooltip.setPosition(markerCoordinate);
  var element = tooltip.getElement();
  $(element).popover('dispose');
  $(element).popover({
    placement: 'bottom',
    animation: false,
    html: true,
    content: "<h5 class='text-muted'>" + organization + "</h5>" +
      "<h6 class='text-muted'>" + location + "</h6>"
  });
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

function addSector(value, label) {
  addElement("base-selected-sectors", "selected_sectors", value, label);
}

function addLocation(value, label) {
  addElement("base-selected-countries", "selected_countries", value, label);
}

// Create autocomplete configuration for searches.
function autoComplete(source, callback) {
  return {
    source: function(request, response) {
      $.getJSON(
        source, {
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
      callback(ui.item.id, ui.item.label)
      $(this).val("")
      return false;
    }
  }
}

/*
 * Create a new sector section and assign the value of the sector to the hidden
 * input field. The hidden input field will be used to define the child objects.
 */
function addElement(baseElementId, inputElementName, value, label) {

  // Find the hidden based element and clone it.
  var copy = $("#" + baseElementId).clone();

  // Remove the id so it won't have the same id with the hidden element.
  $(copy).removeAttr("id");

  // Display the value of the selection.
  $(copy).find("p").html(label);

  // Find the hidden input element and assign some values to it.
  // Make sure:
  // * The name for each hidden input will be different (or it won't work).
  var input = $(copy).find("input");
  $(input).attr("name",  inputElementName + "[" + value + "]");
  $(input).val(value);

  // Attach the copy to the parent of the hidden element.
  $(copy).appendTo($("#" + baseElementId).parent());

  // Toggle the show to show it to the user. Yay!
  $(copy).show();
}

var ready = function() {
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

  // Clean the map holder.
  // Might need to find another way to prevent duplicate maps.
  console.log("Setting map view ...");

  tooltip = new ol.Overlay({
    element: document.getElementById('popover')
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
      zoom: 8
    })
  });

  // Display tooltip when the user click on the office marker.
  map.on("click", function(e) {
    map.forEachFeatureAtPixel(e.pixel, function(feature, layer) {
      if (layer === markerLayer && tooltip) {
        var element = tooltip.getElement();
        $(element).popover("show");
      }
    })
  });

  // Remove tooltip when the map is zoomed or dragged.
  map.on("movestart", function(e) {
    if (tooltip) {
      var element = tooltip.getElement();
      $(element).popover("hide");
    }
  })

  // Remove tooltip when the page is scrolled.
  window.addEventListener('scroll', function(e) {
    var ticking = false;
    if (!ticking) {
      window.requestAnimationFrame(function() {
        if (tooltip) {
          var element = tooltip.getElement();
          $(element).popover("hide");
        }
        ticking = false;
      });
      ticking = true;
    }
  });
};


// Attach all of them to the browser, page, and turbolinks event.
$(document).on('turbolinks:load', ready);
