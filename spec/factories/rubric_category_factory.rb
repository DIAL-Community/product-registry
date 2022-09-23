# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :rubric_category do
    sequence(:id)
    sequence(:name)
    sequence(:slug)
    sequence(:weight)
  end
end
