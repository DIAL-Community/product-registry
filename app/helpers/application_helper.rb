# frozen_string_literal: true

require 'modules/constants'

# Helper to format filter ui for active filter.
module ApplicationHelper
  include Modules::Constants

  def all_filters
    FRAMEWORK_FILTER_KEYS + ORGANIZATION_FILTER_KEYS
  end

  def format_filter(filter_name)
    active_filters = session[filter_name]
    if active_filters.count <= 3
      filter_label = active_filters.sort! { |x, y| x['value'].to_i <=> y['value'].to_i }
                                   .map { |x| format_element(filter_name, x) }
                                   .join(', ')
      filter_label = "#{filter_label}
                      <span class='close-icon' data-effect='fadeOut'>
                        <i class='fa fa-times text-danger'></i>
                      </span>"
    else
      filter_label = active_filters.sort! { |x, y| x['value'].to_i <=> y['value'].to_i }
                                   .map { |x| format_element(filter_name, x) }
                                   .slice(0, 3)
                                   .join(', ')
      filter_label = "<span>#{filter_label} ...</span>
                      <span class='more-others' data-toggle='collapse'
                            href='##{filter_name}' role='button'
                            aria-expanded='true' aria-controls='#{filter_name}'>
                        and #{active_filters.count - 3} others.
                      </span>
                      <span class='close-icon' data-effect='fadeOut'>
                        <i class='fa fa-times text-danger'></i>
                      </span>
                      #{build_collapse(filter_name, active_filters)}"
    end
    filter_label.html_safe
  end

  private

  def format_element(filter_name, element)
    return "#{element['value']}. #{element['label']}" if filter_name != 'years'

    element['label'].to_s
  end

  def build_collapse(filter_name, active_filters)
    filter_divs = active_filters.map { |x| "<div>#{format_element(filter_name, x)}</div>" }
                                .slice(3, active_filters.count)
                                .join
    "<div class='collapse' id='#{filter_name}'>
      <div class='card card-body p-2'>
        #{filter_divs}
      </div>
    </div>"
  end
end
