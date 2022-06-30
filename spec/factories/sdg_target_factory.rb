# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :sdg_target do
    sequence(:id)
    sequence(:name) { |name| "SDG Target: #{name}" }
    sequence(:target_number) { 1 }
    sequence(:sdg_number) { FactoryBot.create(:sustainable_development_goal).number }
  end
end
