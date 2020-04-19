let currentlyLoadingTags = false;
const scrollTagHandler = function () {
  const removeClasses = function() {
    $('.existing-tag').removeClass('existing-tag');
    $('.to-be-animated').removeClass('to-be-animated');
  }

  $(window).on('scroll', function () {
    const currentPage = $('#tag-list').attr('data-current-page');
    let url = `${window.location.pathname}?page=${parseInt(currentPage) + 1}`;

    const shouldExecuteXhr = $(window).scrollTop() > $(document).height() - $(window).height() - 50;
    if (!isNaN(currentPage) && !currentlyLoadingTags && shouldExecuteXhr) {
      currentlyLoadingTags = true;
      $('#tag-list > div').addClass('existing-tag');
      $.getScript(url, function () {
        $('#tag-list').attr('data-current-page', parseInt(currentPage) + 1);
        animateCss('.to-be-animated', 'fadeIn', removeClasses);
        currentlyLoadingTags = false;
      });
    }
  });
}

$(document).on('tags#index:loaded', scrollTagHandler);
