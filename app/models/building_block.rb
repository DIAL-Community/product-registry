class BuildingBlock < ApplicationRecord
  has_and_belongs_to_many :products, join_table: :products_building_blocks
  has_and_belongs_to_many :workflows, join_table: :workflows_building_blocks

  scope :name_contains, -> (name) { where("LOWER(name) like LOWER(?)", "%#{name}%")}
  scope :slug_starts_with, -> (slug) { where("LOWER(slug) like LOWER(?)", "#{slug}\\_%")}

  def image_file
    if File.exist?(File.join('app','assets','images','products',"#{slug}.png"))
      return "building_blocks/#{slug}.png"
    else
      return "building_blocks/bb_placeholder.png"
    end
  end

end
