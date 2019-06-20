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
    var element = mapObject.popup.element;
    if (feature.get("organizations").length == 1) {
      console.log("one org");
      org = feature.get("organizations")[0];
      var content =
      '<div class="card map-popup" style="bottom: -9rem; padding: 0">' +
      '<h6 class="card-header p-2">' + org.name + '</h6>' +
      '<p class="text-muted mt-2 ml-2 mb-0"><a href="http://' + org.website + '">' + org.website + '</a></p>' +
      '<p class="text-muted mt-2 ml-2 mb-0">Endorser since ' + org.when_endorsed + '</p>' +
      '<p class="text-muted mt-2 ml-2 mb-2"><a href="/organizations/' + org.id + '"><small>View organization</small></a></p>' +
      '</div>';
      console.log(content);
      mapObject.showCountries(org.countries);
      $(element).html(content);
    } else {
      orgs = feature.get("organizations");
      var contentDiv = $('<div class="card map-popup" style="bottom: -9rem; padding: 0"/>');
      var contentHeader = $('<h6 class="card-header p-2">' + orgs.length + ' Organizations</h6>');
      contentDiv.append(contentHeader);
      var orgListEl = $('<ul/>');
      contentDiv.append(orgListEl);
      orgs.forEach(function (org) {
        var orgLi = $('<li/>');
        var orgA = $('<a href="#">' + org.name + '</a>');
        orgA.click(function(e) {
          $($(e.target).parents('ul')[0]).find('.org-details').hide();
          $(e.target).parent().find('.org-details').show();
          mapObject.hideCountries();
          mapObject.showCountries(org.countries);
        });
        orgLi.append(orgA);
        orgLi.append('<p class="org-details" style="display:none"><small><a href="http://' + org.website + '">' + org.website + '</a>' + ', since ' + org.when_endorsed +
        '. <a href="/organizations/' + org.id + '">View organization</a></small></p>')
        orgListEl.append(orgLi);
      });
      $(element).empty();
      $(element).append(contentDiv);
    }
    mapObject.popup.setPosition(feature.get("coordinate"));
  } else {
    mapObject.popup.setPosition(undefined);
    mapObject.hideCountries();
  }
};
