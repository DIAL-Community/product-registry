module Types
  class OrganizationDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :organization_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end
  
  class OrganizationType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: false

    field :organizatoin_descriptions, [Types::OrganizationDescriptionType], null: true
  end
end