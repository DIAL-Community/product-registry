module Types
  class ActivityType < Types::BaseObject
    field :id, ID, null: false
    field :playbook_id, Integer, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :description, String, null: true
    field :phase, String, null: true
    field :resources, GraphQL::Types::JSON, null: false
    field :playbook_questions_id, Integer, null: true
    field :order, Integer, null: true
    field :media_url, String, null: true
  end
end
