function tagUseCase(value, label) {
  const copy = $("#base-selected-tags").clone();

  $(copy).removeAttr("id");
  $(copy).find(".text-label").html(label);

  const input = $(copy).find("input");
  $(input).attr("name",  "use_case_tags[]");
  $(input).val(label);

  $(copy).appendTo($("#base-selected-tags").parent());

  $(copy).show();
}

const useCasesReady = function() {
  const tagAutoComplete = autoComplete("/tags.json?without_paging=true", tagUseCase)
  $("#base-selected-tags").hide();
  $("#tag-search").autocomplete(tagAutoComplete);
}

const useCaseIndexReady = function() {
  const removeElements = function() {
    $('.existing-use-case').remove();
  }

  const removeClasses = function() {
    $('.to-be-animated').removeClass('to-be-animated');
  }

  const filterMatureWithAnimation = function() {
    const checked = $('#mature-only').prop("checked");
    const url = `${window.location.pathname}?mature=${checked}`;
    
    $('#current-list > div').addClass('existing-use-case');
    animateCss('.existing-use-case', 'fadeOut faster', removeElements);
    
    $.getScript(url, function() {
      $('#current-list').attr('data-current-page', 1);
      animateCss('.to-be-animated', 'fadeIn faster', removeClasses);
    });
  }

  $('#mature-only').change(filterMatureWithAnimation);
}

// Attach all of them to the browser, page, and turbolinks event.
$(document).on('use_cases#new:loaded', useCasesReady);
$(document).on('use_cases#edit:loaded', useCasesReady);
$(document).on('use_cases#index:loaded', useCaseIndexReady);
