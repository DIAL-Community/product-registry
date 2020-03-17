const updatePortalView = function() {
  $('.portal-switcher').click(function(event) {
    event.preventDefault();
    const portalId = $(this).attr('data-portal');
    $.post(`/portal_views/${portalId}/select`, function(data) {
      location.reload(true);
    });
  })
}

$(document).on("turbolinks:load", updatePortalView);
