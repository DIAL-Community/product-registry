var addToList = function(filterId, values) {
    if (!Array.isArray(values)) {
      $("#"+filterId).prop("checked", values.value === 'true');
    } else {
      values.map(function(currValue) {
        if (currValue.value) {
          $('#' + filterId).parents(".row").next('.row').find('.badges').append(
            '<span class="badge badge-secondary filter-tag">' +
            currValue.label +
            '<i name="' + currValue.label + '" id="remove-' + filterId + '-' + currValue.value + '" class="fas fa-window-close remove-filter"></i>' +
            '</span>'
          );
          $('#remove-'+filterId+'-'+currValue.value).on('click', {id: filterId, value: currValue.value, label: currValue.label}, removeFilter)
        }
      });
    }
}

var incrementFilterCount = function(filterId) {
  if ($.inArray(filterId, ["products", "with_maturity_assessment", "is_launchable", "tags", "product_type"]) !== -1) {
    filterId = "origins"
  }
  if (filterId == "endorser_only" || filterId == "aggregator_only") {
    filterId = "years"
  }
  currVal = parseInt($("#accordian-"+filterId+"-count").html())
  if (!currVal) {
    currVal = 0
  }
  $("#accordian-"+filterId+"-count").html(currVal+1)
}

var decrementFilterCount = function(filterId) {
  if ($.inArray(filterId, ["products", "with_maturity_assessment", "is_launchable", "tags", "product_type"]) !== -1) {
    filterId = "origins"
  }
  if (filterId == "organizations" || filterId == "endorser_only" || filterId == "aggregator_only") {
    filterId = "years"
  }
  currVal = parseInt($("#accordian-"+filterId+"-count").html())
  if (currVal == 1) {
    $("#accordian-"+filterId+"-count").html("")
  } else {
    $("#accordian-"+filterId+"-count").html(currVal-1)
  }
}

var clearFilterCount = function(filterId) {
  if ($.inArray(filterId, ["products", "with_maturity_assessment", "is_launchable", "tags", "product_type"]) !== -1) {
    filterId = "origins"
  }
  if (filterId == "organizations" || filterId == "endorser_only" || filterId == "aggregator_only") {
    filterId = "years"
  }
  $("#accordian-"+filterId+"-count").html("")
}

var clearFilterItems = function(filterId) {
  if (filterId == 'with_maturity_assessment') {
    $('#with_maturity_assessment').prop('checked', false);
  } else if (filterId == 'endorser_only') {
    $('#endorser_only').prop('checked', false);
  } else if (filterId == 'aggregator_only') {
    $('#aggregator_only').prop('checked', false);
  } else if (filterId == 'is_launchable') {
    $('#is_launchable').prop('checked', false);
  } else {
    $('#' + filterId).parents(".row").next('.row').find('.badge').remove()
  }
}

var removeFilter = function(event) {
    $.post('/remove_filter', { filter_array: [ {
        filter_name: event.data.id,
        filter_value: event.data.value,
        filter_label: event.data.label
    } ] }, function() {
        const card = $(event.target).closest('.badge');
        card.fadeOut("slow", function() {
          $(this).remove();
        });
        updateCount();
        decrementFilterCount(event.data.id)
        loadMainDiv();
    });

}

var addFilter = function(id, value, label) {
  if (value && !$('#remove-' + id + '-' + value).length) {
    $.post('/add_filter', {
        filter_name: id,
        filter_value: value,
        filter_label: label
    }, function () {
        updateCount();
        currValue = [{ value: value, label: label }]
        addToList(id, currValue)
        incrementFilterCount(id)
        loadMainDiv();
    });
  }
  $('#' + id).val('');
}

const addFilters = function(filters) {
  $.post('/add_filters',
    { filters: filters },
    function () {
      updateCount();
      loadMainDiv();
      $.each(filters, function(_index, filter) {
        var currValue = [{ value: filter['filter_value'], label: filter['filter_label'] }];
        if (filter['filter_label'] === '') {
          currValue = { value: filter['filter_value'] };
        }
        addToList(filter['filter_name'], currValue);
        incrementFilterCount(filter['filter_name']);
      });
    }
  );
}

var getUrlParams = function()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars[hash[0]] = hash[1];
    }
    return vars;
}

var loadFilters = function() {
  // Check to see if filters are passed on URL. If so, set them in session
  urlParams = getUrlParams()
  if (urlParams.urlFilter) {
    delete urlParams['urlFilter']
    $.post('/remove_all_filters', { }, function() {
      const filters = []
      Object.keys(urlParams).map(function(urlParam) {
        clearFilterCount(urlParam)
        if (urlParam == 'use_cases' || urlParam == 'workflows' || urlParam == 'building_blocks' || urlParam === 'tags' ||
            urlParam == 'sdgs' || urlParam == 'products' || urlParam == 'years' || urlParam == 'origins') {
          paramValues = urlParams[urlParam].split('--')
          paramValues.map(function(paramValue) {
            paramValueLabel = paramValue.split('-')
            filters.push({
              filter_name: urlParam,
              filter_value: paramValueLabel[0],
              filter_label: decodeURIComponent(paramValueLabel[1])
            });
          })
        } else {
          filters.push({
            filter_name: urlParam,
            filter_value: urlParams[urlParam],
            filter_label: ''
          });
        }
      });
      addFilters(filters);
    })
  } else {
    // Get all filters and add to List
    $.get('/get_filters', function (data) {
      Object.keys(data).map(function(key) {
          addToList(key, data[key]);
      })
    });
  }
}

var loadMainDiv = function() {
  $.get(window.location.pathname, function (data) {
    var tempDom = $('<div>').append($.parseHTML(data));
    var currentList = $('#current-list', tempDom);
    var activeFilter = $('#active-filter', tempDom)
    $("#current-list").replaceWith(currentList)
    $("#active-filter").replaceWith(activeFilter)
    removeFilterHandler();
  });
}

var addProductFilter = function(value, label) {
  var id = 'products';
  addFilter(id, value, label);
}

var addOrganizationFilter = function(value, label) {
  var id = 'organizations';
  addFilter(id, value, label);
}

var addProjectFilter = function(value, label) {
  var id = 'projects';
  addFilter(id, value, label);
}

var addTagFilter = function(value, label) {
  var id = 'tags';
  addFilter(id, label, label);
}

var prepareFilters = function() {
    $('.filter-element').change(function() {
        var id = $(this).attr('id');
        if ($(this).is(':checkbox')) {
            $(this).is(":checked") ? addFilter(id, true) : removeFilter({data: {id: id}});
        } else {
            var val = $(this).children("option:selected").val();
            var label = $(this).children("option:selected").text();
            addFilter(id, val, label)
        }
    });

    $('.clear-all').on('click', function(e) {
      e.preventDefault();
      filterId = $(this).attr('id').split('-');
      const filter_name = filterId[1];
      $(this).parent().parent().find('.remove-filter').each(function(index, elem) {
        const card = $(elem).closest('.badge');
        card.remove();
      });
      clearFilterCount(filterId[1])
      filter_array = []
      if (filter_name == 'organizations') {
        filter_array.push({filter_name: 'years'})
        filter_array.push({filter_name: 'organizations'})
        filter_array.push({filter_name: 'endorser_only'})
        $('#endorser_only').prop('checked', false);
        filter_array.push({filter_name: 'aggregator_only'})
        $('#aggregator_only').prop('checked', false);
      } else if (filter_name == 'products') {
        filter_array.push({filter_name: 'tags'})
        filter_array.push({filter_name: 'origins'})
        filter_array.push({filter_name: 'products'})
        filter_array.push({filter_name: 'product_type'})
        filter_array.push({filter_name: 'is_launchable'})
        $('#is_launchable').prop('checked', false);
        filter_array.push({filter_name: 'with_maturity_assessment'})
        $('#with_maturity_assessment').prop('checked', false);
      } else {
        filter_array.push({filter_name: filter_name})
      }
      $.post('/remove_filter', {
        filter_array: filter_array
      }, function() {
        updateCount();
        loadMainDiv();
      });
    });

    var productAutoComplete = autoComplete("/products.json?without_paging=true", addProductFilter)
    $("#products").autocomplete(productAutoComplete);

    var organizationAutoComplete = autoComplete("/organizations.json?without_paging=true", addOrganizationFilter)
    $("#organizations").autocomplete(organizationAutoComplete);

    var projectAutoComplete = autoComplete("/projects.json?without_paging=true", addProjectFilter)
    $("#projects").autocomplete(projectAutoComplete);

    const tagAutoComplete = autoComplete("/tags.json?without_paging=true", addTagFilter)
    $("#tags").autocomplete(tagAutoComplete);
    $("#projTags").autocomplete(tagAutoComplete);

    loadFilters();
}

$(document).on('sustainable_development_goals#index:loaded', prepareFilters);
$(document).on('use_cases#index:loaded', prepareFilters);
$(document).on('workflows#index:loaded', prepareFilters);
$(document).on('building_blocks#index:loaded', prepareFilters);
$(document).on('products#index:loaded', prepareFilters);
$(document).on('organizations#index:loaded', prepareFilters);
$(document).on('projects#index:loaded', prepareFilters);
$(document).on('playbooks#index:loaded', prepareFilters);
$(document).on('plays#index:loaded', prepareFilters);
