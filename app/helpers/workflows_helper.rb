module WorkflowsHelper
  def workflow_footer(workflow, category)
    images = []
    case category
    when 'use_cases'
      workflow.use_cases.each do |use_case|
        next if use_case.nil?

        tooltip = use_case.name
        image = Hash[filename: use_case.image_file, tooltip: tooltip, id: use_case.id, controller: 'use_cases']
        images.push(image)
      end
    when 'building_blocks'
      workflow.building_blocks.each do |building_block|
        next if building_block.nil?

        tooltip = building_block.name
        image = Hash[filename: building_block.image_file, tooltip: tooltip, id: building_block.id, controller: 'building_blocks']
        images.push(image)

      end
    end
    images
  end

  def workflow_footer_popover(elements, title)
    content = '<div class="border rounded bg-secondary text-white clearfix border card-header">' +
              t(title, count: elements.count) +
              '</div><div>' + workflow_format_popover(elements) + '</div>'
    content.html_safe
  end

  private

  def workflow_format_popover(elements)
    formatted = ''
    elements.sort_by { |x| x[:name] }
            .each do |element|
      formatted += link_to(image_tag(element[:filename], class: 'popover-image', title: element[:tooltip]),
                           action: 'show', controller: element[:controller], id: element[:id])
    end
    formatted
  end
end
