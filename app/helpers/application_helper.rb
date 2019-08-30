# frozen_string_literal: true

require 'modules/constants'

# Helper to format filter ui for active filter.
module ApplicationHelper
  include Modules::Constants

  ADMIN_NAV_CONTROLLERS = %w[locations users sectors].freeze
  ACTION_WITH_BREADCRUMBS = %w[show edit create].freeze
  DEVISE_CONTROLLERS = ['devise/sessions', 'devise/passwords', 'devise/registrations', 'devise/confirmations'].freeze

  def all_filters
    FRAMEWORK_FILTER_KEYS + ORGANIZATION_FILTER_KEYS
  end

  def display_sidenav
    current_page?('/map') || current_page?('/about/cookies') ||
      DEVISE_CONTROLLERS.include?(params[:controller]) ||
      (ADMIN_NAV_CONTROLLERS.include?(params[:controller]) && params[:action] == 'index')
  end

  def display_breadcrumb
    ACTION_WITH_BREADCRUMBS.include?(params[:action])
  end

  def build_breadcrumbs(params)
    base_path = params[:controller]
    base_path == 'users' && base_path = 'admin/users'
    { base_path: base_path, base_label: params[:controller].titlecase,
      id_path: "#{base_path}/#{params[:id]}", id_label: params[:id].titlecase }
  end

  def format_filter(filter_name)
    if filter_name == 'endorser_only'
      filter_label = "#{t('view.active-filter.endorser-only')}
                      <span class='close-icon' data-effect='fadeOut'>
                        <i class='fa fa-times text-danger'></i>
                      </span>"
      return filter_label.html_safe
    end

    if filter_name == 'with_maturity_assessment'
      filter_label = "#{t('view.active-filter.with-maturity')}
                      <span class='close-icon' data-effect='fadeOut'>
                        <i class='fa fa-times text-danger'></i>
                      </span>"
      return filter_label.html_safe
    end

    active_filters = session[filter_name]
    count = active_filters.count
    if count <= 3
      filter_label = active_filters.sort! { |x, y| x['value'].to_i <=> y['value'].to_i }
                                   .map { |x| format_element(filter_name, x) }
                                   .join(', ')
      filter_label = "#{t('view.active-filter.title', model: t("view.active-filter.#{filter_name}", count: count))}:
                      #{filter_label}
                      <span class='close-icon' data-effect='fadeOut'>
                        <i class='fa fa-times text-danger'></i>
                      </span>"
    else
      filter_label = active_filters.sort! { |x, y| x['value'].to_i <=> y['value'].to_i }
                                   .map { |x| format_element(filter_name, x) }
                                   .slice(0, 3)
                                   .join(', ')
      filter_label = "<span>
                        #{t('view.active-filter.title', model: t("view.active-filter.#{filter_name}", count: count))}:
                        #{filter_label} ...
                      </span>
                      <span class='more-others' data-toggle='collapse'
                            href='##{filter_name}' role='button'
                            aria-expanded='true' aria-controls='#{filter_name}'>
                        <u>
                        #{t('view.active-filter.multi-filter', count: count - 3,
                                                               model: t("view.active-filter.#{filter_name}", count: count))}
                        </u>
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
    return "'#{element['label']}'" if filter_name != 'years'

    "'#{element['label']}'"
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
