# frozen_string_literal: true

class DigitalPrinciple < ApplicationRecord
  has_many :principle_descriptions, dependent: :destroy
end
