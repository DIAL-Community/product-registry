/*
 * The function to remove grandparent element from the DOM. This will be called
 * when the user click on the delete button on the tag like object. In the future
 * this will be called on sectors, locations, and contacts.
 */
function remove(self) {
  var baseCard = $(self).parent().parent();
  $(baseCard).remove();
}

/*
 * Create a new sector section and assign the value of the sector to the hidden
 * input field. The hidden input field will be used to define the child objects.
 */
function addElement(baseElementId, inputElementName, value, label) {
  var copy = $("#" + baseElementId).clone();

  $(copy).removeAttr("id");
  $(copy).find("p").html(label);

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

var organizationAutoCompleteReady = function() {
  var organizationAutoComplete = autoComplete("/organizations.json?without_paging=true", addOrganization)
  $("#base-selected-organizations").hide();
  $("#organization-search").autocomplete(organizationAutoComplete);
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

$(document).on('turbolinks:load', organizationAutoCompleteReady);
$(document).on('turbolinks:load', buildingBlockAutoCompleteReady);
$(document).on('turbolinks:load', productAutoCompleteReady);
$(document).on('turbolinks:load', interopProductAutoCompleteReady);
$(document).on('turbolinks:load', includeProductAutoCompleteReady);
