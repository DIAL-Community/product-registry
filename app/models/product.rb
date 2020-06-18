class Product < ApplicationRecord
  include Auditable

  attr_accessor :product_description

  has_many :product_descriptions
  has_many :product_versions
  has_and_belongs_to_many :use_case_steps, join_table: :use_case_steps_products
  has_many :product_classifications
  has_many :classifications, through: :product_classifications

  has_and_belongs_to_many :organizations, after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :sectors, join_table: :products_sectors, after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :building_blocks, join_table: :products_building_blocks, after_add: :association_add, before_remove: :association_remove
  has_and_belongs_to_many :origins, join_table: :products_origins, after_add: :association_add, before_remove: :association_remove

  has_and_belongs_to_many :projects, join_table: :projects_products,
                                     dependent: :delete_all,
                                     after_add: :association_add,
                                     before_remove: :association_remove

  has_many :products_sustainable_development_goals, dependent: :delete_all
  has_many :sustainable_development_goals, through: :products_sustainable_development_goals, after_add: :association_add, before_remove: :association_remove

  has_many :include_relationships, -> { where(relationship_type: 'composed')}, foreign_key: :from_product_id, class_name: 'ProductProductRelationship'
  has_many :includes, through: :include_relationships, source: :to_product, after_add: :association_add, before_remove: :association_remove

  has_many :interop_relationships, -> { where(relationship_type: 'interoperates')}, foreign_key: :from_product_id, class_name: 'ProductProductRelationship'
  has_many :interoperates_with, through: :interop_relationships, source: :to_product, after_add: :association_add, before_remove: :association_remove

  has_many :references, foreign_key: :to_product_id, class_name: 'ProductProductRelationship', after_add: :association_add, before_remove: :association_remove

  validates :name,  presence: true, length: { maximum: 300 }

  scope :name_contains, -> (name) { where("LOWER(products.name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(products.slug) like LOWER(?)", "#{slug}%\\_")}

  def self.first_duplicate(name, slug)
    find_by("name = ? OR slug = ? OR ? = ANY(aliases)", name, slug, name)
  end

  def image_file
    if File.exist?(File.join('public','assets','products',"#{slug}.png"))
      return "/assets/products/#{slug}.png"
    else
      return "/assets/products/prod_placeholder.png"
    end
  end

  def to_param  # overridden
    slug
  end

end
