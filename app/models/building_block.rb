class BuildingBlock < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :products_building_blocks
  has_and_belongs_to_many :workflows, join_table: :workflows_building_blocks

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}

end
