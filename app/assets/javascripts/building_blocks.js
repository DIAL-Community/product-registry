const buildingBlockIndexReady = function() {
  const removeElements = function() {
    $('.existing-building-block').remove();
  }

  const removeClasses = function() {
    $('.to-be-animated').removeClass('to-be-animated');
  }

  const filterMatureWithAnimation = function() {
    const checked = $('#mature-only').prop("checked");
    const url = `${window.location.pathname}?mature=${checked}`;
    
    $('#current-list > div').addClass('existing-building-block');
    animateCss('.existing-building-block', 'fadeOut faster', removeElements);
    
    $.getScript(url, function() {
      $('#current-list').attr('data-current-page', 1);
      animateCss('.to-be-animated', 'fadeIn faster', removeClasses);
    });
  }

  $('#mature-only').change(filterMatureWithAnimation);
}

$(document).on('building_blocks#index:loaded', buildingBlockIndexReady);