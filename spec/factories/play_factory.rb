# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :play do
    sequence(:slug)
    sequence(:name)
    sequence(:id)
  end
end
