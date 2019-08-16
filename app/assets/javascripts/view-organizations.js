var refreshUiElement = function() {
    $.getJSON('/organizations/count', function(data){
        $('#organization-count').html(data)
    });

    $.getJSON('/organizations/all_filters', function(data) {
        data['years'].forEach(function(year) {
            addYear(year)
        });
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

var addYear = function(label) {
    var copy = $('#base-selected-years').clone();

    $(copy).removeAttr("id");
    $(copy).find("p").html(label);

    $(copy).appendTo($("#base-selected-years").parent());
    $(copy).show();
}

var yearSelected = function(label) {
    $.post('/organizations/add_filter', {
        filter_name: 'years',
        filter_value: label
    }, function () {
        addYear(label);
    })
}

var prepareFilters = function() {
    var years = [];
    var date = new Date();
    var year = date.getFullYear();
    while(year > 2014) {
        years.push(year.toString());
        year --;
    }

    $('#base-selected-years').hide();
    $('#year-search').autocomplete({
        source: years,
        select: function(event, ui) {
            yearSelected(ui.item.label);
            $(this).val("");
            return false;
        }
    });
}

$(document).on('organizations#view:loaded', refreshUiElement);
$(document).on('organizations#view:loaded', applyFilter);
$(document).on('organizations#view:loaded', prepareFilters);
