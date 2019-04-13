class Product < ApplicationRecord
  has_one :product_assessment
  has_and_belongs_to_many :organizations
  has_and_belongs_to_many :building_blocks, join_table: :products_building_blocks
  validates :name,  presence: true, length: { maximum: 300 }

  scope :starts_with, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
end
