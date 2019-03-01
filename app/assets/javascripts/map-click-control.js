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
    var element = mapObject.popup.element; //getElement();
    mapObject.popup.setPosition(evt.coordinate);
    mapObject.countryHightlightLayer.getSource().forEachFeature(function (feature) {
      mapObject.countryLayer.getSource().addFeature(feature);
    });
    mapObject.countryHightlightLayer.getSource().clear();
    var content = '<p><a href="http://' + feature.get('website') + '">' + feature.get('website') + '</a><br/>Endorser since ' + feature.get('when_endorsed') + '</p>';
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
    $(element).popover('destroy');
    $(element).popover({
      placement: 'top',
      animation: false,
      html: true,
      content: content,
      trigger: 'focus',
      title: feature.get('name')
    });
    $(element).popover('show');
    $(element).click(function(e) {
      $(element).popover('hide');
    })
  } else {
    $(mapObject.popup.element).popover('hide');
    mapObject.countryHightlightLayer.getSource().forEachFeature(function (feature) {
      mapObject.countryLayer.getSource().addFeature(feature);
    });
    mapObject.countryHightlightLayer.getSource().clear();
  }
};
