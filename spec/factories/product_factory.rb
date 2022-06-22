# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :product do
    origins { [FactoryBot.create(:origin)] }
    sequence(:id)
    sequence(:name) { |name| "Product: #{name}" }
    sequence(:slug) { |slug| "slug_#{slug}" }
    sequence(:website)
    sectors { [FactoryBot.create(:sector)] }
  end
end
