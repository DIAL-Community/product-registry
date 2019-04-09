// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

function productsReady() {
  // hook drop down item click event
  $("#digisquare-element .dropdown-item").click(function() {
    $(this).parents(".dropdown").find(".btn").text($(this).text());
    $(this).parents(".dropdown").find(".btn").val($(this).text());
  });
}

// Attach all of them to the browser, page, and turbolinks event.
$(document).on('turbolinks:load', productsReady);
