var enableRegistration = function() {
  $('#submit-registration').prop('disabled', false);
  $('#submit-registration').removeClass('btn-secondary');
  $('#submit-registration').addClass('btn-primary');
}

const changeProductHandler = function() {
  $('#product-owner').change(function() {
    var value = $(this).children("option:selected").val();
    var label = $(this).children("option:selected").text();
    $(this).next('.row').find('.badges').append(
      '<span class="badge badge-secondary mr-1">' + label +
      ' <input type="hidden" name="user[products][]" value="' + value + '"/>' +
      ' <i class="fas fa-window-close"></i>' +
      '</span>'
    );
  });
}

const beforeSubmitHandler = function() {
  $('#new_user').submit(function(e) {
    // Preventing the submission of the product selection field.
    $('#product-owner').attr('disabled', 'disabled');
    $(this).submit();
  });
}

$(document).on('registrations#new:loaded', changeProductHandler);
$(document).on('registrations#new:loaded', beforeSubmitHandler);