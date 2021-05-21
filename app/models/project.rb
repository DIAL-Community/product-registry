require('csv')

class Project < ApplicationRecord
  include Auditable
  attr_accessor :project_description

  has_many :projects_locations
  has_many :locations, through: :projects_locations

  has_and_belongs_to_many :countries, join_table: :projects_countries

  has_and_belongs_to_many :organizations, join_table: :projects_organizations,
                          after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :products, join_table: :projects_products,
                          after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :locations, join_table: :projects_locations
  has_and_belongs_to_many :digital_principles, join_table: :projects_digital_principles
  has_and_belongs_to_many :sectors, join_table: :projects_sectors
  has_and_belongs_to_many :sustainable_development_goals, join_table: :projects_sdgs, association_foreign_key: :sdg_id
  has_many :project_descriptions

  belongs_to :origin

  scope :name_contains, ->(name) { where('LOWER(projects.name) like LOWER(?)', "%#{name}%") }

  def to_param
    slug
  end

  def image_file
    if File.exist?(File.join('public','assets','products',"#{slug}.png"))
      return "/assets/projects/#{slug}.png"
    else
      return "project_placeholder.png"
    end
  end

  def product_image_file
    if !products.empty?
      if File.exist?(File.join('public', 'assets', 'products', "#{products.first.slug}.png"))
        return "/assets/products/#{products.first.slug}.png"
      else
        return "/assets/products/prod_placeholder.png"
      end
    else
      return "/assets/products/prod_placeholder.png"
    end
  end

  def org_image_file
    if !organizations.empty?
      if File.exist?(File.join('public', 'assets', 'organizations', "#{organizations.first.slug}.png"))
        return "/assets/organizations/#{organizations.first.slug}.png"
      else
        return "/assets/organizations/org_placeholder.png"
      end
    else
      return "/assets/organizations/org_placeholder.png"
    end
  end

  def origin_image_file(origin)
    if !origin.nil?
      if File.exist?(File.join('public', 'assets', 'origins', "#{origin.slug}.png"))
        return "/assets/origins/#{origin.slug}.png"
      else
        return "/assets/origins/origin_placeholder.png"
      end
    else
      return "/assets/origins/origin_placeholder.png"
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
    json['origin'] = origin.as_json({ only: [:name, :slug], api_path: api_path(options), api_source: 'projects' })
    if options[:include_relationships].present?
      json['countries'] = countries.as_json({ only: [:name, :slug, :code], api_path: api_path(options) })
      json['organizations'] = organizations.as_json({ only: [:name, :slug, :website], api_path: api_path(options) })
      json['products'] = products.as_json({ only: [:name, :slug], api_path: api_path(options) })
      json['sectors'] = sectors.as_json({ only: [:name, :slug], api_path: api_path(options) })
      json['sustainable_development_goals'] = sustainable_development_goals.as_json({ only: [:name, :slug, :number],
                                                                                      api_path: api_path(options) })
    end
    if options[:collection_path].present? || options[:api_path].present?
      json['self_url'] = self_url(options)
    end
    if options[:item_path].present?
      json['collection_url'] = collection_url(options)
    end
    json
  end

  def self.to_csv
    attributes = %w{id name slug origin organizations products}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |p|
        organizations = p.organizations
                         .map(&:name)
                         .join('; ')
        products = p.products
                    .map(&:name)
                    .join('; ')

        csv << [p.id, p.name, p.slug, p.origin.name, organizations, products]
      end
    end
  end

  def self.serialization_options
    {
      except: [:id, :origin_id, :created_at, :updated_at],
      include: {
        organizations: { only: [:name, :slug] },
        products: {
          only: [:name, :slug]
        }
      }
    }
  end
end
