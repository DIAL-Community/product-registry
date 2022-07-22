# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :workflow do
    sequence(:name)
    sequence(:slug)
  end
end
