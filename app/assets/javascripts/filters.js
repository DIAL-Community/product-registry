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
  if ((filterId == "products") || (filterId == "with_maturity_assessment")) {
    filterId = "origins"
  }
  if (filterId == "endorser_only") {
    filterId = "years"
  }
  currVal = parseInt($("#accordian-"+filterId+"-count").html())
  if (!currVal) {
    currVal = 0
  }
  $("#accordian-"+filterId+"-count").html(currVal+1)
}

var decrementFilterCount = function(filterId) {
  if ((filterId == "products") || (filterId == "with_maturity_assessment")) {
    filterId = "origins"
  }
  if (filterId == "endorser_only") {
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
  if ((filterId == "products") || (filterId == "with_maturity_assessment")) {
    filterId = "origins"
  }
  if (filterId == "endorser_only") {
    filterId = "years"
  }
  $("#accordian-"+filterId+"-count").html("")
}

var clearFilterItems = function(filterId) {
  if (filterId == 'with_maturity_assessment') {
    $('#with_maturity_assessment').prop('checked', false);
  } else if (filterId == 'endorser_only') {
    $('#endorser_only').prop('checked', false);
  } else {
    $('#' + filterId).parents(".row").next('.row').find('.badges').remove()
  }
}

var removeFilter = function(event) {
    $.post('/remove_filter', { filter_array: [ {
        filter_name: event.data.id,
        filter_value: event.data.value,
        filter_label: event.data.label
    } ] }, function() {
        const card = $(event.target).closest('.badge');
        card.fadeOut();
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

var loadFilters = function() {
  // Get all filters and add to List
  $.get('/get_filters', function (data) {
    Object.keys(data).map(function(key) {
        addToList(key, data[key]);
    })
  });
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
        filter_array.push({filter_name: 'endorser_only'})
        $('#endorser_only').prop('checked', false);
      } else if (filter_name == 'products') {
        filter_array.push({filter_name: 'origins'})
        filter_array.push({filter_name: 'products'})
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

    loadFilters();
}

$(document).on('sustainable_development_goals#index:loaded', prepareFilters);
$(document).on('use_cases#index:loaded', prepareFilters);
$(document).on('workflows#index:loaded', prepareFilters);
$(document).on('building_blocks#index:loaded', prepareFilters);
$(document).on('products#index:loaded', prepareFilters);
$(document).on('organizations#index:loaded', prepareFilters);
