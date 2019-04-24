// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

function addConfirmation() {
  $('<input>').attr({
    type: 'hidden',
    id: "confirmation",
    name: 'confirmation',
    value: true
  }).appendTo($("#slug-warning"));
}

function removeConfirmation() {
  $("#confirmation").remove();
}

$(document).on('turbolinks:load', function() {
  $("#slug-warning").hide();
  $("#contact_name").on('input', function() {
    var name = $(this).val();
    var slug = $("#slug-warning").attr("data-slug");
    $.getJSON(
      "/contact_duplicates.json", {
        name: name,
        slug: slug
    }, function(duplicates) {
      if (duplicates.length > 0) {
        $("#slug-warning").show();
        addConfirmation();
      } else {
        $("#slug-warning").hide();
        removeConfirmation();
      }
    });
  });
});
