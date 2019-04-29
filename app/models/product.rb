class Product < ApplicationRecord
  has_one :product_assessment
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :building_blocks, join_table: :products_building_blocks

  has_many :include_relationships, -> { where(relationship_type: 'composed')}, foreign_key: :from_product_id, class_name: 'ProductProductRelationship'
  has_many :includes, through: :include_relationships, source: :to_product

  has_many :interop_relationships, -> { where(relationship_type: 'interoperates')}, foreign_key: :from_product_id, class_name: 'ProductProductRelationship'
  has_many :interoperates_with, through: :interop_relationships, source: :to_product

  has_many :references, foreign_key: :to_product_id, class_name: 'ProductProductRelationship'

  validates :name,  presence: true, length: { maximum: 300 }
  validate :no_duplicates

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}%")}

  def image_file
    ['png','jpg','gif'].each do |extension|
      if File.exist?(File.join('app','assets','images','products',"#{slug}.#{extension}"))
        return "products/#{slug}.#{extension}"
      end
    end

    "products/prod_placeholder.png"
  end

  private

  def no_duplicates
    size = Product.where(slug: slug).size
    if size > 0
      errors.add(:duplicate, 'has duplicate.')
    end
  end

end
