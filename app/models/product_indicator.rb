class ProductIndicator < ApplicationRecord
  belongs_to :product
  belongs_to :category_indicator
end
