/*
 * The function to remove grandparent element from the DOM. This will be called
 * when the user click on the delete button on the tag like object. In the future
 * this will be called on sectors, locations, and contacts.
 */
function remove(self) {
  var baseCard = $(self).closest('.selected-element');
  $(baseCard).remove();
}

/*
 * Create a new sector section and assign the value of the sector to the hidden
 * input field. The hidden input field will be used to define the child objects.
 */
function addElement(baseElementId, inputElementName, value, label) {
  var copy = $("#" + baseElementId).clone();

  $(copy).removeAttr("id");
  $(copy).find(".text-label").html(label);

  var input = $(copy).find("input");
  $(input).attr("name",  inputElementName + "[" + value + "]");
  $(input).val(value);

  $(copy).appendTo($("#" + baseElementId).parent());

  $(copy).show();
}

// Create autocomplete configuration for searches.
function autoComplete(source, callback) {
  return {
    minLength: 2,
    source: function(request, response) {
      $.getJSON(
        source, {
          search: request.term
        },
        function(responses) {
          response($.map(responses, function(response) {
            return {
              id: response.id,
              label: response.name,
              value: response.name
            }
          }));
        }
      );
    },
    select: function(event, ui) {
      callback(ui.item.id, ui.item.label)
      $(this).val("")
      return false;
    }
  }
}

/*
 Used:
 * locations#new
 * locations#edit
 * sectors#new
 * sectors#edit
 * contacts#new
 * contacts#edit
 */

function addOrganization(value, label) {
  addElement("base-selected-organizations", "selected_organizations", value, label);
}

function addSector(value, label) {
  addElement("base-selected-sectors", "selected_sectors", value, label);
}

function addProduct(value, label) {
  addElement("base-selected-products", "selected_products", value, label);
}

function addBuildingBlock(value, label) {
  addElement("base-selected-building-blocks", "selected_building_blocks", value, label);
}

function addInteropProduct(value, label) {
  addElement("base-selected-interoperable-products", "selected_interoperable_products", value, label);
}

function addIncludedProduct(value, label) {
  addElement("base-selected-included-products", "selected_included_products", value, label);
}

function addSDG(value, label) {
  addElement("base-selected-sustainable-development-goals", "selected_sustainable_development_goals", value, label);
}

function addSdgTarget(value, label) {
  addElement("base-selected-sdg-targets", "selected_sdg_targets", value, label);
}

function addUseCase(value, label) {
  addElement("base-selected-use-cases", "selected_use_cases", value, label);
}

function addWorkflow(value, label) {
  addElement("base-selected-workflows", "selected_workflows", value, label);
}

var organizationAutoCompleteReady = function() {
  var organizationAutoComplete = autoComplete("/organizations.json?without_paging=true", addOrganization)
  $("#base-selected-organizations").hide();
  $("#organization-search").autocomplete(organizationAutoComplete);
}

var sectorAutoCompleteReady = function() {
  var sectorAutoComplete = autoComplete("/sectors.json?without_paging=true", addSector)
  $("#base-selected-sectors").hide();
  $("#sector-search").autocomplete(sectorAutoComplete);
}

var buildingBlockAutoCompleteReady = function() {
  var buildingBlockAutoComplete = autoComplete("/products.json?without_paging=true", addProduct)
  $("#base-selected-products").hide();
  $("#product-search").autocomplete(buildingBlockAutoComplete);
}

var productAutoCompleteReady = function() {
  var productAutoComplete = autoComplete("/building_blocks.json?without_paging=true", addBuildingBlock)
  $("#base-selected-building-blocks").hide();
  $("#building-block-search").autocomplete(productAutoComplete);
}

var interopProductAutoCompleteReady = function() {
  var interopProductAutoComplete = autoComplete("/products.json?without_paging=true", addInteropProduct)
  $("#base-selected-interoperable-products").hide();
  $("#interoperate-search").autocomplete(interopProductAutoComplete);
}

var includeProductAutoCompleteReady = function() {
  var includeProductAutoComplete = autoComplete("/products.json?without_paging=true", addIncludedProduct)
  $("#base-selected-included-products").hide();
  $("#include-search").autocomplete(includeProductAutoComplete);
}

var sdgsAutoCompleteReady = function() {
  var sdgsAutoComplete = autoComplete("/sustainable_development_goals.json?without_paging=true", addSDG)
  $("#base-selected-sustainable-development-goals").hide();
  $("#sustainable-development-goal-search").autocomplete(sdgsAutoComplete);
}

var sdgTargetsAutoCompleteReady = function() {
  var sdgTargetsAutoComplete = autoComplete("/sdg_targets.json?without_paging=true", addSdgTarget)
  $("#base-selected-sdg-targets").hide();
  $("#sdg-target-search").autocomplete(sdgTargetsAutoComplete);
}

var useCasesAutoCompleteReady = function() {
  var useCasesAutoComplete = autoComplete("/use_cases.json?without_paging=true", addUseCase)
  $("#base-selected-use-cases").hide();
  $("#use-case-search").autocomplete(useCasesAutoComplete);
}

var workflowsAutoCompleteReady = function() {
  var workflowsAutoComplete = autoComplete("/workflows.json?without_paging=true", addWorkflow)
  $("#base-selected-workflows").hide();
  $("#workflow-search").autocomplete(workflowsAutoComplete);
}

$(document).on('turbolinks:load', organizationAutoCompleteReady);
$(document).on('turbolinks:load', buildingBlockAutoCompleteReady);
$(document).on('turbolinks:load', sectorAutoCompleteReady);
$(document).on('turbolinks:load', productAutoCompleteReady);
$(document).on('turbolinks:load', interopProductAutoCompleteReady);
$(document).on('turbolinks:load', includeProductAutoCompleteReady);
$(document).on('turbolinks:load', sdgsAutoCompleteReady);
$(document).on('turbolinks:load', sdgTargetsAutoCompleteReady);
$(document).on('turbolinks:load', useCasesAutoCompleteReady);
$(document).on('turbolinks:load', workflowsAutoCompleteReady);