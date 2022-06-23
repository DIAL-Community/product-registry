# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :project do
    sequence(:name) { |name| "Project: #{name}" }
    sequence(:slug) { |slug| "slug_#{slug}" }
    origin { FactoryBot.create(:origin) }
    products { [FactoryBot.create(:product)] }
  end
end
