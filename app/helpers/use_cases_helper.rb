# frozen_string_literal: true

module UseCasesHelper
  def uc_footer(use_case, category)
    images = []
    case category
    when 'sdg_targets'
      use_case.sdg_targets.each do |sdg_target|
        next if sdg_target.nil?

        tooltip = "Target #{sdg_target.target_number}: #{sdg_target.name}"
        image = Hash[filename: sdg_target.image_file, tooltip: tooltip,
                     alt_text: t('alt.el-logo', el: "#{t('view.sdg.show.target')} #{sdg_target.target_number}").humanize,
                     id: sdg_target.id, controller: 'sdg_targets']
        images.push(image)
      end
    when 'workflows'
      workflows = []
      use_case.use_case_steps.each do |use_case_step|
        workflows |= use_case_step.workflows
      end

      workflows.each do |workflow|
        next if workflow.nil?

        tooltip = workflow.name
        image = Hash[filename: workflow.image_file, tooltip: tooltip,
                     alt_text: t('alt.el-logo', el: "#{use_case.name} #{t('model.use-case')}").humanize,
                     id: workflow.id, controller: 'workflows']
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
      formatted += if element[:controller] == 'sdg_targets'
                     image_tag(element[:filename], class: 'popover-image', title: element[:tooltip])
                   else
                     link_to(image_tag(element[:filename], class: 'popover-image', title: element[:tooltip]),
                             action: 'show', controller: element[:controller], id: element[:id])
                   end
    end
    formatted
  end
end
