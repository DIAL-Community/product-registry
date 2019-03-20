function remove(self) {
  var baseCard = $(self).parent().parent();
  $(baseCard).remove();
}

$('document').ready(function() {
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

  $("#organization_sectors")
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
        var copy = $("#base-selected-sectors").clone();
        $(copy).removeAttr("id");
        $(copy).attr("data-id", "selected-sectors");
        $(copy).attr("data-value", ui.item.value);
        $(copy).attr("data-label", ui.item.label);
        $(copy).find("p").text(ui.item.label);
        $(copy).appendTo($("#base-selected-sectors").parent());
        $(copy).show();
        $(this).val('')
        return false;
      }
    });
});
