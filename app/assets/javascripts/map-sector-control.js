var mapReady = function() {

  $.getJSON(
    '/sectors.json?without_paging=true',
    function(sectors) {
      sectors.forEach(function(sector) {
        var option = new Option(sector.name, sector.id);
        $(option).html(sector.name);
        $('#sector').append(option);
      });
    }
  );

  $('#sector').change(function() {
    if (mapObject) {
      var sectorId = $(this).val();

      var popoverElement = mapObject.popup.element;
      $(popoverElement).popover('hide');

      mapObject.markerLayer.getSource().clear();

      $.getJSON('/organizations.json?without_paging=true&sector_id=' + sectorId, function(organizations) {
        organizations.forEach(function(o) {
          o.offices.forEach(function(of) {
            var iconFeature = new ol.Feature({
              id: o.id,
              geometry: new ol.geom.Point(ol.proj.transform([of.lon, of.lat],'EPSG:4326','EPSG:3857')),
              name: o.name,
              website: o.website,
              when_endorsed: o.when_endorsed.substr(0,4),
              countries: o.countries
            });
            mapObject.markerLayer.getSource().addFeature(iconFeature);
          });
        });

        $("#year").trigger('change');
      });
    }
  });
}

// Attach all of them to the browser, page, and turbolinks event.
$(document).on('turbolinks:load', mapReady);
