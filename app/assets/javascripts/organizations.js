function addSector(value, label) {
  addElement("base-selected-sectors", "selected_sectors", value, label);
}

function addLocation(value, label) {
  addElement("base-selected-countries", "selected_countries", value, label);
}

function addContact(value, label) {
  addElement("base-selected-contacts", "selected_contacts", value, label);
}

function addProject(value, label) {
  addElement("base-selected-projects", "selected_projects", value, label);
}

var setupAutoComplete = function() {
  var productAutoComplete = autoComplete("/products.json?without_paging=true", addProduct)
  $('#base-selected-products').hide();
  $("#product-search").autocomplete(productAutoComplete);

  // Init the autocomplete for the sector field.
  var sectorAutoComplete = sectorCustomAutoComplete("/sectors.json?without_paging=true", addSector);
  $('#base-selected-sectors').hide();
  $("#sector-search").autocomplete(sectorAutoComplete)
                     .focus(function() {
                       $(this).data("uiAutocomplete").search($(this).val());
                      });

  // Init the autocomplete for the country field.
  var countryAutoComplete = autoComplete("/locations.json?without_paging=true", addLocation)
  $('#base-selected-countries').hide();
  $("#country-search").autocomplete(countryAutoComplete);

  // Init the autocomplete for the country field.
  var projectAutoComplete = autoComplete("/projects.json?without_paging=true", addProject)
  $('#base-selected-projects').hide();
  $("#project-search").autocomplete(projectAutoComplete);
}

function sectorCustomAutoComplete(source, callback) {
  return {
    minLength: 0,
    maxShowItems: 8,
    source: function(request, response) {
      $.getJSON(
        source, {
          search: request.term
        },
        function(responses) {
          response($.map(responses, function(response) {
            return {
              id: response.id,
              label: response.name,
              value: response.name
            }
          }));
        }
      );
    },
    select: function(event, ui) {
      callback(ui.item.id, ui.item.label);
      $(this).blur();
      $(this).val("");
      return false;
    }
  }
}

function addOffice(label, officeId, magicKey) {
  var copy = $("#base-selected-offices").clone();

  $(copy).removeAttr("id");
  $(copy).find(".text-label").html(label);

  if (officeId) {
    var input = $(copy).find("input").first();
    $(input).attr("name",  "office_ids[" + officeId + "]");
    $(input).val(officeId);
  }

  if (magicKey) {
    var input = $(copy).find("input").last();
    $(input).attr("name",  "office_magickeys[" + magicKey + "]");
    $(input).val(magicKey);
  }
  
  $(copy).appendTo($("#base-selected-offices").parent());

  $(copy).show();
}

function sourceHandle(request, response) {
  $.getJSON(
    "/locations.json?office_only=true", {
      search: request.term
    },
    function(sectors) {
      if (sectors.length <= 0) {
        $.getJSON(
          esri_api, {
            f: 'json',
            category: 'City',
            maxSuggestions: 10,
            text: request.term
          },
          function(data) {
            response($.map(data.suggestions, function(city) {
              return {
                id: null,
                label: city.text,
                value: city.text,
                magicKey: city.magicKey
              }
            }));
          });
      }
      response($.map(sectors, function(sector) {
        return {
          id: sector.id,
          label: sector.name,
          value: sector.name,
          magicKey: null
        }
      }));
    }
  );
}

var setupFormView = function() {
  // Init the datepicker field.
  $('#organization_when_endorsed').datepicker();
  
  $('.custom-file-input').on('change', function () {
    var fileName = $(this).val().split('\\').pop();
    $(this).next('.custom-file-label').html(fileName);
  });

  $("#base-selected-offices").hide();
  $("#office-label").autocomplete({
    source: sourceHandle,
    select: function(event, ui) {
      addOffice(ui.item.label, ui.item.id, ui.item.magicKey)
      $(this).val("")
      return false;
    }
  });

  $("button.add-other-name").click(function(event) {
    event.preventDefault();
    addOtherName();
  });

  $("button.remove-other-name").click(function(event) {
    event.preventDefault();
    removeOtherName(event.target);
  });
};

var editServices = function (e) {
  var country_service = e.currentTarget.id.split('_')
  var orgId=$("#orgId").text()

  $.get("/service_capabilities?country="+country_service[0]+"&service="+country_service[1], function(data) {
    var capabilityList = data.capability_list
    var operatorList = data.operator_list

    elementsToCheck = []
    $.get("/agg_capabilities?country="+country_service[0]+"&service="+country_service[1]+"&org="+orgId, function (data) {
      if (data.length == 0) {
        data = []
        operatorList.map(function(currOperator) {
          data.push({"name":currOperator.name, "id":currOperator.id, "capabilities": []})
        })
      }
    
      var newHtml = "<div class='mni-accordion'>"
      data.map(function(currService) {
        newHtml += "<h3 class='country-service'>"+currService.name+"</h3>"
        newHtml += "<div>"
        // Get all capabilities per service
        capabilityList.map(function(currCapability) {
          var elementId = orgId+"_"+country_service[0]+"_"+country_service[1]+"_"+currService.id+"_"+currCapability.replace(/\s+/g, '-')
          newHtml += "<input id='"+elementId+"' class='capability_checkbox' type='checkbox'>"+currCapability+"<br></br>"
        })
        currService.capabilities.map(function(currCap) {
          var elementId = orgId+"_"+country_service[0]+"_"+country_service[1]+"_"+currService.id+"_"+currCap.replace(/\s+/g, '-')
          elementsToCheck.push(elementId)
        })
        newHtml += "</div>"
      });
      newHtml += "</div>"
      $("#"+e.currentTarget.id).next(".capability").empty()
      $("#"+e.currentTarget.id).next(".capability").append(newHtml)
      elementsToCheck.map(function(elementId) {
        $("#"+elementId).prop('checked', true);
      })
      $("#"+e.currentTarget.id).next(".capability").find(".mni-accordion").accordion(
        {
          collapsible: true,
          active: false,
          autoHeight:false,
          heightStyle: "content",
          animate: false
        }
      )
      $('.capability_checkbox').change(function() {
        serviceData = this.id.split('_')
        // serviceData is orgId, countryId, core_service, operator, capability
        $.get("/update_capability?orgId="+serviceData[0]+"&country="+serviceData[1]+"&service="+serviceData[2]+"&operator="+serviceData[3]+"&capability="+serviceData[4]+"&checked="+this.checked, function (data) {

        })
      })
    })
  })
  }

var lookupServices = function (e) {
  var country_service = e.currentTarget.id.split('_')
  var orgId=$("#orgId").text()
  $.get("/agg_capabilities?country="+country_service[0]+"&service="+country_service[1]+"&org="+orgId, function (data) {
      if (data.length == 0)
        return
      newHtml = "<div class='mni-accordion'>"
      data.map(function(currService) {
        newHtml += "<h3 class='country-service'>"+currService.name+"</h3>"
        newHtml += "<div>"
        currService.capabilities.map(function(currCap) {
          newHtml += "<input type='checkbox' disabled checked>"+currCap+"<br></br>"
        });
        newHtml += "</div>"
      });
      newHtml += "</div>"
      $("#"+e.currentTarget.id).next(".capability").empty()
      $("#"+e.currentTarget.id).next(".capability").append(newHtml)
      $("#"+e.currentTarget.id).next(".capability").find(".mni-accordion").accordion(
        {
          collapsible: true,
          active: false,
          autoHeight:false,
          heightStyle: "content",
          animate: false
        }
      )
    })
  }

var setUpAggregatorsView = function() {
  setUpAggregators(false)
}

var setUpAggregatorsEdit = function() {
  setUpAggregators(true)
}

var setUpAggregators = function(isEdit) {
  $(".mni-accordion").accordion({
    collapsible: true,
    active: false,
    autoHeight:false,
    heightStyle: "content",
    animate: false
  });
  var icons = $(".mni-accordion").accordion("option", "icons");
  
  $('.ui-accordion-header').click(function () {
    $('.open').removeAttr("disabled");
    $('.close').removeAttr("disabled");
  });

  $('.country-list').click(function (e) {
    var country = e.currentTarget.id
    var orgId=$("#orgId").text()
    $.get("/agg_services?country="+country+"&org="+orgId, function (data) {
      if (data.length == 0)
        return
      $("#"+e.currentTarget.id).next().empty()
      newHtml = "<div><div class='mni-accordion'>"
      data.map(function(currService) {
        newHtml += "<h3 class='country-service' id='"+country+"_"+currService.name+"'>"+currService.name
        if (currService.count > 0) {
          newHtml += "<span class='badge badge-light agg-badge'>"+currService.count+"</span>"
        }
        newHtml += "</h3><div class='capability'></div>"
      })
      newHtml += "</div></div>"
      $("#"+e.currentTarget.id).next().append(newHtml)

      $("#"+e.currentTarget.id).next().find(".mni-accordion").accordion(
        {
          collapsible: true,
          active: false,
          autoHeight:false,
          heightStyle: "content",
          animate: false
        }
      )
      if (isEdit) {
        $('.country-service').click(editServices);
      } else {
        $('.country-service').click(lookupServices); 
      }
    })
  });
}

let currentlyLoadingOrgs = false;
const scrollHandlerOrg = function() {
  const removeClasses = function() {
    $('.existing-org').removeClass('existing-org');
    $('.to-be-animated').removeClass('to-be-animated');
  }

  $(window).on('scroll', function() {
    const currentPage = $('#organization-list').attr('data-current-page');
    
    let url = `${window.location.pathname}?page=${parseInt(currentPage) + 1}`;

    const searchTerm = $('#search-organizations').val();
    if (searchTerm) {
      url = `${url}&search=${searchTerm}`
    }

    const shouldExecuteXhr = $(window).scrollTop() > $(document).height() - $(window).height() - 600; 
    if (!isNaN(currentPage) && !currentlyLoadingOrgs && shouldExecuteXhr) {
      currentlyLoadingOrgs = true;
      $('#organization-list > div').addClass('existing-org');
      $.getScript(url, function() {
        $('#organization-list').attr('data-current-page', parseInt(currentPage) + 1);
        animateCss('.to-be-animated', 'fadeIn', removeClasses);
        currentlyLoadingOrgs = false;
      });
    }
  });
}

let currentlySearchingOrgs = false;
const searchFilterHandler = function() {
  const hideElements = function() {
    $('.existing-org').remove();
  }

  const removeClasses = function() {
    $('.to-be-animated').removeClass('to-be-animated');
  }

  let previousSearchTerm = '';
  const searchWithAnimation = function() {
    const searchTerm = $('#search-organizations').val();
    const url = `${window.location.pathname}?search=${searchTerm}`;
    if (!currentlySearchingOrgs && previousSearchTerm !== searchTerm) {
      $('#organization-list > div').addClass('existing-org');
      animateCss('.existing-org', 'fadeOut faster', hideElements);

      currentlySearchingOrgs = true;
      $.getScript(url, function() {
        $('#organization-list').attr('data-current-page', 1);
        animateCss('.to-be-animated', 'fadeIn faster', removeClasses);

        previousSearchTerm = searchTerm;
        currentlySearchingOrgs = false;
      });
    }
  }

  $('#search-organizations').keyup(delay(searchWithAnimation, 400));
}

$(document).on('organizations#new:loaded', setupFormView);
$(document).on('organizations#edit:loaded', setupFormView);

$(document).on('organizations#new:loaded', setupAutoComplete);
$(document).on('organizations#edit:loaded', setupAutoComplete);

$(document).on('organizations#show:loaded', setUpAggregatorsView);
$(document).on('organizations#edit:loaded', setUpAggregatorsEdit);

$(document).on('organizations#index:loaded', scrollHandlerOrg);
$(document).on('organizations#index:loaded', searchFilterHandler);
