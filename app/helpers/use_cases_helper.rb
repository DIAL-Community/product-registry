module UseCasesHelper
  def uc_footer(use_case, category)
    images = []
    case category
    when 'sdg_targets'
      use_case.sdg_targets.each do |sdg_target|
        next if sdg_target.nil?

        tooltip = sdg_target.name
        image = Hash[filename: sdg_target.image_file, tooltip: tooltip, id: sdg_target.id, controller: 'sdg_targets']
        images.push(image)
      end
    when 'workflows'
      use_case.workflows.each do |workflow|
        next if workflow.nil?

        tooltip = workflow.name
        image = Hash[filename: workflow.image_file, tooltip: tooltip, id: workflow.id, controller: 'workflows']
        images.push(image)
      end
    end
    images
  end

  def uc_footer_popover(elements, title)
    content = '<div class="border rounded bg-secondary text-white clearfix border card-header">' +
              t(title, count: elements.count) +
              '</div>' \
              '<div>' + uc_format_popover(elements) + '</div>'
    content.html_safe
  end

  private

  def uc_format_popover(elements)
    formatted = ''
    elements.sort_by { |x| x[:name] }
            .each do |element|
      if element[:controller] == 'sdg_targets'
        formatted += image_tag(element[:filename], class: 'popover-image', title: element[:tooltip])
      else
        formatted += link_to(image_tag(element[:filename], class: 'popover-image-link', title: element[:tooltip]),
                             action: 'show', controller: element[:controller], id: element[:id])
      end
    end
    formatted
  end
end
