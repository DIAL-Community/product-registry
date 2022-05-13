# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :country do
    sequence(:slug)
    sequence(:name)
    sequence(:code)
    sequence(:code_longer)
    sequence(:latitude)
    sequence(:longitude)
  end
end
