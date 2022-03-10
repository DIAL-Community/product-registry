
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

function tagProject(value, label) {
  const copy = $("#base-selected-tags").clone();

  $(copy).removeAttr("id");
  $(copy).find(".text-label").html(label);

  const input = $(copy).find("input");
  $(input).attr("name",  "project_tags[]");
  $(input).val(label);

  $(copy).appendTo($("#base-selected-tags").parent());

  $(copy).show();
}

const projectsReady = function() {
  // Init the autocomplete for the country field.
  var countryAutoComplete = autoComplete("/countries.json?without_paging=true", addCountry)
  $('#base-selected-countries').hide();
  $("#country-search").autocomplete(countryAutoComplete);

  // Init the autocomplete for the tags field.
  var tagAutoComplete = autoComplete("/tags.json?without_paging=true", tagProject)
  $('#base-selected-tags').hide();
  $("#tag-search").autocomplete(tagAutoComplete);
}

$(document).on('projects#index:loaded', scrollHandlerProject);
$(document).on('projects#new:loaded', projectsReady);
$(document).on('projects#edit:loaded', projectsReady);
