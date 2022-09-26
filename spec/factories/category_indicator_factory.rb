# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :category_indicator do
    sequence(:name)
    sequence(:slug)
    sequence(:weight)
    sequence(:rubric_category_id)
  end
end
