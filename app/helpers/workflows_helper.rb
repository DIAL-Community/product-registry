module WorkflowsHelper
  def workflow_footer(workflow, category)
    images = []
    case category
    when 'use_cases'
      use_cases = []
      workflow.use_case_steps.each do |use_case_step|
        use_cases |= [use_case_step.use_case]
      end

      use_cases.each do |use_case|
        next if use_case.nil?

        tooltip = use_case.name
        image = Hash[filename: use_case.image_file, tooltip: tooltip, id: use_case.slug, controller: 'use_cases']
        images.push(image)
      end
    when 'building_blocks'
      workflow.building_blocks.each do |building_block|
        next if building_block.nil?

        tooltip = building_block.name
        image = Hash[filename: building_block.image_file, tooltip: tooltip, id: building_block.slug,
                     controller: 'building_blocks']
        images.push(image)

      end
    end
    images
  end

  def workflow_footer_popover(elements)
    content = '<div>' + workflow_format_popover(elements) + '</div>'
    content.html_safe
  end

  private

  def workflow_format_popover(elements)
    formatted = ''
    elements.sort_by { |x| x[:name] }
            .each do |element|
      popover_class = 'popover-image'
      if element[:controller] == 'building_blocks'
        popover_class += ' popover-image-small'
      end
      formatted += link_to(image_tag(element[:filename], class: popover_class, title: element[:tooltip]),
                           action: 'show', controller: element[:controller], id: element[:id])
    end
    formatted
  end
end
