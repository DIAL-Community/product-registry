# frozen_string_literal: true

class UseCaseStep < ApplicationRecord
  include Auditable

  belongs_to :use_case
  attr_accessor :ucs_desc

  has_many :use_case_step_descriptions, dependent: :destroy
  has_and_belongs_to_many :products, join_table: :use_case_steps_products,
                                     after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :workflows, join_table: :use_case_steps_workflows,
                                      after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :building_blocks, join_table: :use_case_steps_building_blocks,
                                            after_add: :association_add, before_remove: :association_remove

  scope :name_contains, ->(name) { where('LOWER(name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(slug) like LOWER(?)', "#{slug}\\_%") }

  def use_case_step_description_localized
    description = use_case_step_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                            .find_by(locale: I18n.locale)
    if description.nil?
      description = use_case_step_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                              .find_by(locale: 'en')
    end
    description
  end

  # overridden
  def to_param
    slug
  end

  def self_url(options = {})
    return "#{options[:api_path]}/use_cases/#{use_case.slug}/use_case_steps/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/use_cases/#{use_case.slug}" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/use_cases/#{use_case.slug}/use_case_steps/#{slug}", '') \
      if options[:item_path].present?
    return options[:collection_path].sub("/use_cases/#{use_case.slug}/use_case_steps", '') \
      if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    json['use_case'] = use_case.as_json({ only: %i[name slug], api_path: api_path(options) })
    if options[:include_relationships].present?
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.serialization_options
    {
      except: %i[id use_case_id created_at updated_at]
    }
  end
end
