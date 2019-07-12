// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree ./v5.3.0-dist
//= require map
//= require map-style
//= require map-year-control
//= require map-click-control
//= require jquery-ui/widgets/datepicker
//= require jquery-ui/widgets/autocomplete
//= require popper
//= require bootstrap
//= require_tree .

function triggerPageEvents() {
  var data = $('body').data();
  $(document).trigger(data.controller + ':loaded');
  $(document).trigger(data.controller + '#' + data.action + ':loaded');

  $('[data-toggle="tooltip"]').tooltip()
}

$(document).on("turbolinks:load", triggerPageEvents);
