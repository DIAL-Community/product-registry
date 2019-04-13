class ProductAssessment < ApplicationRecord
  belongs_to :product
  enum digisquare_maturity_level: { low: 1, medium: 2, high: 3 }
end
