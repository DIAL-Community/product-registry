class ProductSustainableDevelopmentGoal < ApplicationRecord
  include MappingStatusType

  belongs_to :product
  belongs_to :sustainable_development_goal
end
