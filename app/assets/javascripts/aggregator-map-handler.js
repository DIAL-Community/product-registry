const aggregatorMapHandler = function() {

  const highlightHolder = {
    aggregators: [],
    operators: [],
    services: []
  }

  $('#aggregators').change(function() {
    if (aggregator) {
      var filterAggregatorId = $(this).val();

      // Remove partial features.
      aggregator.countryHightlightLayer.getSource().forEachFeature(function(feature) {
        if (feature.get("partialAggregators") === true) {
          aggregator.countryHightlightLayer.getSource().removeFeature(feature);
        }
      })
      // Add back all features from temporary holder. 
      highlightHolder.aggregators.forEach(function(feature) {
        aggregator.countryHightlightLayer.getSource().addFeature(feature);
      });
      // Reset the holder.
      highlightHolder.aggregators.length = 0;

      aggregator.countryHightlightLayer.getSource().forEachFeature(function(feature) {
        if (parseInt(filterAggregatorId) === -1) {
          return;
        }

        const filteredAggregators = feature.get("aggregators").filter(function(aggregatorId) {
          return filterAggregatorId == aggregatorId;
        });

        aggregator.countryHightlightLayer.getSource().removeFeature(feature);
        highlightHolder.aggregators.push(feature);

        if (filteredAggregators.length > 0) {
          aggregator.countryHightlightLayer.getSource().addFeature(new ol.Feature({
            name: feature.get("NAME_0"),
            coordinate: feature.get("coordinate"),
            geometry: feature.get("geometry"),
            aggregators: filteredAggregators,
            partialAggregators: true
          }));
        }
      });

      aggregator.popup.setPosition(undefined);
    }
  });

  $('#operators').change(function() {
    if (aggregator) {
      var operatorName = $(this).val();

      // Remove partial features.
      aggregator.countryHightlightLayer.getSource().forEachFeature(function(feature) {
        if (feature.get("partialOperators") === true) {
          aggregator.countryHightlightLayer.getSource().removeFeature(feature);
        }
      })
      // Add back all features from temporary holder. 
      highlightHolder.operators.forEach(function(feature) {
        aggregator.countryHightlightLayer.getSource().addFeature(feature);
      });
      // Reset the holder.
      highlightHolder.operators.length = 0;

      const operators = aggregator.operators[operatorName];
      const operatorLocations = Object.values(operators)
          .map(function(operatorLocation) {
            return aggregator.locations[operatorLocation].name;
          })
          .filter(function(item, position, self) {
            return self.indexOf(item) == position;
          });

      aggregator.countryHightlightLayer.getSource().forEachFeature(function(feature) {
        if (parseInt(operatorName) === -1) {
          return;
        }

        aggregator.countryHightlightLayer.getSource().removeFeature(feature);
        highlightHolder.operators.push(feature);

        if (operatorLocations.indexOf(feature.get('NAME_0')) !== -1) {
          const filteredAggregators = feature.get("aggregators").filter(function(aggregatorId) {
            const normalized = aggregator.aggregators[aggregatorId];
            const intersect = Object.keys(operators).filter(function(operator) {
              return normalized.operators.indexOf(parseInt(operator)) !== -1;
            });

            return intersect.length > 0;
          });

          if (filteredAggregators.length > 0) {
            aggregator.countryHightlightLayer.getSource().addFeature(new ol.Feature({
              name: feature.get("NAME_0"),
              coordinate: feature.get("coordinate"),
              geometry: feature.get("geometry"),
              aggregators: filteredAggregators,
              partialOperators: true
            }));
          }
        }
      });

      aggregator.popup.setPosition(undefined);
    }
  });

  $('#services').change(function() {
    if (aggregator) {
      var serviceName = $(this).val();

      // Remove partial features.
      aggregator.countryHightlightLayer.getSource().forEachFeature(function(feature) {
        if (feature.get("partialServices") === true) {
          aggregator.countryHightlightLayer.getSource().removeFeature(feature);
        }
      })
      // Add back all features from temporary holder. 
      highlightHolder.services.forEach(function(feature) {
        aggregator.countryHightlightLayer.getSource().addFeature(feature);
      });
      // Reset the holder.
      highlightHolder.services.length = 0;

      aggregator.countryHightlightLayer.getSource().forEachFeature(function(feature) {
        if (parseInt(serviceName) === -1) {
          return;
        }

        aggregator.countryHightlightLayer.getSource().removeFeature(feature);
        highlightHolder.services.push(feature);

        const operatorName = $('#operators').val();
        const operators = aggregator.operators[operatorName];

        const filteredAggregators = feature.get("aggregators").filter(function(aggregatorId) {
          const normalized = aggregator.aggregators[aggregatorId];
          const matchingCapabilities = normalized.capabilities.filter(function(capabilitiy) {
            // Skip:
            // * not matching feature's name and country's name.
            // * not matching service and filtered service name.
            if (capabilitiy.country !== feature.get("NAME_0") || capabilitiy.service !== serviceName) {
              return false;
            }

            return parseInt(operatorName) === -1 || Object.keys(operators).indexOf(`${capabilitiy.operator}`) !== -1
          });

          return matchingCapabilities.length > 0;
        });

        if (filteredAggregators.length > 0) {
          aggregator.countryHightlightLayer.getSource().addFeature(new ol.Feature({
            name: feature.get("NAME_0"),
            coordinate: feature.get("coordinate"),
            geometry: feature.get("geometry"),
            aggregators: filteredAggregators,
            partialServices: true
          }));
        }
      });
      aggregator.popup.setPosition(undefined);
    }
  });
}

$(document).on('organizations#map_aggregators:loaded', aggregatorMapHandler);
