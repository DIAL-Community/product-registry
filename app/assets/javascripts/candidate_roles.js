let currentlyLoadingCandidateRoles = false;
const scrollCandidateRoleHandler = function () {
  const removeClasses = function() {
    $('.existing-candidate-role').removeClass('existing-candidate-role');
    $('.to-be-animated').removeClass('to-be-animated');
  }

  $(window).on('scroll', function () {
    const currentPage = $('#candidate-role-list').attr('data-current-page');
    let url = `${window.location.pathname}?page=${parseInt(currentPage) + 1}`;

    const shouldExecuteXhr = $(window).scrollTop() > $(document).height() - $(window).height() - 50;
    if (!isNaN(currentPage) && !currentlyLoadingCandidateRoles && shouldExecuteXhr) {
      currentlyLoadingCandidateRoles = true;
      $('#candidate-role-list > div').addClass('existing-candidate-role');
      $.getScript(url, function () {
        $('#candidate-role-list').attr('data-current-page', parseInt(currentPage) + 1);
        animateCss('.to-be-animated', 'fadeIn', removeClasses);
        currentlyLoadingCandidateRoles = false;
      });
    }
  });
}

$(document).on('candidate_roles#index:loaded', scrollCandidateRoleHandler);

const changeCandidateRoleHandler = function() {
  $('#user-role-selector').change(function() {
    var value = $(this).children("option:selected").val();
    var label = $(this).children("option:selected").text();
    $(this).next('.row').find('.badges').append(
      '<span class="badge badge-secondary mr-1">' + label +
      ' <input type="hidden" name="selected_roles[]" value="' + value + '"/>' +
      ' <i class="fas fa-window-close remove-product"></i>' +
      '</span>'
    );

    $('.remove-product').on('click', function() {
      const self = $(this);
      self.closest('.badge').fadeOut(function() {
        self.remove();
      });
    });

    $(this).val(-1);
  });
}

$(document).on('candidate_roles#edit:loaded', changeCandidateRoleHandler);
$(document).on('candidate_roles#new:loaded', changeCandidateRoleHandler);
