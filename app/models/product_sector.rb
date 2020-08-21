class ProductSector < ApplicationRecord
  include MappingStatusType

  belongs_to :product
  belongs_to :sector
end
