class Product < ApplicationRecord
  has_one :product_assessment
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :building_blocks, join_table: :products_building_blocks

  has_many :target_product_rel, foreign_key: :from_product_id, class_name: 'ProductProductRelationship'
  has_many :includes, through: :target_product_rel, source: :include

  has_many :source_product_rel, foreign_key: :to_product_id, class_name: 'ProductProductRelationship'
  has_many :references, through: :source_product_rel, source: :reference

  validates :name,  presence: true, length: { maximum: 300 }

  scope :starts_with, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
end
