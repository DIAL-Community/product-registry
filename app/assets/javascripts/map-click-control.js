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
      org = feature.get("organizations")[0];
      var content =
      `<div class="card map-popup" style="bottom: -6.5rem; padding: 0">
        <h6 class="card-header py-2 px-2">${org.name}</h6>
        <p class="small py-2 px-2 mb-0">
          <a href="//${org.website}" target="_blank">${org.website}</a> <br />
          Endorser since ${org.when_endorsed} <br />
          <a href="/organizations/${org.id}" target="_blank"><small>View organization</small></a> <br />
        </p>
      </div>`;
      mapObject.showCountries(org.countries);
      $(element).html(content);
    } else {
      orgs = feature.get("organizations");
      var contentDiv = $('<div class="card map-popup" style="overflow: hidden; max-height: 20rem; bottom: -7rem; padding: 0"/>');
      var contentHeader = $('<h6 class="card-header py-2 px-2">' + orgs.length + ' Organizations</h6>');
      contentDiv.append(contentHeader);
      var orgElements = $('<div class="list-group" style="overflow-y: auto;" />');
      contentDiv.append(orgElements);
      orgs.forEach(function (org) {
        var orgInfo = $('<div class="list-group-item list-group-item-action py-2 px-2" />');
        orgInfo.click(function() {
          $(this).parents(".list-group").find('.org-details').hide();
          $(this).find('.org-details').show();
          mapObject.hideCountries();
          mapObject.showCountries(org.countries);
        });
        orgInfo.append(`<strong>${org.name}</strong>`);
        orgInfo.append(`<p class="org-details mb-0" style="display:none">
                        <small>
                          <a href="//${org.website}" target="_blank">${org.website}</a> <br />
                          Endorser since ${org.when_endorsed}. <br />
                          <a href="/organizations/${org.id}" target="_blank">View organization</a> <br />
                        </small>
                      </p>`)
        orgElements.append(orgInfo);
      });
      $(element).empty();
      $(element).append(contentDiv);
    }

    mapObject.popup.setPosition(evt.coordinate);
  } else {
    mapObject.popup.setPosition(undefined);
    mapObject.hideCountries();
  }
};
