module Types
  class CandidateProductType < Types::BaseObject
    field :id, ID, null: false
    field :slug, String, null: false
    field :name, String, null: true
    field :website, String, null: true
    field :repository, String, null: true

    field :rejected, Boolean, null: true
  end
end
