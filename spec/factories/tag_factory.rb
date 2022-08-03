# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :tag do
    sequence(:slug)
    sequence(:name)
  end
end
