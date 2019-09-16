var enableCandidateSubmission = function() {
  $('#submit-candidate').prop('disabled', false);
  $('#submit-candidate').removeClass('btn-secondary');
  $('#submit-candidate').addClass('btn-primary');
}