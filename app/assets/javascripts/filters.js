var refreshUiElement = function() {
    $.getJSON('/organizations/count', function(data){
        $('#organization-count').html(data)
    });
}

var applyFilter = function() {
    $('#apply-filter').click(function() {
        window.location.reload(true);
    });

    $('#clear-filter').click(function() {
        $.post('/remove_filter', {
            filter_name: 'years'
        }, function() {
            window.location.reload(true);
        });
    })
}

var addToList = function(filterId, value) {
    if (filterId == "endorser_only") {
        $("#"+filterId).prop( "checked", value == 't' ? true : false );
    } else {
        value.map(function(currValue) {
            $("#"+filterId).parent().append('<div class="card col-md-5 mt-1"><div class="row"><div class="col-md-9">'+currValue+'</div><div id="remove-'+filterId+currValue+'" class="col-md-2 p-0"><i class="fas fa-window-close"></i></div></div></div>')
            $("#remove-"+filterId+currValue).on('click', {id: filterId, value: currValue}, removeFilter)
        })
    }
    
}

var removeFilter = function(event) {
    $.post('/remove_filter', {
        filter_name: event.data.id,
        filter_value: event.data.value
    }, function() {
        window.location.reload(true);
    });
    
}

var addFilter = function(id, value) {
    $.post('/add_filter', {
        filter_name: id,
        filter_value: value
    }, function (data, status, xhr) {
        if (data) {
            addToList(id, value);
            window.location.reload(true);
        }
    })
}

var prepareFilters = function() {

    $('.filter-element').change(function() {
        var id = $(this).attr('id');
        var val;
        if ($(this).is(':checkbox')) {
            val = $(this).is(":checked");
        } else {
            val = $(this).val();
        }
        
        addFilter(id, val)
    });

    // Get all filters and add to List
    $.get('/get_filters', function (data) {
        Object.keys(data).map(function(key) {
            addToList(key, data[key]);
        })
        
    })
}

$(document).on('organizations#view:loaded', refreshUiElement);
$(document).on('organizations#view:loaded', applyFilter);
$(document).ready(prepareFilters);
