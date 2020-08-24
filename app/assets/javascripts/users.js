const changeRoleHandler = function() {
  $('#user-role-selector').change(function() {
    var value = $(this).children("option:selected").val();
    var label = $(this).children("option:selected").text();
    $(this).next('.row').find('.badges').append(
      '<span class="badge badge-secondary mr-1">' + label +
      ' <input type="hidden" name="selected_roles[]" value="' + value + '"/>' +
      ' <i class="fas fa-window-close remove-product"></i>' +
      '</span>'
    );

    if (value === 'product_user') {
      $('#user-product-selector').fadeIn();
    }

    $('.remove-product').on('click', function() {
      const self = $(this);
      self.closest('.badge').fadeOut(function() {
        self.remove();
        inputValue = self.closest('.badge').find('input').val();
        if (value === 'product_user') {
          $('#user-product-selector').fadeOut();
        }
      });
    });

    $(this).val(-1);
  });
}

$(document).on('users#edit:loaded', changeRoleHandler);
