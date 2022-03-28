# frozen_string_literal: true

class Region < ApplicationRecord
  belongs_to :country
end
