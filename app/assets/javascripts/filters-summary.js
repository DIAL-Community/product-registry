var updateCount = function() {

  $.when($.ajax('/object_counts'))
  .done(function(countObject) {
    $('.sdg-badge').html(countObject.sdgCount)
    $('.use-case-badge').html(countObject.useCaseCount)
    $('.workflow-badge').html(countObject.workflowCount)
    $('.bb-badge').html(countObject.bbCount)
    $('.product-badge').html(countObject.productCount)
    $('.org-badge').html(countObject.orgCount)
    $('.project-badge').html(countObject.projectCount)
    $('.playbook-badge').html(countObject.playbookCount)
  });
}


$(document).on('sustainable_development_goals#index:loaded', updateCount);
$(document).on('use_cases#index:loaded', updateCount);
$(document).on('workflows#index:loaded', updateCount);
$(document).on('building_blocks#index:loaded', updateCount);
$(document).on('products#index:loaded', updateCount);
$(document).on('organizations#index:loaded', updateCount);
$(document).on('projects#index:loaded', updateCount);
$(document).on('playbooks#index:loaded', updateCount);
