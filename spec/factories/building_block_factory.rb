# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :building_block do
    sequence(:name) { |name| "Building Block: #{name}" }
    sequence(:slug) { |slug| "slug_#{slug}" }
  end
end
