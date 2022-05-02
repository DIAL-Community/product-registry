# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :organization do
    sequence(:name) { |name| "Organization: #{name}" }
    sequence(:slug) { |slug| "slug_#{slug}" }
    sequence(:website)
  end
end
