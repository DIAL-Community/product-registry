class BuildingBlockDescription < ApplicationRecord
  include Auditable
  belongs_to :building_block
end