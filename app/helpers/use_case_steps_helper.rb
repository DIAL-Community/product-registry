module UseCaseStepsHelper
  def calculate_step_number(use_case_step)
    return use_case_step.step_number if !use_case_step.step_number.nil?

    logger.info('Calculating use case step number!')

    use_case = use_case_step.use_case
    max_step = UseCaseStep.where(use_case_id: use_case.id)
                          .where('step_number is not null')
                          .order(:step_number)
                          .last

    max_step_number = 1
    if !max_step.nil?
      max_step_number = max_step.step_number + 1
    end
    logger.info("Setting default step number to: #{max_step_number}.")

    max_step_number
  end
end
