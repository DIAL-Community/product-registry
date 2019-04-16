mapObject.clickHandler = function(evt) {
  var feature = mapObject.map.forEachFeatureAtPixel(
    evt.pixel,
    function(ft, layer) {
      if (layer == mapObject.markerLayer) {
        return ft;
      }
    }
  );
  if (feature) {
    mapObject.countryHightlightLayer.getSource().forEachFeature(function (feature) {
      mapObject.countryLayer.getSource().addFeature(feature);
    });
    mapObject.countryHightlightLayer.getSource().clear();

    var content =
    '<div class="map-popup">' +
    '<p class="mb-2"><strong><a href="http://' + feature.get("website") + '">' + feature.get('website') + '</a></strong></p>' +
    '<p class="text-muted mb-2">Endorser since ' + feature.get("when_endorsed") + '</p>' +
    '<p class="float-right mb-2"><a href="/organizations/' + feature.get("id") + '"><small>View organization</small></a></p>' +
    '</div>';

    feature.get('countries').forEach(function(cLabel) {
      mapObject.countryLayer.getSource().forEachFeature(function(cFeature) {
        if (cLabel == cFeature.get('name')) {
          mapObject.countryHightlightLayer.getSource().addFeature(cFeature);
        }
      });
    });
    mapObject.countryHightlightLayer.getSource().forEachFeature(function (feature) {
      mapObject.countryLayer.getSource().removeFeature(feature);
    });

    var element = mapObject.popup.element;
    $(element).html(content);
    mapObject.popup.setPosition(evt.coordinate);
  } else {
    mapObject.popup.setPosition(undefined);
    mapObject.countryHightlightLayer.getSource().forEachFeature(function (feature) {
      mapObject.countryLayer.getSource().addFeature(feature);
    });
    mapObject.countryHightlightLayer.getSource().clear();
  }
};
