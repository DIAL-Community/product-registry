# frozen_string_literal: true

module ApiFilterConcern
  extend ActiveSupport::Concern

  def valid_array_parameter(parameter)
    parameter.present? && parameter.is_a?(Array) && !parameter.nil? && !parameter.empty?
  end

  def use_cases_from_sdg_slugs(sdg_slugs)
    use_case_slugs = []
    if !sdg_slugs.nil? && !sdg_slugs.empty?
      sdg_slugs = sdg_slugs.reject { |x| x.nil? || x.empty? }
      return use_case_slugs if sdg_slugs.empty?

      sdg_numbers = SustainableDevelopmentGoal.where(slug: sdg_slugs)
                                              .select(:number)
                                              .map(&:number)
      # Return empty array if we don't have any matching sdg_numbers based on the sdg_slugs
      return use_case_slugs if sdg_numbers.empty?

      use_case_slugs += UseCase.joins(:sdg_targets)
                               .where(sdg_targets: { sdg_number: sdg_numbers })
                               .select('use_cases.slug')
                               .map(&:slug)
                               .uniq
    end
    use_case_slugs
  end

  def sdgs_from_use_case_slugs(use_case_slugs)
    sdg_slugs = []
    if !use_case_slugs.nil? && !use_case_slugs.empty?
      use_case_slugs = use_case_slugs.reject { |x| x.nil? || x.empty? }
      return sdg_slugs if use_case_slugs.empty?

      sdg_numbers = SdgTarget.joins(:use_cases)
                             .where(use_cases: { slug: use_case_slugs })
                             .select('sdg_targets.sdg_number')
                             .map(&:sdg_numbers)
                             .uniq
      # Return empty array if we don't have any matching sdg_numbers based on the use_case_slugs
      return sdg_slugs if sdg_numbers.empty?

      sdg_slugs += SustainableDevelopmentGoal.where(number: sdg_numbers)
                                             .select(:slug)
                                             .map(&:slug)
    end
    sdg_slugs
  end

  def workflows_from_use_case_slugs(use_case_slugs)
    workflow_slugs = []
    if !use_case_slugs.nil? && !use_case_slugs.empty?
      use_case_slugs = use_case_slugs.reject { |x| x.nil? || x.empty? }
      return workflow_slugs if use_case_slugs.empty?

      use_case_step_slugs = UseCase.joins(:use_case_steps)
                                   .where(use_cases: { slug: use_case_slugs })
                                   .select('use_case_steps.slug')
                                   .map(&:slug)
      # Return empty array if we don't have any matching steps from the use_case_slugs
      return workflow_slugs if use_case_step_slugs.empty?

      workflow_slugs += Workflow.joins(:use_case_steps)
                                .where(use_case_steps: { slug: use_case_step_slugs })
                                .select(:slug)
                                .map(&:slug)
    end
    workflow_slugs
  end

  def use_cases_from_workflow_slugs(workflow_slugs)
    use_case_slugs = []
    if !workflow_slugs.nil? && !workflow_slugs.empty?
      workflow_slugs = workflow_slugs.reject { |x| x.nil? || x.empty? }
      return use_case_slugs if workflow_slugs.empty?

      use_case_step_slugs = Workflow.joins(:use_case_steps)
                                    .where(workflows: { slug: workflow_slugs })
                                    .select('use_case_steps.slug')
                                    .map(&:slug)
      # Return empty array if we don't have any matching steps from the workflow_slugs
      return use_case_slugs if use_case_step_slugs.empty?

      use_case_slugs += UseCase.joins(:use_case_steps)
                               .where(use_case_steps: { slug: use_case_step_slugs })
                               .select(:slug)
                               .map(&:slug)
    end
    use_case_slugs
  end

  def building_blocks_from_workflow_slugs(workflow_slugs)
    building_block_slugs = []
    if !workflow_slugs.nil? && !workflow_slugs.empty?
      workflow_slugs = workflow_slugs.reject { |x| x.nil? || x.empty? }
      return building_block_slugs if workflow_slugs.empty?

      building_block_slugs += BuildingBlock.joins(:workflows)
                                           .where(workflows: { slug: workflow_slugs })
                                           .select(:slug)
                                           .map(&:slug)
    end
    building_block_slugs
  end

  def workflows_from_building_block_slugs(building_block_slugs)
    workflow_slugs = []
    if !building_block_slugs.nil? && !building_block_slugs.empty?
      building_block_slugs = building_block_slugs.reject { |x| x.nil? || x.empty? }
      return workflow_slugs if building_block_slugs.empty?

      workflow_slugs += Workflow.joins(:building_blocks)
                                .where(building_blocks: { slug: building_block_slugs })
                                .select(:slug)
                                .map(&:slug)
    end
    workflow_slugs
  end

  def products_from_building_block_slugs(building_block_slugs)
    product_slugs = []
    if !building_block_slugs.nil? && !building_block_slugs.empty?
      building_block_slugs = building_block_slugs.reject { |x| x.nil? || x.empty? }
      return product_slugs if building_block_slugs.empty?

      product_slugs += Product.joins(:building_blocks)
                              .where(building_blocks: { slug: building_block_slugs })
                              .select(:slug)
                              .map(&:slug)
    end
    product_slugs
  end

  def building_blocks_from_product_slugs(product_slugs)
    building_block_slugs = []
    if !product_slugs.nil? && !product_slugs.empty?
      product_slugs = product_slugs.reject { |x| x.nil? || x.empty? }
      return building_block_slugs if product_slugs.empty?

      building_block_slugs += BuildingBlock.joins(:products)
                                           .where(products: { slug: product_slugs })
                                           .select(:slug)
                                           .map(&:slug)
    end
    building_block_slugs
  end
end
