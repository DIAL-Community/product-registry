# frozen_string_literal: true

class Deploy < ApplicationRecord
  belongs_to :user
  belongs_to :product
end
