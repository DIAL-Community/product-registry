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
function addSector(value, label) {

  // Find the hidden based element and clone it.
  var copy = $("#base-selected-sectors").clone();

  // Remove the id so it won't have the same id with the hidden element.
  $(copy).removeAttr("id");

  // Display the value of the selection.
  $(copy).find("p").text(label);

  // Find the hidden input element and assign some values to it.
  // Make sure:
  // * The name for each hidden input will be different (or it won't work).
  var input = $(copy).find("input");
  $(input).attr("name", "selected_sector[" + value + "]");
  $(input).val(value);

  // Attach the copy to the parent of the hidden element.
  $(copy).appendTo($("#base-selected-sectors").parent());

  // Toggle the show to show it to the user. Yay!
  $(copy).show();
}

var ready = function() {
  // Init the datepicker field.
  $('#organization_when_endorsed').datepicker();

  // Hide the base sectors tag element.
  $('#base-selected-sectors').hide();

  // Init the autocomplete for the sector field.
  $("#sector-search")
    .autocomplete({
      source: function(request, response) {
        $.getJSON(
          "/sectors.json?without_paging=true", {
            search: request.term
          },
          function(sectors) {
            response($.map(sectors, function(sector) {
              return {
                id: sector.id,
                label: sector.name,
                value: sector.name
              }
            }));
          }
        );
      },
      select: function(event, ui) {
        addSector(ui.item.id, ui.item.label)
        $(this).val("")
        return false;
      }
    });
};

// Attach all of them to the browser, page, and turbolinks event.
$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('turbolinks:load', ready)
