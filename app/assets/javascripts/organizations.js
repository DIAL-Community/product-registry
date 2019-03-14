$('document').ready(function() {
  if ($('#organization_sectors_selector').length) {
    $.getJSON('/sectors.json', function(sectors) {
      var selector = $('#organization_sectors_selector');
      sectors.forEach(function(sector) {
        selector.append($('<option/>').val(sector.slug).text(sector.name));
      });
    });
  }

  $('.datepicker').datepicker();
});
