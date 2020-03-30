let currentlyLoading = false;
const scrollHandler = function () {
  $(window).on('scroll', function () {
    const currentPage = $('#product-list').attr('data-current-page');
    const url = `${window.location.pathname}?page=${parseInt(currentPage) + 1}`;
    const shouldExecuteXhr = $(window).scrollTop() > $(document).height() - $(window).height() - 800;
    if (!isNaN(currentPage) && !currentlyLoading && shouldExecuteXhr) {
      currentlyLoading = true;
      $.getScript(url, function () {
        $('#product-list').attr('data-current-page', parseInt(currentPage) + 1);
        currentlyLoading = false;
      });
    }
  });
}

$(document).on('products#index:loaded', scrollHandler);
