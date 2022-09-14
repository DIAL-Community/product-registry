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

function triggerPageEvents() {
  var action = $('#main-body').attr("data-action");
  var controller = $('#main-body').attr("data-controller");
  if (controller) {
    $(document).trigger(controller + ':loaded');
    if (action) {
      $(document).trigger(controller + '#' + action + ':loaded');
    }
  }

  $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
  $('[data-toggle="popover"]').popover();

  $(document).on('click', function (e) {
    $('[data-toggle="popover"],[data-original-title]').each(function () {
        //the 'is' for buttons that trigger popups
        //the 'has' for icons within a button that triggers a popup
        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {                
            (($(this).popover('hide').data('bs.popover')||{}).inState||{}).click = false  // fix for BS 3.3.6
        }

    });
  });
  
  $('.accordion').accordion({
    heightStyle: "content",
    active:false,
    collapsible: true,
    icons: false,
    header:"div.accordion-header",
    create: function(event, ui) {
      //get index in cookie on accordion create event
      var cookie_name = $(this).attr('id')
      if(Cookies.get(cookie_name) != null){
        $(this).accordion( "option", "animate", false );
        $(this).accordion("option", "active", parseInt(Cookies.get(cookie_name)));
        $(this).accordion( "option", "animate", 200 );
      }
    },
    activate: function(event, ui) {
        //set cookie for current index on change event
        var cookie_name = $(this).attr('id')
        Cookies.set(cookie_name, null);
        if (ui.newHeader.length) {
            var index = $(this).accordion('option', 'active');
            Cookies.set(cookie_name, index);
        }
    }
  });

  $('.dropdown-menu a.dropdown-toggle').unbind('click');
  $('.dropdown-menu a.dropdown-toggle').on('click', function(e) {
    if (!$(this).next().hasClass('show')) {
      $(this).parents('.dropdown-menu').first().find('.show').removeClass('show');
    }

    var $subMenu = $(this).next('.dropdown-menu');
    $subMenu.css({ 'left': `-${$subMenu.width()}px`});
    $subMenu.toggleClass('show');

    $(this).parents('li.nav-item.dropdown.show').on('hidden.bs.dropdown', function(e) {
      $('.dropdown-submenu .show').removeClass('show');
    });
  
    return false;
  });
}

$(document).on("turbolinks:load", triggerPageEvents);

const fixPopover = function() {
  $('[data-toggle="tooltip"]').tooltip({ trigger: "hover" });
  $('[data-toggle="popover"]').popover();

  $(document).on('click', function (e) {
    $('[data-toggle="popover"],[data-original-title]').each(function () {
        //the 'is' for buttons that trigger popups
        //the 'has' for icons within a button that triggers a popup
        if (!$(this).is(e.target) && $(this).has(e.target).length === 0 && $('.popover').has(e.target).length === 0) {                
            (($(this).popover('hide').data('bs.popover')||{}).inState||{}).click = false  // fix for BS 3.3.6
        }

    });
  });
}

/*
 * Function to animate elements matched by the selector.
 */
const animateCss = function(selector, animationName, callback) {
  $(selector).addClass(`animated ${animationName}`);

  const handleAnimationEnd = function() {
    $(selector).removeClass(`animated ${animationName}`);
    $(selector).off('animationend');

    if (typeof callback === 'function') callback();
  }

  $(selector).on('animationend', handleAnimationEnd);
}

$(document).on("infinite-scroll", fixPopover);
