class ProductBuildingBlock < ApplicationRecord
  include MappingStatusType

  belongs_to :product
  belongs_to :building_block
end
