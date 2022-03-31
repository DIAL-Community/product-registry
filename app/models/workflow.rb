# frozen_string_literal: true

require('csv')

class Workflow < ApplicationRecord
  include Auditable
  has_and_belongs_to_many :use_case_steps, join_table: :use_case_steps_workflows, dependent: :destroy
  has_and_belongs_to_many :building_blocks, join_table: :workflows_building_blocks

  has_many :workflow_descriptions, dependent: :destroy

  scope :name_contains, ->(name) { where('LOWER(workflows.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(workflows.slug) like LOWER(?)', "#{slug}\\_%") }

  attr_accessor :wf_desc

  def image_file
    if File.exist?(File.join('public', 'assets', 'workflows', "#{slug}.svg"))
      "/assets/workflows/#{slug}.svg"
    else
      '/assets/workflows/workflow_placeholder.png'
    end
  end

  def workflow_description_localized
    description = workflow_descriptions.order('LENGTH(description) DESC')
                                       .find_by(locale: I18n.locale)
    if description.nil?
      description = workflow_descriptions.order('LENGTH(description) DESC')
                                         .find_by(locale: 'en')
    end
    description
  end

  # overridden
  def to_param
    slug
  end

  def self_url(options = {})
    return "#{options[:api_path]}/workflows/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/workflows" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/workflows/#{slug}", '') if options[:item_path].present?
    return options[:collection_path].sub('/workflows', '') if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    if options[:include_relationships].present?
      json['building_blocks'] = building_blocks.as_json({ only: %i[name slug website], api_path: api_path(options) })
      json['use_case_steps'] = use_case_steps.as_json({ only: %i[name slug description],
                                                        api_path: api_path(options) })
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.to_csv
    attributes = %w[id name slug description building_blocks use_case_steps]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |p|
        building_blocks = p.building_blocks
                           .map(&:name)
                           .join('; ')
        use_case_steps = p.use_case_steps
                          .map(&:name)
                          .join('; ')
        csv << [p.id, p.name, p.slug, p.description, building_blocks, use_case_steps]
      end
    end
  end

  def self.serialization_options
    {
      except: %i[id created_at updated_at],
      include: {
        building_blocks: { only: %i[name slug] },
        use_case_steps: { only: %i[name slug description] }
      }
    }
  end
end
