module Types
  class ProjectDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :project_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end
  
  class ProjectType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false

    field :project_descriptions, [Types::ProjectDescriptionType], null: true
    field :origin, Types::OriginType, null: true

    field :organizations, [Types::OrganizationType], null: true
    field :products, [Types::ProductType], null: true
    field :countries, [Types::CountryType], null: true
  end
end
