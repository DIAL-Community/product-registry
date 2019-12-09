module SustainableDevelopmentGoalsHelper
  def sdg_footer(sustainable_development_goal, category)
    images = []
    case category
    when 'use_cases'
      sustainable_development_goal.sdg_targets.each do |sdg_target|
        sdg_target.use_cases.each do |use_case|
          next if use_case.nil?

          tooltip = use_case.name
          image = Hash[filename: use_case.image_file, tooltip: tooltip, id: use_case.id, controller: 'use_cases']
          images.push(image)
        end
      end
      @use_case_count = images.size
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

  def use_case_names(sdg_target)
    names = []
    sdg_target.use_cases.each do |use_case|
      uc = Hash[name: use_case.name, id: use_case.id]
      names.push(uc)
    end
    names
  end

  def sdg_footer_popover(elements, title)
    content = '<div class="border rounded bg-secondary text-white clearfix border card-header">' +
              t(title, count: elements.count) +
              '</div>' \
              '<div>' + sdg_format_popover(elements) + '</div>'
    content.html_safe
  end

  private

  def sdg_format_popover(elements)
    formatted = ''
    elements.sort_by { |x| x[:name] }
            .each do |element|
      formatted += image_tag(element[:filename], class: 'popover-image', title: element[:tooltip])
    end
    formatted
  end
end
