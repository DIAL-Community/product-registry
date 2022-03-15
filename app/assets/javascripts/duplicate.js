
function addInput(id) {
  $('<input>').attr({
    type: 'hidden',
    id: id,
    name: id,
    value: true
  }).appendTo($("#duplicate-warning"));
}

function removeInput(id) {
  $("#" + id).remove();
}

function duplicateCheck(trigerInputId, duplicateCheckUrl) {
  var reslugAdded = false;
  var warningShown = false;

  $("#duplicate-warning").hide();

  $("#" + trigerInputId).on('input', function() {
    var current = $(this).val();
    var original = $("#original_name").val();
    if (current !== original && !reslugAdded) {
      addInput('reslug');
      reslugAdded = true;
    } else if (current === original && reslugAdded) {
      removeInput('reslug');
      reslugAdded = false;
    }

    $.getJSON(
      `${basePath}${duplicateCheckUrl}`, {
        current: current,
        original: original
      },
      function(duplicates) {
        if (duplicates.length > 0 && !warningShown) {
          $("#duplicate-warning").show();
          addInput('duplicate');
          warningShown = true;
        } else if (duplicates.length <= 0 && warningShown) {
          $("#duplicate-warning").hide();
          removeInput('duplicate');
          warningShown = false;
        }
      });
  });
};

var candidateDuplicateCheck = function() {
  duplicateCheck("candidate_organization_name", "/candidate_organization_duplicates.json");
}

var contactDuplicateCheck = function() {
  duplicateCheck("contact_name", "/contact_duplicates.json");
}

var locationDuplicateCheck = function() {
  duplicateCheck("location_name", "/location_duplicates.json");
}

var sectorDuplicateCheck = function() {
  duplicateCheck("sector_name", "/sector_duplicates.json");
}

var productDuplicateCheck = function() {
  duplicateCheck("product_name", "/product_duplicates.json");
}

var buildingBlockDuplicateCheck = function() {
  duplicateCheck("building_block_name", "/building_block_duplicates.json");
}

var organizationDuplicateCheck = function() {
  duplicateCheck("organization_name", "/organization_duplicates.json");
}

var useCaseDuplicateCheck = function() {
  duplicateCheck("use_case_name", "/use_case_duplicates.json");
}

var workflowDuplicateCheck = function() {
  duplicateCheck("workflow_name", "/workflow_duplicates.json");
}

var glossaryDuplicateCheck = function() {
  duplicateCheck("glossary_name", "/glossary_duplicates.json");
}

var projectDuplicateCheck = function() {
  duplicateCheck("project_name", "/project_duplicates.json");
}

var portalViewDuplicateCheck = function() {
  duplicateCheck("portal_view_name", "/portal_view_duplicates.json");
}

var useCaseStepDuplicateCheck = function() {
  duplicateCheck("use_case_step_name", "/use_case_step_duplicates.json");
}

var tagDuplicateCheck = function() {
  duplicateCheck("tag_name", "/tag_duplicates.json");
}

var taskTrackerDuplicateCheck = function() {
  duplicateCheck("task_tracker_name", "/task_tracker_duplicates.json");
}

var maturityRubricDuplicateCheck = function() {
  duplicateCheck("maturity_rubric_name", "/maturity_rubric_duplicates.json");
}

var rubricCategoryDuplicateCheck = function() {
  duplicateCheck("rubric_category_name", "/rubric_category_duplicates.json");
}

var categoryIndicatorDuplicateCheck = function() {
  duplicateCheck("category_indicator_name", "/category_indicator_duplicates.json");
}

var playbooksDuplicateCheck = function() {
  duplicateCheck("playbook_name", "/playbook_duplicates.json");
}

var playbookPagesDuplicateCheck = function() {
  duplicateCheck("playbook_page_name", "/playbook_page_duplicates.json");
}

var playsDuplicateCheck = function() {
  duplicateCheck("play_name", "/play_duplicates.json");
}

var tasksDuplicateCheck = function() {
  duplicateCheck("task_name", "/task_duplicates.json");
}

var candidateProductDuplicateCheck = function() {
  duplicateCheck("candidate_product_name", "/candidate_product_duplicates.json");
}

$(document).on('candidate_organizations#edit:loaded', candidateDuplicateCheck);
$(document).on('candidate_organizations#new:loaded', candidateDuplicateCheck);
$(document).on('contacts#edit:loaded', contactDuplicateCheck);
$(document).on('contacts#new:loaded', contactDuplicateCheck);
$(document).on('sectors#edit:loaded', sectorDuplicateCheck);
$(document).on('sectors#new:loaded', sectorDuplicateCheck);
$(document).on('products#edit:loaded', productDuplicateCheck);
$(document).on('products#new:loaded', productDuplicateCheck);
$(document).on('building_blocks#edit:loaded', buildingBlockDuplicateCheck);
$(document).on('building_blocks#new:loaded', buildingBlockDuplicateCheck);
$(document).on('organizations#edit:loaded', organizationDuplicateCheck);
$(document).on('organizations#new:loaded', organizationDuplicateCheck);
$(document).on('use_cases#edit:loaded', useCaseDuplicateCheck);
$(document).on('use_cases#new:loaded', useCaseDuplicateCheck);
$(document).on('workflows#edit:loaded', workflowDuplicateCheck);
$(document).on('workflows#new:loaded', workflowDuplicateCheck);
$(document).on('glossaries#edit:loaded', glossaryDuplicateCheck);
$(document).on('glossaries#new:loaded', glossaryDuplicateCheck);
$(document).on('projects#edit:loaded', projectDuplicateCheck);
$(document).on('projects#new:loaded', projectDuplicateCheck);
$(document).on('portal_views#edit:loaded', portalViewDuplicateCheck);
$(document).on('portal_views#new:loaded', portalViewDuplicateCheck);
$(document).on('use_case_steps#edit:loaded', useCaseStepDuplicateCheck);
$(document).on('use_case_steps#new:loaded', useCaseStepDuplicateCheck);
$(document).on('tags#edit:loaded', tagDuplicateCheck);
$(document).on('tags#new:loaded', tagDuplicateCheck);
$(document).on('task_trackers#new:loaded', taskTrackerDuplicateCheck);
$(document).on('task_trackers#edit:loaded', taskTrackerDuplicateCheck);
$(document).on('maturity_rubrics#edit:loaded', maturityRubricDuplicateCheck);
$(document).on('maturity_rubrics#new:loaded', maturityRubricDuplicateCheck);
$(document).on('rubric_categories#edit:loaded', rubricCategoryDuplicateCheck);
$(document).on('rubric_categories#new:loaded', rubricCategoryDuplicateCheck);
$(document).on('category_indicators#edit:loaded', categoryIndicatorDuplicateCheck);
$(document).on('category_indicators#new:loaded', categoryIndicatorDuplicateCheck);
$(document).on('playbooks#edit:loaded', playbooksDuplicateCheck);
$(document).on('playbooks#new:loaded', playbooksDuplicateCheck);
$(document).on('playbook_pages#edit:loaded', playbookPagesDuplicateCheck);
$(document).on('playbook_pages#new:loaded', playbookPagesDuplicateCheck);
$(document).on('plays#edit:loaded', playsDuplicateCheck);
$(document).on('plays#new:loaded', playsDuplicateCheck);
$(document).on('tasks#edit:loaded', tasksDuplicateCheck);
$(document).on('tasks#new:loaded', tasksDuplicateCheck);
$(document).on('candidate_products#edit:loaded', candidateProductDuplicateCheck);
$(document).on('candidate_products#new:loaded', candidateProductDuplicateCheck);
