# frozen_string_literal: true

require 'modules/constants'

# Helper to format filter ui for active filter.
module ApplicationHelper
  include Modules::Constants

  ADMIN_NAV_CONTROLLERS = %w[locations contacts users sectors projects candidate_organizations operator_services settings].freeze

  ACTION_WITH_BREADCRUMBS = %w[show edit create update new].freeze
  DEVISE_CONTROLLERS = ['devise/sessions', 'devise/passwords', 'devise/confirmations', 'registrations', 'deploys'].freeze

  def all_filters
    FRAMEWORK_FILTER_KEYS + ORGANIZATION_FILTER_KEYS
  end

  def hide_sidenav
    current_page?('/about/cookies') ||
      DEVISE_CONTROLLERS.include?(params[:controller]) ||
      (ADMIN_NAV_CONTROLLERS.include?(params[:controller]) && params[:action] == 'index')
  end

  def display_breadcrumb
    ACTION_WITH_BREADCRUMBS.include?(params[:action]) && params[:controller] != 'deploys'
  end

  def build_breadcrumbs(params)
    base_path = params[:controller]
    # Special case for the users base path because we have way to view/edit users
    base_path == 'users' && base_path = 'admin/users'

    # Special case for the candidate organizations.
    # * Non registered user should go to organizations list instead of candidate list in the crumb.
    base_label = params[:controller].titlecase
    if base_path == 'candidate_organizations' && !policy(CandidateOrganization).view_allowed?
      base_path = 'organizations'
      base_label = 'Organizations'
    end

    object_class = params[:controller].classify.constantize
    object_class.column_names.include?('slug') && object_record = object_class.find_by(slug: params[:id])
    if object_record.nil? && params[:id].present? && params[:id].scan(/\D/).empty?
      object_record = object_class.find(params[:id])
    end

    unless object_record.nil?
      if base_path == 'admin/users'
        id_label = object_record.email
      else
        id_label = object_record.name
      end
    end

    { base_path: base_path, base_label: base_label,
      id_path: "#{base_path}/#{params[:id]}", id_label: id_label }
  end

  def filter_count(filter_name)
    active_filters = session[filter_name]

    counter = 0
    unless active_filters.nil?
      counter = 1
      if active_filters.is_a?(Array)
        counter = active_filters.size
      end
    end
    counter
  end

  def format_filter(filter_name) 
    if filter_name == 'endorser_only'
      filter_label = "#{t('view.active-filter.endorsers')}
                      <span class='close-icon' data-effect='fadeOut'>
                        <i class='fa fa-times text-danger'></i>
                      </span>"
      return filter_label.html_safe
    end

    if filter_name == 'aggregator_only'
      filter_label = "#{t('view.active-filter.aggregators')}
                      <span class='close-icon' data-effect='fadeOut'>
                        <i class='fa fa-times text-danger'></i>
                      </span>"
      return filter_label.html_safe
    end

    if filter_name == 'is_launchable'
      filter_label = "#{t('view.active-filter.is-launchable')}
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
