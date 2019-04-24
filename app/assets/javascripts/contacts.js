// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on('turbolinks:load', function() {
  var reslugAdded = false;
  var warningShown = false;

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

  $("#duplicate-warning").hide();

  $("#contact_name").on('input', function() {
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
      "/contact_duplicates.json", {
        current: current,
        original: original
    }, function(duplicates) {
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
});
