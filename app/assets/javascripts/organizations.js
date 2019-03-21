function remove(self) {
  var baseCard = $(self).parent().parent();
  $(baseCard).remove();
}

function addSector(value, label) {

  var copy = $("#base-selected-sectors").clone();
  $(copy).removeAttr("id");
  $(copy).attr("data-id", "selected-sectors");
  $(copy).find("p").text(label);

  var input = $(copy).find("input");
  $(input).attr("name", "selected_sector[" + value + "]");
  $(input).val(value);

  $(copy).appendTo($("#base-selected-sectors").parent());
  $(copy).show();
}

var ready = function() {
  if ($('#organization_sectors_selector').length) {
    $.getJSON('/sectors.json', function(sectors) {
      var selector = $('#organization_sectors_selector');
      sectors.forEach(function(sector) {
        selector.append($('<option/>').val(sector.slug).text(sector.name));
      });
    });
  }

  $('#base-selected-sectors').hide();
  $('#organization_when_endorsed').datepicker();

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
                label: sector.name,
                value: sector.id
              }
            }));
          }
        );
      },
      select: function(event, ui) {
        addSector(ui.item.value, ui.item.label)
        $(this).val("")
        return false;
      }
    });
};

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('turbolinks:load', ready)
