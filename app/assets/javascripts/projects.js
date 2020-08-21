
let currentlyLoadingProject = false;
const scrollHandlerProject = function() {
  $(window).on('scroll', function() {
    const currentPage = $('#project-list').attr('data-current-page');
    const url = `${window.location.pathname}?page=${parseInt(currentPage) + 1}`;
    const shouldExecuteXhr = $(window).scrollTop() > $(document).height() - $(window).height() - 600; 
    if (!isNaN(currentPage) && !currentlyLoadingProject && shouldExecuteXhr) {
      currentlyLoadingProject = true;
      $.getScript(url, function() {
        $('#project-list').attr('data-current-page', parseInt(currentPage) + 1);
        currentlyLoadingProject = false;
      });
    }
  });
}

const projectsReady = function() {
  // Init the autocomplete for the country field.
  var countryAutoComplete = autoComplete("/countries.json?without_paging=true", addLocation)
  $('#base-selected-countries').hide();
  $("#country-search").autocomplete(countryAutoComplete);
}

$(document).on('projects#index:loaded', scrollHandlerProject);
$(document).on('projects#new:loaded', projectsReady);
$(document).on('projects#edit:loaded', projectsReady);
