# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :playbook do
    sequence(:slug)
    sequence(:name)
    sequence(:author)
    sequence(:id)
    sequence(:draft)
  end
end
