var updateCount = function() {

  $.when($.ajax('/sustainable_development_goals/count'),
         $.ajax('/use_cases/count'),
         $.ajax('/workflows/count'),
         $.ajax('/building_blocks/count'),
         $.ajax('/products/count'),
         $.ajax('/organizations/count'),
         $.ajax('/projects/count'))
  .done(function(sdgCount, useCaseCount, workflowCount, bbCount, productCount, orgCount, projectCount) {
    $('#sdg-badge').html(sdgCount[0])
    $('#use-case-badge').html(useCaseCount[0])
    $('#workflow-badge').html(workflowCount[0])
    $('#bb-badge').html(bbCount[0])
    $('#product-badge').html(productCount[0])
    $('#org-badge').html(orgCount[0])
    $('#project-badge').html(projectCount[0])
  });
}


$(document).on('sustainable_development_goals#index:loaded', updateCount);
$(document).on('use_cases#index:loaded', updateCount);
$(document).on('workflows#index:loaded', updateCount);
$(document).on('building_blocks#index:loaded', updateCount);
$(document).on('products#index:loaded', updateCount);
$(document).on('organizations#index:loaded', updateCount);
$(document).on('projects#index:loaded', updateCount);
