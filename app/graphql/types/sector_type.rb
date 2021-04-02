module Types
  class SectorType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :slug, String, null: false
    field :parent_sector_id, ID, null: true
    field :origin_id, Integer, null: true
    field :locale, String, null: true
  end
end