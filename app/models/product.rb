require('csv')
require 'modules/maturity_sync'

class Product < ApplicationRecord
  include Auditable
  include Modules::MaturitySync

  attr_accessor :product_description

  has_many :product_indicators, dependent: :delete_all
  has_many :product_repositories, dependent: :delete_all
  has_many :product_descriptions, dependent: :delete_all

  has_and_belongs_to_many :use_case_steps, join_table: :use_case_steps_products,
                                           dependent: :delete_all,
                                           after_add: :association_add,
                                           before_remove: :association_remove
  has_many :product_classifications, dependent: :delete_all
  has_many :classifications, through: :product_classifications,
                             dependent: :delete_all

  has_many :organizations_products, dependent: :delete_all,
                                    after_add: :association_add,
                                    before_remove: :association_remove
  has_many :organizations, through: :organizations_products,
                           dependent: :delete_all,
                           after_add: :association_add,
                           before_remove: :association_remove

  has_many :product_sectors, dependent: :delete_all,
                             after_add: :association_add, before_remove: :association_remove
  has_many :sectors, through: :product_sectors,
                     after_add: :association_add, before_remove: :association_remove

  has_many :product_building_blocks, dependent: :delete_all,
                                     after_add: :association_add,
                                     before_remove: :association_remove
  has_many :building_blocks, through: :product_building_blocks,
                             dependent: :delete_all,
                             after_add: :association_add,
                             before_remove: :association_remove

  has_and_belongs_to_many :origins, join_table: :products_origins,
                                    dependent: :delete_all,
                                    after_add: :association_add, before_remove: :association_remove

  has_and_belongs_to_many :projects, join_table: :projects_products,
                                     dependent: :delete_all,
                                     after_add: :association_add,
                                     before_remove: :association_remove

  has_and_belongs_to_many :endorsers, join_table: :products_endorsers,
                                      dependent: :delete_all

  has_many :product_sustainable_development_goals, dependent: :delete_all,
                                                   after_add: :association_add, before_remove: :association_remove
  has_many :sustainable_development_goals, through: :product_sustainable_development_goals,
                                           dependent: :delete_all,
                                           after_add: :association_add, before_remove: :association_remove

  has_many :include_relationships, -> { where(relationship_type: 'composed') },
           foreign_key: :from_product_id, class_name: 'ProductProductRelationship',
           after_add: :association_add, before_remove: :association_remove
  has_many :includes, through: :include_relationships, source: :to_product,
                      after_add: :association_add, before_remove: :association_remove

  has_many :interop_relationships, -> { where(relationship_type: 'interoperates') },
           foreign_key: :from_product_id, class_name: 'ProductProductRelationship',
           after_add: :association_add, before_remove: :association_remove
  has_many :interoperates_with, through: :interop_relationships, source: :to_product,
                                dependent: :delete_all,
                                after_add: :association_add, before_remove: :association_remove

  has_many :references, foreign_key: :to_product_id, class_name: 'ProductProductRelationship',
                        dependent: :delete_all,
                        after_add: :association_add, before_remove: :association_remove

  validates :name, presence: true, length: { maximum: 300 }

  scope :name_contains, ->(name) { where("LOWER(products.name) like LOWER(?)", "%#{name}%") }
  scope :slug_starts_with, ->(slug) { where("LOWER(products.slug) like LOWER(?)", "#{slug}%\\_") }

  def self.first_duplicate(name, slug)
    find_by("name = ? OR slug = ? OR ? = ANY(aliases)", name, slug, name)
  end

  def image_file
    if File.exist?(File.join('public', 'assets', 'products', "#{slug}.png"))
      return "/assets/products/#{slug}.png"
    else
      if product_type == "dataset"
        return "/assets/products/dataset_placeholder.png"
      else
        return "/assets/products/prod_placeholder.png"
      end
    end
  end

  def sectors_localized
    sectors.where('locale = ?', I18n.locale)
  end

  def product_description_localized
    description = product_descriptions.order('LENGTH(description) DESC')
                                      .find_by(locale: I18n.locale)
    if description.nil?
      description = product_descriptions.order('LENGTH(description) DESC')
                                        .find_by(locale: 'en')
    end
    description
  end

  def owner
    owner = User.joins(:products).where(products: { id: id })
    unless owner.empty?
      owner.first.id
    end
  end

  def main_repository
    product_repositories.find_by(main_repository: true)
  end

  def current_projects(num_projects)
    projects.limit(num_projects[:first])
  end

  def maturity_scores
    maturity_rubric = MaturityRubric.find_by(slug: 'legacy_rubric')
    if !maturity_rubric.nil?
      maturity_scores = calculate_maturity_scores(id, maturity_rubric.id)[:rubric_scores].first
    else
      maturity_scores = calculate_maturity_scores(id, nil)[:rubric_scores].first
    end
    if !maturity_scores.nil?
      maturity_scores = maturity_scores[:category_scores]
    end
    maturity_scores
  end

  # overridden
  def to_param
    slug
  end

  def self.to_csv
    attributes = %w{id name slug website repository organizations origins}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |p|
        organizations = p.organizations
                         .map(&:name)
                         .join('; ')
        origins = p.origins
                   .map(&:name)
                   .join('; ')

        csv << [p.id, p.name, p.slug, p.website, p.main_repository, organizations, origins]
      end
    end
  end

  def self_url(options = {})
    return "#{options[:api_path]}/products/#{slug}" if options[:api_path].present?
    return options[:item_path] if options[:item_path].present?
    return "#{options[:collection_path]}/#{slug}" if options[:collection_path].present?
  end

  def collection_url(options = {})
    return "#{options[:api_path]}/products" if options[:api_path].present?
    return options[:item_path].sub("/#{slug}", '') if options[:item_path].present?
    return options[:collection_path] if options[:collection_path].present?
  end

  def api_path(options = {})
    return options[:api_path] if options[:api_path].present?
    return options[:item_path].sub("/products/#{slug}", '') if options[:item_path].present?
    return options[:collection_path].sub('/products', '') if options[:collection_path].present?
  end

  def as_json(options = {})
    json = super(options)
    if options[:include_relationships].present?
      json['organizations'] = organizations.as_json({ only: [:name, :slug, :website], api_path: api_path(options) })
      json['origins'] = origins.as_json({ only: [:name, :slug], api_path: api_path(options), api_source: 'products' })
      json['building_blocks'] = building_blocks.as_json({ only: [:name, :slug], api_path: api_path(options) })
      json['sustainable_development_goals'] = sustainable_development_goals.as_json({ only: [:name, :slug, :number],
                                                                                      api_path: api_path(options) })
      json['repositories'] = product_repositories.as_json({ only: [:name, :slug, :absolute_url],
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

  def self.serialization_options
    {
      except: [:id, :statistics, :license_analysis, :default_url, :status, :created_at, :updated_at],
      include: {
        organizations: { only: [:name] },
        sectors: { only: [:name] },
        origins: { only: [:name] },
        building_blocks: { only: [:name] },
        sustainable_development_goals: { only: [:number, :name] }
      }
    }
  end
end
