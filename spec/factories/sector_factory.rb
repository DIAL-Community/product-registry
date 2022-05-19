# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :sector do
    sequence(:slug)
    sequence(:name)
    sequence(:origin)
  end
end
