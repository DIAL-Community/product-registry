module Types
  class DigitalPrincipleType < Types::BaseObject
    field :name, String, null: false
    field :slug, String, null: false
    field :url, String, null: false
  end

  class ResourcesType < Types::BaseObject
    field :name, String, null: false
    field :image_url, String, null: false
    field :link, String, null: false
  end

  class WizardType < Types::BaseObject
    field :digital_principles, [Types::DigitalPrincipleType], null: true
    field :projects, [Types::ProjectType], null: true
    field :products, [Types::ProductType], null: true
    field :organizations, [Types::OrganizationType], null: true
    field :use_cases, [Types::UseCaseType], null: true
    field :building_blocks, [Types::BuildingBlockType], null: true
    field :resources, [Types::ResourcesType], null: true
  end
end