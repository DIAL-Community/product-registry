# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :contact do
    sequence(:id)
    sequence(:slug)
    sequence(:name)
    sequence(:email)
    sequence(:title)
  end
end
