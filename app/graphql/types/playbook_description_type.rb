module Types
  class PlaybookDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :playbook_id, Integer, null: true
    field :locale, String, null: false
    field :overview, String, null: false
    field :audience, String, null: false
    field :outcomes, String, null: false
    field :cover, String, null: true
  end
end
