module Types
  class ActivityDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :activity_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end
end
