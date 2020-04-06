const yearSelectionReady = function() {

    for (var iy = 2015; iy <= new Date().getFullYear(); iy++) {
      var option = new Option(iy, iy);
      $(option).html(iy);
      $('#year').append(option);
    }

    $('#year').change(function() {
      var yearId = $(this).val();

      mapObject.popup.setPosition(undefined);
      mapObject.countryHightlightLayer.getSource().forEachFeature(function(feature) {
        mapObject.countryLayer.getSource().addFeature(feature);
      });
      mapObject.countryHightlightLayer.getSource().clear();

      mapObject.markerLayer.getSource().forEachFeature(function(iFeature) {
        if (iFeature.get("partial_year") === true) {
          mapObject.markerLayer.getSource().removeFeature(iFeature);
        }
      })
      mapObject.markerHoldingLayer.getSource().forEachFeature(function(iFeature) {
        mapObject.markerLayer.getSource().addFeature(iFeature);
      });
      mapObject.markerHoldingLayer.getSource().clear();
      mapObject.markerLayer.getSource().forEachFeature(function(iFeature) {
        if (parseInt(yearId) === -1)
          return;

        // remove all non matching endersed year
        var filtered = iFeature.get("organizations").filter(function(organization) {
          return yearId == organization.when_endorsed;
        });

        if (filtered.length !== iFeature.get("organizations").length) {
          mapObject.markerLayer.getSource().removeFeature(iFeature);
          mapObject.markerHoldingLayer.getSource().addFeature(iFeature);
          if (filtered.length > 0) {
            mapObject.markerLayer.getSource().addFeature(new ol.Feature({
              coordinate: iFeature.get("coordinate"),
              geometry: iFeature.get("geometry"),
              organizations: filtered,
              partial_year: true
            }));
          }
        }
      });
    });
}

$(document).on('organizations#map:loaded', yearSelectionReady);
$(document).on('organizations#map_fs:loaded', yearSelectionReady);
