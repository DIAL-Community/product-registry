class ProductDescription < ApplicationRecord
  include Auditable
  belongs_to :product
end
