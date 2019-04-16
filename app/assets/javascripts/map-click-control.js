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
    '<div class="card map-popup" style="bottom: -7.5rem; padding: 0">' +
    '<h6 class="card-header p-2"><a href="http://' + feature.get("website") + '">' + feature.get('website') + '</a></h6>' +
    '<p class="text-muted mt-2 ml-2 mb-0">Endorser since ' + feature.get("when_endorsed") + '</p>' +
    '<p class="text-muted mt-2 ml-2 mb-2"><a href="/organizations/' + feature.get("id") + '"><small>View organization</small></a></p>' +
    '</div>';

    console.log(feature);

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
    mapObject.popup.setPosition(feature.get("coordinate"));
  } else {
    mapObject.popup.setPosition(undefined);
    mapObject.countryHightlightLayer.getSource().forEachFeature(function (feature) {
      mapObject.countryLayer.getSource().addFeature(feature);
    });
    mapObject.countryHightlightLayer.getSource().clear();
  }
};
