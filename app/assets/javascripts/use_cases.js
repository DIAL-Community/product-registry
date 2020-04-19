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

// Attach all of them to the browser, page, and turbolinks event.
$(document).on('use_cases#new:loaded', useCasesReady);
$(document).on('use_cases#edit:loaded', useCasesReady);
