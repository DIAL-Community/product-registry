class ProductAssessment < ApplicationRecord
  belongs_to :product
  enum digisquare_maturity_level: { low: 'low', medium: 'medium', high: 'high' }
end
