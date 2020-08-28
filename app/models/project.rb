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
  has_and_belongs_to_many :sectors, join_table: :projects_sectors
  has_and_belongs_to_many :sustainable_development_goals, join_table: :projects_sdgs, association_foreign_key: :sdg_id
  has_many :project_descriptions

  belongs_to :origin

  scope :name_contains, ->(name) { where('LOWER(projects.name) like LOWER(?)', "%#{name}%") }

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

  def origin_image_file
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
end
