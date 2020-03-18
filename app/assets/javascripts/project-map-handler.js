const projectMapHandler = function() {

  const highlightHolder = {
    projects: []
  }

  $('#project-selector').change(function() {
    if (mapOfProject) {
      var projectId = $(this).val();

      // Remove partial features.
      mapOfProject.countryHightlightLayer.getSource().forEachFeature(function(feature) {
        if (feature.get("partialProjects") === true) {
          mapOfProject.countryHightlightLayer.getSource().removeFeature(feature);
        }
      })

      // Add back all features from temporary holder. 
      highlightHolder.projects.forEach(function(feature) {
        mapOfProject.countryHightlightLayer.getSource().addFeature(feature);
      });

      // Reset the holder.
      highlightHolder.projects.length = 0;

      mapOfProject.countryHightlightLayer.getSource().forEachFeature(function(feature) {
        if (parseInt(projectId) === -1) {
          return;
        }

        const filteredProjects = feature.get("projects")
                                        .filter(function(id) {
                                          return projectId == id;
                                        });

        mapOfProject.countryHightlightLayer.getSource().removeFeature(feature);
        highlightHolder.projects.push(feature);

        if (filteredProjects.length > 0) {
          mapOfProject.countryHightlightLayer.getSource().addFeature(new ol.Feature({
            name: feature.get("name"),
            coordinate: feature.get("coordinate"),
            geometry: feature.get("geometry"),
            projects: filteredProjects,
            partialProjects: true
          }));
        }
      });

      mapOfProject.popup.setPosition(undefined);
    }
  });
}

$(document).on('projects#map_projects:loaded', projectMapHandler);
