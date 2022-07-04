# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :use_case do
    sequence(:slug)
    sequence(:name)
    sector { FactoryBot.create(:sector) }
  end
end
