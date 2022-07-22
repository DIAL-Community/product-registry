# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :use_case_step do
    sequence(:slug)
    sequence(:name)
    sequence(:step_number)
    use_case { FactoryBot.create(:use_case) }
  end
end
