module Types
  class SectorType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :parent_sector_id, ID, null: true
    field :origin_id, Integer, null: true
    field :is_displayable, Boolean, null: true
    field :locale, String, null: true
    field :sub_sectors, [Types::SectorType], null: true
  end
end