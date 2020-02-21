
function locationsReady() {
  $("button.add-other-name").click(function(event) {
    event.preventDefault();
    addOtherName();
  });

  $("button.remove-other-name").click(function(event) {
    event.preventDefault();
    removeOtherName(event.target);
  });
}

// Attach all of them to the browser, page, and turbolinks event.
$(document).on('locations#new:loaded', locationsReady);
$(document).on('locations#edit:loaded', locationsReady);