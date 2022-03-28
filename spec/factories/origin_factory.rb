# frozen_string_literal: true

require 'factory_bot'

FactoryBot.define do
  factory :origin do
    sequence(:name) { |name| "Origin: #{name}" }
    sequence(:slug) { |slug| "slug_#{slug}" }
    sequence(:description)
  end
end
