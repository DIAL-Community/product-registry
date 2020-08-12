class ProductsBuildingBlock < ApplicationRecord
  belongs_to :product
  belongs_to :building_block
end