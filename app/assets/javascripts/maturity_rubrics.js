let currentlyLoadingRubric = false;
const scrollRubricHandler = function () {
  const removeClasses = function() {
    $('.existing-maturity-rubric').removeClass('existing-maturity-rubric');
    $('.to-be-animated').removeClass('to-be-animated');
  }

  $(window).on('scroll', function () {
    const currentPage = $('#maturity-rubric-list').attr('data-current-page');
    let url = `${window.location.pathname}?page=${parseInt(currentPage) + 1}`;

    const shouldExecuteXhr = $(window).scrollTop() > $(document).height() - $(window).height() - 50;
    if (!isNaN(currentPage) && !currentlyLoadingRubric && shouldExecuteXhr) {
      currentlyLoadingRubric = true;
      $('#maturity-rubric-list > div').addClass('existing-maturity-rubric');
      $.getScript(url, function () {
        $('#maturity-rubric-list').attr('data-current-page', parseInt(currentPage) + 1);
        animateCss('.to-be-animated', 'fadeIn', removeClasses);
        currentlyLoadingRubric = false;
      });
    }
  });
}

$(document).on('maturity_rubrics#index:loaded', scrollRubricHandler);
