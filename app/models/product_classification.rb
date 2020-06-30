class ProductClassification < ApplicationRecord
  belongs_to :product
  belongs_to :classification
end
