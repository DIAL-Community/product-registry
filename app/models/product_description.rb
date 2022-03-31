# frozen_string_literal: true

class ProductDescription < ApplicationRecord
  include Auditable
  belongs_to :product
end
