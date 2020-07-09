let currentlyLoadingTaskTracker = false;
const scrollTaskTrackerHandler = function () {
  const removeClasses = function() {
    $('.existing-task-tracker').removeClass('existing-task-tracker');
    $('.to-be-animated').removeClass('to-be-animated');
  }

  $(window).on('scroll', function () {
    const currentPage = $('#task-tracker-list').attr('data-current-page');
    let url = `${window.location.pathname}?page=${parseInt(currentPage) + 1}`;

    const shouldExecuteXhr = $(window).scrollTop() > $(document).height() - $(window).height() - 50;
    if (!isNaN(currentPage) && !currentlyLoadingTaskTracker && shouldExecuteXhr) {
      currentlyLoadingTaskTracker = true;
      $('#task-tracker-list > div').addClass('existing-task-tracker');
      $.getScript(url, function () {
        $('#task-tracker-list').attr('data-current-page', parseInt(currentPage) + 1);
        animateCss('.to-be-animated', 'fadeIn', removeClasses);
        currentlyLoadingTaskTracker = false;
      });
    }
  });
}

$(document).on('task_trackers#index:loaded', scrollTaskTrackerHandler);
