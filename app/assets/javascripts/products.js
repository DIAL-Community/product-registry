// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

function productsReady() {
  // hook drop down item click event
  $("#digisquare-element .dropdown-item").click(function() {
    $(this).parents(".dropdown").find("button").html($(this).html());
    $(this).parents(".dropdown").find("input").val($(this).attr("data-sub-indicator"));
  });

  toggleAssessmentSection($('#product-assessment'));
  $('#product-assessment').change(function() {
    toggleAssessmentSection($(this));
  });
  
  var organizationAutoComplete = autoComplete("/organizations.json?without_paging=true", addOrganization)
  $("#base-selected-organizations").hide();
  $("#organization-search").autocomplete(organizationAutoComplete);

  $("button.add-other-name").click(function(event) {
    event.preventDefault();
    addOtherName();
  });

  $("button.remove-other-name").click(function(event) {
    event.preventDefault();
    removeOtherName(event.target);
  });
  
  $('.custom-file-input').on('change', function () {
    var fileName = $(this).val().split('\\').pop();
    $(this).next('.custom-file-label').html(fileName);
  });
}

function addOtherName(value) {
  var clone = $("#base-other-name").clone();

  clone.removeAttr("id");

  clone.find("button.add-other-name").click(function(event) {
    event.preventDefault();
    addOtherName();
  });
  clone.find("button.remove-other-name").click(function(event) {
    event.preventDefault();
    removeOtherName(event.target);
  });

  if (value) {
    clone.find("input").val(value);
    $("#other-names").prepend(clone);
  } else {
    clone.find("input").val("");
    $("#other-names").append(clone);
  }
}

function removeOtherName(element) {
  $(element).parent().parent().remove();
}

function toggleAssessmentSection(checkbox) {
  if ($(checkbox).prop('checked')) {
    $('#product-assessment-section').show();
  } else {
    $('#product-assessment-section').hide();
  }
}

let currentlyLoading = false;
const scrollHandler = function() {
  $(window).on('scroll', function() {
    const currentPage = $('#product-list').attr('data-current-page');
    const url = `${window.location.pathname}?page=${parseInt(currentPage) + 1}`;
    const shouldExecuteXhr = $(window).scrollTop() > $(document).height() - $(window).height() - 600; 
    if (!isNaN(currentPage) && !currentlyLoading && shouldExecuteXhr) {
      currentlyLoading = true;
      $.getScript(url, function() {
        $('#product-list').attr('data-current-page', parseInt(currentPage) + 1);
        currentlyLoading = false;
      });
    }
  });
}

// Attach all of them to the browser, page, and turbolinks event.
$(document).on('products#new:loaded', productsReady);
$(document).on('products#edit:loaded', productsReady);

$(document).on('products#index:loaded', scrollHandler);
