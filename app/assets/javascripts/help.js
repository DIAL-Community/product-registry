var currentStep;
function initHelp() {
  currentStep = 0;
  showStep(currentStep);

  $('#prevButton').click(function() {
    navigate(-1);
    $(this).blur();
  });

  $('#nextButton').click(function() {
    navigate(1);
    $(this).blur();
  });
}

function showStep(stepCount) {
  const activeStep = $('.step').eq(stepCount);
  activeStep.show();

  if (stepCount <= 0) {
    $('#prevButton').hide();
  } else {
    $('#prevButton').show();
  }

  if (stepCount === $('.step').length - 1) {
    $('#nextButton').html('Finish');
  } else {
    $('#nextButton').html('Next');
  }
  updateStepIndicator(stepCount)
}

function navigate(stepCount) {
  const activeStep = $('.step').eq(currentStep);
  activeStep.hide();

  currentStep = currentStep + stepCount;
  if (currentStep >= $('.step').length) {
    currentStep = 0;
    showStep(currentStep);
    $('#help-modal').modal('hide');
    return;
  }

  showStep(currentStep);
}

function updateStepIndicator(stepCount) {
  var steps = $('.step-indicator');
  steps.each(function(index, element) {
    $(element).removeClass('active');
    if (index === stepCount) {
      $(element).addClass('active');
    }
  });
}

$(document).on('sustainable_development_goals#index:loaded', initHelp);
$(document).on('use_cases#index:loaded', initHelp);
$(document).on('workflows#index:loaded', initHelp);
$(document).on('building_blocks#index:loaded', initHelp);
$(document).on('products#index:loaded', initHelp);
$(document).on('organizations#index:loaded', initHelp);