# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :sustainable_development_goal do
    sequence(:name) { |name| "SDG: #{name}" }
    sequence(:slug) { |slug| "slug_#{slug}" }
    sequence(:long_title) { "some long title" }
    sequence(:number) { 1 }
  end
end
