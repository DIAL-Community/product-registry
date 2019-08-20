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
        $.post('/organizations/remove_filter', {
            filter_name: 'years'
        }, function() {
            window.location.reload(true);
        });
    })
}

var addToList = function(id, value) {
    var element = $("#"+id);
    element.parent.append("<div>"+value+"</div>")
}

var addFilter = function(id, value) {
    $.post('/add_filter', {
        filter_name: id,
        filter_value: value
    }, function () {
        addToList(id, value);
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

}

$(document).on('organizations#view:loaded', refreshUiElement);
$(document).on('organizations#view:loaded', applyFilter);
$(document).ready(prepareFilters);
