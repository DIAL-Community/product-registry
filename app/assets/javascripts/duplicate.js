
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
      duplicateCheckUrl, {
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

$(document).on('contacts#edit:loaded', contactDuplicateCheck);
$(document).on('contacts#new:loaded', contactDuplicateCheck);
$(document).on('locations#edit:loaded', locationDuplicateCheck);
$(document).on('locations#new:loaded', locationDuplicateCheck);
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
