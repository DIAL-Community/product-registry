let captchaSuccess = false

var enableRegistration = function() {
  if ($("#terms").is(":checked")) {
    $('#submit-registration').prop('disabled', false);
    $('#submit-registration').removeClass('btn-secondary');
    $('#submit-registration').addClass('btn-primary');
  } else {
    captchaSuccess = true
  }
}

const changeProductHandler = function() {
  $('#product-owner').change(function() {
    var value = $(this).children("option:selected").val();
    var label = $(this).children("option:selected").text();
    $(this).next('.row').find('.badges').append(
      '<span class="badge badge-secondary mr-1">' + label +
      ' <input type="hidden" name="user[product_id][]" value="' + value + '"/>' +
      ' <i class="fas fa-window-close remove-product"></i>' +
      '</span>'
    );

    $('.remove-product').on('click', function() {
      $(this).closest('.badge').fadeOut("slow", function() {
        $(this).remove();
      });
    })
  });
}

const beforeSubmitHandler = function() {
  $('#new_user').submit(function(e) {
    if ($("#terms").is(":checked")) {
      // Preventing the submission of the product selection field.
      $('#product-owner').attr('disabled', 'disabled');
      $(this).submit();
    } else {
      $("#terms-error").show();
      e.preventDefault();
    }
  });
}

var termsHandler = function() {
  $("#terms").on('change', function() {
    if ($("#terms").is(":checked") && captchaSuccess) {
      $('#submit-registration').prop('disabled', false);
      $('#submit-registration').removeClass('btn-secondary');
      $('#submit-registration').addClass('btn-primary');
    }
  })
}

$(document).on('registrations#new:loaded', changeProductHandler);
$(document).on('registrations#new:loaded', beforeSubmitHandler);
$(document).on('registrations#new:loaded', termsHandler);

$(document).on('registrations#create:loaded', changeProductHandler);
$(document).on('registrations#create:loaded', beforeSubmitHandler);
$(document).on('registrations#create:loaded', termsHandler);
