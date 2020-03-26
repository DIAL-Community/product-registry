
let currentlyLoadingProject = false;
const scrollHandlerProject = function() {
  $(window).on('scroll', function() {
    const currentPage = $('#project-list').attr('data-current-page');
    const url = `${window.location.pathname}?page=${parseInt(currentPage) + 1}`;
    const shouldExecuteXhr = $(window).scrollTop() > $(document).height() - $(window).height() - 400; 
    if (!currentlyLoadingProject && shouldExecuteXhr) {
      currentlyLoadingProject = true;
      $.getScript(url, function() {
        $('#project-list').attr('data-current-page', parseInt(currentPage) + 1);
        currentlyLoadingProject = false;
      });
    }
  });
}

$(document).on('projects#index:loaded', scrollHandlerProject);
