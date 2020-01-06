const customAutocomplete = function (source, callback) {
  return {
    minLength: 2,
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
      $(this).val(ui.item.label);
      return false;
    }
  }
}

const psProductAutocomplete = function() {
  const productAutoComplete = customAutocomplete("/products.json?without_paging=true&with_version=true", psVersionAutocomplete);
  $("#ps-product-version").hide();
  $("#ps-selected-versions").hide();
  $("#ps-product-search").autocomplete(productAutoComplete);

  $("#ps-product-version-selection").change(function() {
    const label = `${$("#ps-product-search").val()} ${$(this).find("option:selected").text()}`;
    const value = $(this).val();
    appendVersions(value, label);
  
    $("#ps-product-search").val("");
    $("#ps-product-version-selection").empty();
    $("#ps-product-version").hide();
  });
}

const psVersionAutocomplete = function(id, label) {
  $("#ps-product-version").show();
  $("#ps-product-version-selection").empty();
  $.getJSON(
    `/products/${id}.json`,
    function(product) {
      const emptyOption = new Option('Available versions', -1);
      $("#ps-product-version-selection").append(emptyOption);

      product.product_versions.forEach(function(product_version) {
        const option = new Option(product_version.version, product_version.id);
        $(option).html(product_version.version);
        $("#ps-product-version-selection").append(option);
      });
    }
  );
}

const appendVersions = function (value, label) {
  var copy = $("#ps-selected-versions").clone();

  $(copy).removeAttr("id");
  $(copy).find(".text-label").html(label);

  var input = $(copy).find("input");
  $(input).attr("name",  `selected_versions[${value}]`);
  $(input).val(value);

  $(copy).appendTo($("#ps-selected-versions").parent());

  $(copy).show();
}

$(document).on("product_suites#new:loaded", psProductAutocomplete);
$(document).on("product_suites#edit:loaded", psProductAutocomplete);