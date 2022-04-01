# frozen_string_literal: true

require('csv')

class BuildingBlock < ApplicationRecord
  include EntityStatusType
  include Auditable

  has_many :product_building_blocks,
           after_add: :association_add, before_remove: :association_remove
  has_many :products, through: :product_building_blocks,
                      after_add: :association_add, before_remove: :association_remove

  has_many :building_block_descriptions

  has_and_belongs_to_many :workflows, join_table: :workflows_building_blocks,
                                      after_add: :association_add, before_remove: :association_remove

  has_many :building_block_descriptions, dependent: :destroy

  scope :name_contains, ->(name) { where('LOWER(building_blocks.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(building_blocks.slug) like LOWER(?)', "#{slug}\\_%") }

  attr_accessor :bb_desc

  def building_block_description_localized
    description = building_block_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                             .find_by(locale: I18n.locale)
    if description.nil?
      description = building_block_descriptions.order(Arel.sql('LENGTH(description) DESC'))
                                               .find_by(locale: 'en')
    end
    description
  end

  def image_file
    if File.exist?(File.join('public', 'assets', 'building_blocks', "#{slug}.png"))
      "/assets/building_blocks/#{slug}.png"
    else
      '/assets/building_blocks/bb_placeholder.png'
    end
  end

  # overridden
  def to_param
    slug
  end

  def self_url(options = {})
    return "#{options[:api_path]}/building_blocks/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/building_blocks" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/building_blocks/#{slug}", '') if options[:item_path].present?
    return options[:collection_path].sub('/building_blocks', '') if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    if options[:include_relationships].present?
      json['products'] = products.as_json({ only: %i[name slug website], api_path: api_path(options) })
      json['workflows'] = workflows.as_json({ only: %i[name slug], api_path: api_path(options) })
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.to_csv
    attributes = %w[id name slug description products workflows]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |p|
        workflows = p.workflows
                     .map(&:name)
                     .join('; ')
        products = p.products
                    .map(&:name)
                    .join('; ')

        csv << [p.id, p.name, p.slug, p.description, products, workflows]
      end
    end
  end

  def self.serialization_options
    {
      except: %i[id created_at updated_at description],
      include: {
        building_block_descriptions: { only: [:description] },
        products: { only: %i[name slug] },
        workflows: { only: %i[name slug] }
      }
    }
  end
end
