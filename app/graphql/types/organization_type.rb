# frozen_string_literal: true

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
    field :image_file, String, null: true
    field :website, String, null: true

    field :is_mni, Boolean, null: true
    field :is_endorser, Boolean, null: true
    field :when_endorsed, GraphQL::Types::ISO8601Date, null: true
    field :endorser_level, String, null: true

    field :organization_descriptions, [Types::OrganizationDescriptionType], null: true

    field :sectors, [Types::SectorType], null: true, method: :sectors_localized
    field :organization_description, Types::OrganizationDescriptionType, null: true,
                                                                         method: :organization_description_localized

    field :countries, [Types::CountryType], null: true, method: :organization_countries_ordered
    field :offices, [Types::OfficeType], null: true
    field :projects, [Types::ProjectType], null: false
    field :products, [Types::ProductType], null: false
    field :contacts, [Types::ContactType], null: true
    field :aliases, GraphQL::Types::JSON, null: true
  end
end
