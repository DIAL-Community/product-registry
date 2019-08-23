var refreshUiElement = function() {
    $.getJSON('/organizations/count', function(data){
        $('#organization-count').html(data)
    });
}

var addToList = function(filterId, values) {
    if (filterId == "endorser_only") {
        $("#"+filterId).prop("checked", value == 't' ? true : false);
    } else {
        values.map(function(currValue) {
            $("#"+filterId).parent().append(
              '<div class="card col-12 mt-1">' +
                '<div class="row">' +
                  '<div class="col-11 pt-1 pb-1 pl-2">' +
                    currValue.label +
                  '</div>' +
                  '<div data-effect="fadeOut" class="col-1 text-center p-1 remove-filter">' +
                    '<i class="fas fa-window-close"></i>' +
                  '</div>' +
                '</div>' +
              '</div>')
            $(".remove-filter").on('click', {id: filterId, value: currValue.value, label: currValue.label}, removeFilter)
        })
    }
    
}

var removeFilter = function(event) {
    $.post('/remove_filter', { filter_array: [ {
        filter_name: event.data.id,
        filter_value: event.data.value,
        filter_label: event.data.label
    } ] }, function() {
        const card = $(event.target).closest('.card');
        card.fadeOut();
        
        window.location.reload(true);
    });
    
}

var addFilter = function(id, value, label) {
    $.post('/add_filter', {
        filter_name: id,
        filter_value: value,
        filter_label: label
    }, function (data) {
        if (data) {
          var newFilter = [];
          newFilter.push({value: value, label: label})
          addToList(id, newFilter);
        }
        window.location.reload(true);
    });
}

var prepareFilters = function() {

    $('.filter-element').change(function() {
        var id = $(this).attr('id');
        var val;
        var label;
        if ($(this).is(':checkbox')) {
            val = $(this).is(":checked");
        } else {
            val = $(this).children("option:selected").val();
            label = $(this).children("option:selected").text();
        }
        
        addFilter(id, val, label)
    });

    $('.clear-all').on('click', function() {
        filterList = [];
        $(this).parent().parent().find('.remove-filter').each(function(index) {
            // collect all of the filters to remove
            filterId = $(this).attr('id').split('-');
            filterLabel = $(this).attr('name');
            currFilter = { filter_name: filterId[1], filter_value: filterId[2], filter_label: filterLabel }
            filterList.push(currFilter);
        });

        if (filterList.length > 0) {
            $.post('/remove_filter', { filter_array: filterList }, function() {
                window.location.reload(true);
            });
        }
    });

    // Get all filters and add to List
    $.get('/get_filters', function (data) {
        Object.keys(data).map(function(key) {
            addToList(key, data[key]);
        })
        
    });
}

$(document).on('organizations#view:loaded', refreshUiElement);
$(document).ready(prepareFilters);
