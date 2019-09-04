const configs = {
  endorser_only: {
    text: 'Contributed to / used by endorser organizations.',
    multi: false
  }
};

const removeActiveFilter = function(event) {
  const li = $(event.target).closest('li');
  const filter_name = li.attr("id");
  $.post('/remove_filter', {
    filter_array: [{
      filter_name: filter_name
    }]
  }, function() {
    $(li).fadeOut();
    window.location.reload(true);
  });
};

const activeFilter = function() {
  $("#active-filter-template").hide();
  $.get('/get_filters', function(filters) {
    for (const filter in filters) {
      if (filters.hasOwnProperty(filter)) {
        const config = configs[filter];
        const values = filters[filter];

        const clone = $("#active-filter-template").clone();
        $(clone).appendTo($("#active-filter-template").parent());
        $(clone).attr("id", filter);
        $(clone).find('.close-icon').on('click', removeActiveFilter);

        const labels = values.map((v) => `${v.value}.${v.label}`).join("', '");
        if (!config) {
          $(clone).prepend(`'${labels}'`);
        } else {
          $(clone).prepend(config.text);
        }
        $(clone).show();
      }
    }
  });
}

const removeFilterHandler = function() {
  $('.close-icon').click(removeActiveFilter);
}

$(document).on("turbolinks:load", removeFilterHandler);