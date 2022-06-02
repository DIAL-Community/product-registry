# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :organization do
    sequence(:id)
    sequence(:name) { |name| "Organization: #{name}" }
    sequence(:slug) { |slug| "slug_#{slug}" }
    sequence(:website) { |website| "www: #{website}" }
    sequence(:countries) { |country| "country_#{country}" }
    sequence(:sectors) { |sector| "sector_#{sector}" }
  end
end
