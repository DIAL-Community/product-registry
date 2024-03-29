module Types
  class OrganizationDescriptionType < Types::BaseObject
    field :id, ID, null: false
    field :organization_id, Integer, null: true
    field :locale, String, null: false
    field :description, String, null: false
  end

  class OfficeType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :latitude, String, null: false
    field :longitude, String, null: false
    field :city, String, null: false
    field :organization_id, Integer, null: false
  end

  class OrganizationType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :image_file, String, null: false
    field :website, String, null: true

    field :is_endorser, Boolean, null: true
    field :when_endorsed, GraphQL::Types::ISO8601Date, null: true

    field :organization_descriptions, [Types::OrganizationDescriptionType], null: true
    field :sectors, [Types::SectorType], null: true
    field :countries, [Types::CountryType], null: true
    field :offices, [Types::OfficeType], null: true
    field :projects, [Types::ProjectType], null: false
  end
end
