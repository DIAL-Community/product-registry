class DigitalPrinciple < ApplicationRecord
  has_many :principle_descriptions, dependent: :destroy
end
