/*
 * Function to animate elements matched by the selector.
 */
const animateCss = function(selector, animationName, callback) {
  $(selector).addClass(`animated ${animationName}`);

  const handleAnimationEnd = function() {
    $(selector).removeClass(`animated ${animationName}`);
    $(selector).off('animationend');

    if (typeof callback === 'function') callback();
  }

  $(selector).on('animationend', handleAnimationEnd);
}

/*
 * Delay execution of a function for ms (milliseconds).
 * This is used in the search handler to wait until user
 * is done with entering the search term.
 */
const delay = function(fn, ms) {
  let timer = 0
  return function(...args) {
    clearTimeout(timer)
    timer = setTimeout(fn.bind(this, ...args), ms || 0)
  }
}

let currentlyLoadingProducts = false;
const scrollProductHandler = function () {
  const removeClasses = function() {
    $('.existing-product').removeClass('existing-product');
    $('.to-be-animated').removeClass('to-be-animated');
  }

  $(window).on('scroll', function () {
    const currentPage = $('#product-list').attr('data-current-page');
    let url = `${window.location.pathname}?page=${parseInt(currentPage) + 1}`;

    const searchTerm = $('#search-products').val();
    if (searchTerm) {
      url = `${url}&search=${searchTerm}`
    }

    const covidChecked = $('#covid-only').prop("checked");
    url = `${url}&covid=${covidChecked}`;

    const shouldExecuteXhr = $(window).scrollTop() > $(document).height() - $(window).height() - 800;
    if (!isNaN(currentPage) && !currentlyLoadingProducts && shouldExecuteXhr) {
      currentlyLoadingProducts = true;
      $('#product-list > div').addClass('existing-product');
      $.getScript(url, function () {
        $('#product-list').attr('data-current-page', parseInt(currentPage) + 1);
        animateCss('.to-be-animated', 'fadeIn', removeClasses);
        currentlyLoadingProducts = false;
      });
    }
  });
}

let currentlySearchingProducts = false;
const searchProductHandler = function() {
  const hideElements = function() {
    $('.existing-product').remove();
  }

  const removeClasses = function() {
    $('.to-be-animated').removeClass('to-be-animated');
  }

  let previousSearchTerm = '';
  const searchWithAnimation = function() {
    const searchTerm = $('#search-products').val();
    let url = `${window.location.pathname}?search=${searchTerm}`;

    const covidChecked = $('#covid-only').prop("checked");
    url = `${url}&covid=${covidChecked}`;

    if (!currentlySearchingProducts && previousSearchTerm !== searchTerm) {
      $('#product-list > div').addClass('existing-product');
      animateCss('.existing-product', 'fadeOut faster', hideElements);

      currentlySearchingProducts = true;
      $.getScript(url, function() {
        $('#product-list').attr('data-current-page', 1);
        animateCss('.to-be-animated', 'fadeIn faster', removeClasses);

        previousSearchTerm = searchTerm;
        currentlySearchingProducts = false;
      });
    }
  }

  $('#search-products').keyup(delay(searchWithAnimation, 400));
}

const filterCovidHandler = function() {
  const removeElements = function() {
    $('.existing-product').remove();
  }

  const removeClasses = function() {
    $('.to-be-animated').removeClass('to-be-animated');
  }

  const filterCovidWithAnimation = function() {
    const checked = $('#covid-only').prop("checked");
    const url = `${window.location.pathname}?covid=${checked}`;
    
    $('#product-list > div').addClass('existing-product');
    animateCss('.existing-product', 'fadeOut faster', removeElements);
    
    $.getScript(url, function() {
      $('#product-list').attr('data-current-page', 1);
      animateCss('.to-be-animated', 'fadeIn faster', removeClasses);
    });
  }

  $('#covid-only').change(filterCovidWithAnimation);
}

$(document).on('products#index:loaded', scrollProductHandler);
$(document).on('products#index:loaded', searchProductHandler);
$(document).on('products#index:loaded', filterCovidHandler);
