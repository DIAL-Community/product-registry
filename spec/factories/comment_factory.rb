# frozen_string_literal: true

FactoryBot.define do
  # Incomplete factory definition. Add more field as needed.
  factory :comment do
    sequence(:id)
    sequence(:comment_id)
    sequence(:comment_object_type)
    sequence(:comment_object_id)
    sequence(:text)
  end
end
