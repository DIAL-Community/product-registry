class BuildingBlock < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :products_building_blocks
end
