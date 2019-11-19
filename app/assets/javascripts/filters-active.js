const configs = {
  endorser_only: {
    text: 'Contributed to / used by endorser organizations.',
    multi: false
  },
  aggregator_only: {
    text: 'Mobile Network aggregator organizations.',
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
    updateCount();
    loadMainDiv();
    clearFilterCount(filter_name);
    clearFilterItems(filter_name)
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

const createLink = function() {
  var url = window.location.href + "?urlFilter=true&"
  $.get('/get_filters', function(filters) {
    Object.keys(filters).map(function(filterKey) {
      if (Array.isArray(filters[filterKey])) {
        url += filterKey+"="
        filters[filterKey].map(function(arrayFilter) {
          url += arrayFilter.value+"-"+arrayFilter.label+"--"
        })
        url = url.slice(0, -2); 
        url+="&"
      } else {
        url += filterKey+"="+filters[filterKey].value+"&"
      }
    })
    url = url.slice(0, -1); 
    navigator.clipboard.writeText(url).then(function() {
      $("#share-link").next().text("Link has been copied to your clipboard")
    })
  })
}

const removeFilterHandler = function() {
  $('.close-icon').click(removeActiveFilter);
  // set up handler for share link as well
  $("#share-link").on('click', function(e) {
    e.preventDefault()
    createLink();
  })
}

$(document).on('sustainable_development_goals#index:loaded', removeFilterHandler);
$(document).on('use_cases#index:loaded', removeFilterHandler);
$(document).on('workflows#index:loaded', removeFilterHandler);
$(document).on('building_blocks#index:loaded', removeFilterHandler);
$(document).on('products#index:loaded', removeFilterHandler);
$(document).on('organizations#index:loaded', removeFilterHandler);
