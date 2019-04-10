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
    minLength: 3,
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

var organizationAutoCompleteReady = function() {
  var organizationAutoComplete = autoComplete("/organizations.json", addOrganization)
  $("#base-selected-organizations").hide();
  $("#organization-search").autocomplete(organizationAutoComplete);
}

$(document).on('turbolinks:load', organizationAutoCompleteReady);
