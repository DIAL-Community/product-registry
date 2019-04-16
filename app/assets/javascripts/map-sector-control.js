var mapReady = function() {

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

      mapObject.countryHightlightLayer.getSource().forEachFeature(function(feature) {
        mapObject.countryLayer.getSource().addFeature(feature);
      });
      mapObject.countryHightlightLayer.getSource().clear();

      mapObject.markerHoldingLayer.getSource().forEachFeature(function(iFeature) {
        mapObject.markerLayer.getSource().addFeature(iFeature);
      });
      mapObject.markerHoldingLayer.getSource().clear();
      mapObject.markerLayer.getSource().forEachFeature(function(iFeature) {
        if ($.inArray(parseInt(sectorId), iFeature.get('sectors')) < 0 && parseInt(sectorId) !== -1) {
          mapObject.markerLayer.getSource().removeFeature(iFeature);
          mapObject.markerHoldingLayer.getSource().addFeature(iFeature);
        }
      });
    }
  });
}

// Attach all of them to the browser, page, and turbolinks event.
$(document).on('turbolinks:load', mapReady);
