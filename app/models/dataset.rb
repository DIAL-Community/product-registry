# frozen_string_literal: true

require('csv')
require 'modules/maturity_sync'

class Dataset < ApplicationRecord
  include Auditable
  include Modules::MaturitySync

  attr_accessor :dataset_description

  has_many :dataset_descriptions, dependent: :delete_all

  has_many :organizations_datasets, dependent: :delete_all,
                                    after_add: :association_add,
                                    before_remove: :association_remove
  has_many :organizations, through: :organizations_datasets,
                           dependent: :delete_all,
                           after_add: :association_add,
                           before_remove: :association_remove

  has_many :dataset_sectors, dependent: :delete_all,
                             after_add: :association_add, before_remove: :association_remove
  has_many :sectors, through: :dataset_sectors,
                     after_add: :association_add, before_remove: :association_remove

  has_and_belongs_to_many :origins, join_table: :datasets_origins,
                                    dependent: :delete_all,
                                    after_add: :association_add, before_remove: :association_remove

  has_many :dataset_sustainable_development_goals, dependent: :delete_all,
                             after_add: :association_add, before_remove: :association_remove
  has_many :sustainable_development_goals, through: :dataset_sustainable_development_goals,
                                           dependent: :delete_all,
                                           after_add: :association_add, before_remove: :association_remove

  validates :name, presence: true, length: { maximum: 300 }

  scope :name_contains, ->(name) { where('LOWER(datasets.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(datasets.slug) like LOWER(?)', "#{slug}%\\_") }

  def self.first_duplicate(name, slug)
    find_by('name = ? OR slug = ? OR ? = ANY(aliases)', name, slug, name)
  end

  def image_file
    if File.exist?(File.join('public', 'assets', 'datasets', "#{slug}.png"))
      "/assets/datasets/#{slug}.png"
    elsif dataset_type == 'dataset'
      '/assets/datasets/dataset_placeholder.png'
    else
      '/assets/datasets/content_placeholder.png'
    end
  end

  def sectors_localized
    sectors.where('locale = ?', I18n.locale)
  end

  def dataset_description_localized
    description = dataset_descriptions.order('LENGTH(description) DESC')
                                      .find_by(locale: I18n.locale)
    if description.nil?
      description = dataset_descriptions.order('LENGTH(description) DESC')
                                        .find_by(locale: 'en')
    end
    description
  end

  def owner
    owner = User.joins(:datasets).where(datasets: { id: id })
    owner.first.id unless owner.empty?
  end

  # overridden
  def to_param
    slug
  end

  def self.to_csv
    attributes = %w[id name slug website repository organizations origins]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |p|
        organizations = p.organizations
                         .map(&:name)
                         .join('; ')
        origins = p.origins
                   .map(&:name)
                   .join('; ')

        csv << [p.id, p.name, p.slug, p.website, organizations, origins]
      end
    end
  end

  def self_url(options = {})
    return "#{options[:api_path]}/datasets/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/datasets" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/datasets/#{slug}", '') if options[:item_path].present?
    return options[:collection_path].sub('/datasets', '') if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    if options[:include_relationships].present?
      json['organizations'] = organizations.as_json({ only: %i[name slug website], api_path: api_path(options) })
      json['origins'] = origins.as_json({ only: %i[name slug], api_path: api_path(options), api_source: 'datasets' })
      json['sustainable_development_goals'] = sustainable_development_goals.as_json({ only: %i[name slug number],
                                                                                      api_path: api_path(options) })
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.serialization_options
    {
      except: %i[id status created_at updated_at],
      include: {
        organizations: { only: [:name] },
        sectors: { only: [:name] },
        origins: { only: [:name] },
        sustainable_development_goals: { only: %i[number name] }
      }
    }
  end

  def current_sustainable_development_goal_mapping
    return nil if sustainable_development_goals.nil? || sustainable_development_goals.empty?

    dataset_sustainable_development_goals.each do |sustainable_development_goal|
      mapping_status = sustainable_development_goal.mapping_status

      return mapping_status unless mapping_status.nil?
    end

    nil
  end
end
