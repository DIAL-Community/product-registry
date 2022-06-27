# frozen_string_literal: true

require('csv')

class Project < ApplicationRecord
  include Auditable
  attr_accessor :project_description

  has_and_belongs_to_many :countries, join_table: :projects_countries

  has_and_belongs_to_many :organizations, join_table: :projects_organizations,
                                          after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :products, join_table: :projects_products,
                                     after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :digital_principles, join_table: :projects_digital_principles
  has_and_belongs_to_many :sectors, join_table: :projects_sectors
  has_and_belongs_to_many :sustainable_development_goals, join_table: :projects_sdgs, association_foreign_key: :sdg_id
  has_many :project_descriptions

  belongs_to :origin

  scope :name_contains, ->(name) { where('LOWER(projects.name) like LOWER(?)', "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where('LOWER(projects.slug) like LOWER(?)', "#{slug}%\\_") }

  def sectors_localized
    sectors.where('locale = ?', I18n.locale)
  end

  def project_description_localized
    description = project_descriptions
                  .find_by(locale: I18n.locale)
    if description.nil?
      description = project_descriptions
                    .find_by(locale: 'en')
    end
    description
  end

  def to_param
    slug
  end

  def image_file
    if File.exist?(File.join('public', 'assets', 'products', "#{slug}.png"))
      "/assets/projects/#{slug}.png"
    else
      'project_placeholder.png'
    end
  end

  def product_image_file
    if !products.empty?
      if File.exist?(File.join('public', 'assets', 'products', "#{products.first.slug}.png"))
        "/assets/products/#{products.first.slug}.png"
      else
        '/assets/products/prod_placeholder.png'
      end
    else
      '/assets/products/prod_placeholder.png'
    end
  end

  def org_image_file
    if !organizations.empty?
      if File.exist?(File.join('public', 'assets', 'organizations', "#{organizations.first.slug}.png"))
        "/assets/organizations/#{organizations.first.slug}.png"
      else
        '/assets/organizations/org_placeholder.png'
      end
    else
      '/assets/organizations/org_placeholder.png'
    end
  end

  def origin_image_file(origin)
    if !origin.nil?
      if File.exist?(File.join('public', 'assets', 'origins', "#{origin.slug}.png"))
        "/assets/origins/#{origin.slug}.png"
      else
        '/assets/origins/origin_placeholder.png'
      end
    else
      '/assets/origins/origin_placeholder.png'
    end
  end

  def self_url(options = {})
    return "#{options[:api_path]}/projects/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/projects" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/projects/#{slug}", '') if options[:item_path].present?
    return options[:collection_path].sub('/projects', '') if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    json['origin'] = origin.as_json({ only: %i[name slug], api_path: api_path(options), api_source: 'projects' })
    if options[:include_relationships].present?
      json['countries'] = countries.as_json({ only: %i[name slug code], api_path: api_path(options) })
      json['organizations'] = organizations.as_json({ only: %i[name slug website], api_path: api_path(options) })
      json['products'] = products.as_json({ only: %i[name slug], api_path: api_path(options) })
      json['sectors'] = sectors.as_json({ only: %i[name slug], api_path: api_path(options) })
      json['sustainable_development_goals'] = sustainable_development_goals.as_json({ only: %i[name slug number],
                                                                                      api_path: api_path(options) })
    end
    json['self_url'] = self_url(options) if options[:collection_path].present? || options[:api_path].present?
    json['collection_url'] = collection_url(options) if options[:item_path].present?
    json
  end

  def self.to_csv
    attributes = %w[id name slug origin start_date end_date tags project_descriptions sectors countries organizations
                    products]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |p|
        organizations = p.organizations
                         .map(&:name)
                         .join('; ')
        products = p.products
                    .map(&:name)
                    .join('; ')

        project_descriptions = p.project_descriptions
                                .map(&:description)
                                .join('; ')

        countries = p.countries
                     .map(&:name)
                     .join('; ')

        sectors = p.sectors
                   .map(&:name)
                   .join('; ')

        csv << [p.id, p.name, p.slug, p.origin.name, p.start_date, p.end_date, p.tags, project_descriptions, sectors,
                countries, organizations, products]
      end
    end
  end

  def self.serialization_options
    {
      except: %i[id origin_id created_at updated_at],
      include: {
        organizations: { only: %i[name slug] },
        products: {
          only: %i[name slug]
        }
      }
    }
  end
end
