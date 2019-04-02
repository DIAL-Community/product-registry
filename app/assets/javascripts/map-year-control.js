mapObject.yearSelector = document.createElement('select');
mapObject.yearSelector.id = "year";

mapObject.YearSelectorControl = function YearSelectorControl(selectElement) {
    var yearHTML = '<option value="All">All Years</option>';
    for (var iy = 2015; iy <= new Date().getFullYear(); iy++) {
      yearHTML += '<option value="' + iy + '">' + iy + '</option>'
    }
    selectElement.innerHTML = yearHTML;
    selectElement.className = "custom-select"

    var element = document.createElement('div');
    element.className = 'float-right';
    element.appendChild(selectElement);

    ol.control.Control.call(this, {
      element: element,
      target: 'map',
    });

    selectElement.addEventListener('change', this.handleYearSelection.bind(this), false);
  },

  mapObject.handleYearSelection = function() {
    $(mapObject.popup.element).popover('hide');
    mapObject.countryHightlightLayer.getSource().forEachFeature(function(feature) {
      mapObject.countryLayer.getSource().addFeature(feature);
    });
    mapObject.countryHightlightLayer.getSource().clear();

    var isAll = $(mapObject.yearSelector).val() == 'All';
    mapObject.markerHoldingLayer.getSource().forEachFeature(function(iFeature) {
      mapObject.markerLayer.getSource().addFeature(iFeature);
    });
    mapObject.markerHoldingLayer.getSource().clear();
    mapObject.markerLayer.getSource().forEachFeature(function(iFeature) {
      if (!isAll && $(mapObject.yearSelector).val() != iFeature.get('when_endorsed')) {
        mapObject.markerLayer.getSource().removeFeature(iFeature);
        mapObject.markerHoldingLayer.getSource().addFeature(iFeature);
      }
    });
  };
