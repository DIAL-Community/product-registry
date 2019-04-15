class BuildingBlock < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :products_building_blocks

  scope :starts_with, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
end
