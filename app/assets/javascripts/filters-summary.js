var updateCount = function() {

  $.when($.ajax('/sustainable_development_goals/count'),
         $.ajax('/use_cases/count'),
         $.ajax('/workflows/count'),
         $.ajax('/building_blocks/count'),
         $.ajax('/products/count'),
         $.ajax('/organizations/count'))
  .done(function(sdgCount, useCaseCount, workflowCount, bbCount, productCount, orgCount) {
    $('#sdg-badge').html(sdgCount[0])
    $('#use-case-badge').html(useCaseCount[0])
    $('#workflow-badge').html(workflowCount[0])
    $('#bb-badge').html(bbCount[0])
    $('#product-badge').html(productCount[0])
    $('#org-badge').html(orgCount[0])
  });
}

$(document).on("turbolinks:load", updateCount);
