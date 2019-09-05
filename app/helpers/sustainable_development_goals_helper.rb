module SustainableDevelopmentGoalsHelper
  def footer(sustainable_development_goal, category)
    images = []
    case category
    when 'sdg_targets'
      sustainable_development_goal.sdg_targets.each do |sdg_target|
        next if sdg_target.nil?

        tooltip = sdg_target.name
        image = Hash[filename: sdg_target.image_file, tooltip: tooltip, id: sdg_target.id, controller: 'sdg_targets']
        images.push(image)
      end
    end
    images
  end

  def footer_image_popover(elements, title)
    content = '<div class="border rounded bg-secondary text-white clearfix border card-header">' +
              t(title, count: elements.count) +
              '</div>' \
              '<div>' + format_image_popover(elements) + '</div>'
    content.html_safe
  end

  private

  def format_image_popover(elements)
    formatted = ''
    elements.sort { |x, y| x[:name] <=> y[:name] }
            .each do |element|
      formatted += link_to(image_tag(element[:filename], class: 'popover-image', title: element[:tooltip]),
                           action: 'show', controller: element[:controller], id: element[:id])
    end
    formatted
  end
end
