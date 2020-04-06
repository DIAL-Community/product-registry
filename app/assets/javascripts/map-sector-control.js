const sectorSelectionReady = function() {
  $.getJSON(
    '/sectors.json?display_only=true&without_paging=true',
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

      mapObject.popup.setPosition(undefined);

      mapObject.countryHightlightLayer.getSource().forEachFeature(function(feature) {
        mapObject.countryLayer.getSource().addFeature(feature);
      });
      mapObject.countryHightlightLayer.getSource().clear();

      mapObject.markerLayer.getSource().forEachFeature(function(iFeature) {
        if (iFeature.get("partial_sector") === true) {
          mapObject.markerLayer.getSource().removeFeature(iFeature);
        }
      })
      mapObject.sectorMarkerHoldingLayer.getSource().forEachFeature(function(iFeature) {
        mapObject.markerLayer.getSource().addFeature(iFeature);
      });
      mapObject.sectorMarkerHoldingLayer.getSource().clear();
      mapObject.markerLayer.getSource().forEachFeature(function(iFeature) {
        if (parseInt(sectorId) === -1)
          return;

        // remove all non matching sectors.
        var filtered = iFeature.get("organizations").filter(function(organization) {
          return $.inArray(parseInt(sectorId), organization.sectors) > 0;
        });
      
        if (filtered.length !== iFeature.get("organizations").length) {
          mapObject.markerLayer.getSource().removeFeature(iFeature);
          mapObject.sectorMarkerHoldingLayer.getSource().addFeature(iFeature);
          if (filtered.length > 0) {
            mapObject.markerLayer.getSource().addFeature(new ol.Feature({
              coordinate: iFeature.get("coordinate"),
              geometry: iFeature.get("geometry"),
              organizations: filtered,
              partial_sector: true
            }));
          }
        }
      });
    }
  });
}

// Attach all of them to the browser, page, and turbolinks event.
$(document).on('organizations#map:loaded', sectorSelectionReady);
$(document).on('organizations#map_fs:loaded', sectorSelectionReady);
